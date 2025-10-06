import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class AlQuranApiService {
  static const String baseUrl = 'https://api.alquran.cloud/v1';
  final Dio _dio = Dio();

  AlQuranApiService() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  Future<Map<String, dynamic>> getQuranByEdition(String edition) async {
    try {
      final cacheKey = 'quran_$edition';
      final box = await Hive.openBox('quran_cache');

      if (box.containsKey(cacheKey)) {
        final cached = box.get(cacheKey);
        if (cached != null) {
          return Map<String, dynamic>.from(cached);
        }
      }

      final response = await _dio.get('/quran/$edition');
      if (response.statusCode == 200) {
        await box.put(cacheKey, response.data);
        return response.data;
      }
      throw Exception('Failed to load Quran');
    } catch (e) {
      print('Error fetching Quran: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getSurah(int surahNumber, String edition) async {
    try {
      final cacheKey = 'surah_${surahNumber}_$edition';
      final box = await Hive.openBox('quran_cache');

      if (box.containsKey(cacheKey)) {
        final cached = box.get(cacheKey);
        if (cached != null) {
          return Map<String, dynamic>.from(cached);
        }
      }

      final response = await _dio.get('/surah/$surahNumber/$edition');
      if (response.statusCode == 200) {
        await box.put(cacheKey, response.data);
        return response.data;
      }
      throw Exception('Failed to load Surah');
    } catch (e) {
      print('Error fetching Surah: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getAyah(String reference, String edition) async {
    try {
      final response = await _dio.get('/ayah/$reference/$edition');
      if (response.statusCode == 200) {
        return response.data;
      }
      throw Exception('Failed to load Ayah');
    } catch (e) {
      print('Error fetching Ayah: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getJuz(int juzNumber, String edition) async {
    try {
      final cacheKey = 'juz_${juzNumber}_$edition';
      final box = await Hive.openBox('quran_cache');

      if (box.containsKey(cacheKey)) {
        final cached = box.get(cacheKey);
        if (cached != null) {
          return Map<String, dynamic>.from(cached);
        }
      }

      final response = await _dio.get('/juz/$juzNumber/$edition');
      if (response.statusCode == 200) {
        await box.put(cacheKey, response.data);
        return response.data;
      }
      throw Exception('Failed to load Juz');
    } catch (e) {
      print('Error fetching Juz: $e');
      rethrow;
    }
  }

  Future<List<dynamic>> getAllEditions() async {
    try {
      final cacheKey = 'all_editions';
      final box = await Hive.openBox('quran_cache');

      if (box.containsKey(cacheKey)) {
        final cached = box.get(cacheKey);
        if (cached != null) {
          return List<dynamic>.from(cached);
        }
      }

      final response = await _dio.get('/edition');
      if (response.statusCode == 200) {
        final editions = response.data['data'];
        await box.put(cacheKey, editions);
        return editions;
      }
      throw Exception('Failed to load Editions');
    } catch (e) {
      print('Error fetching Editions: $e');
      rethrow;
    }
  }

  Future<List<dynamic>> getAudioEditions() async {
    try {
      final response = await _dio.get('/edition/format/audio');
      if (response.statusCode == 200) {
        return response.data['data'];
      }
      throw Exception('Failed to load Audio Editions');
    } catch (e) {
      print('Error fetching Audio Editions: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> searchQuran(
      String keyword, int? surah, String edition) async {
    try {
      final path = surah != null
          ? '/search/$keyword/$surah/$edition'
          : '/search/$keyword/all/$edition';

      final response = await _dio.get(path);
      if (response.statusCode == 200) {
        return response.data;
      }
      throw Exception('Failed to search Quran');
    } catch (e) {
      print('Error searching Quran: $e');
      rethrow;
    }
  }

  Future<List<dynamic>> getAllSurahs() async {
    try {
      final response = await _dio.get('/surah');
      if (response.statusCode == 200) {
        return response.data['data'];
      }
      throw Exception('Failed to load Surahs');
    } catch (e) {
      print('Error fetching Surahs: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getPage(int pageNumber, String edition) async {
    try {
      final response = await _dio.get('/page/$pageNumber/$edition');
      if (response.statusCode == 200) {
        return response.data;
      }
      throw Exception('Failed to load Page');
    } catch (e) {
      print('Error fetching Page: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getSajdaAyahs(String edition) async {
    try {
      final response = await _dio.get('/sajda/$edition');
      if (response.statusCode == 200) {
        return response.data;
      }
      throw Exception('Failed to load Sajda Ayahs');
    } catch (e) {
      print('Error fetching Sajda Ayahs: $e');
      rethrow;
    }
  }

  void clearCache() async {
    final box = await Hive.openBox('quran_cache');
    await box.clear();
  }
}
