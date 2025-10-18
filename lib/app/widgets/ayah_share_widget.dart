import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class AyahShareWidget extends StatelessWidget {
  final String ayahText;
  final String surahName;
  final int ayahNumber;
  final ScreenshotController screenshotController;

  const AyahShareWidget({
    super.key,
    required this.ayahText,
    required this.surahName,
    required this.ayahNumber,
    required this.screenshotController,
  });

  Future<void> shareAsText() async {
    final text = '$ayahText\n\n﴿ $surahName - الآية $ayahNumber ﴾';
    await Share.share(text);
  }

  Future<void> shareAsImage(BuildContext context) async {
    try {
      final image = await screenshotController.capture();
      if (image != null) {
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/ayah_${DateTime.now().millisecondsSinceEpoch}.png';
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(image);

        await Share.shareXFiles(
          [XFile(imagePath)],
          text: '$surahName - الآية $ayahNumber',
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'حدث خطأ أثناء مشاركة الصورة',
            style: const TextStyle(fontFamily: 'Amiri'),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.format_quote,
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Text(
              ayahText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Amiri',
                fontSize: 24,
                height: 2,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '﴿ $surahName - الآية $ayahNumber ﴾',
                style: const TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.book, color: Colors.white70, size: 16),
                SizedBox(width: 8),
                Text(
                  'القرآن الكريم',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showShareAyahDialog(
  BuildContext context,
  String ayahText,
  String surahName,
  int ayahNumber,
) async {
  final screenshotController = ScreenshotController();

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AyahShareWidget(
            ayahText: ayahText,
            surahName: surahName,
            ayahNumber: ayahNumber,
            screenshotController: screenshotController,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'مشاركة الآية',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final widget = AyahShareWidget(
                            ayahText: ayahText,
                            surahName: surahName,
                            ayahNumber: ayahNumber,
                            screenshotController: screenshotController,
                          );
                          await widget.shareAsText();
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.text_fields, color: Colors.white),
                        label: const Text(
                          'نص',
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final widget = AyahShareWidget(
                            ayahText: ayahText,
                            surahName: surahName,
                            ayahNumber: ayahNumber,
                            screenshotController: screenshotController,
                          );
                          await widget.shareAsImage(context);
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.image, color: Colors.white),
                        label: const Text(
                          'صورة',
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'إلغاء',
                    style: TextStyle(fontFamily: 'Amiri', fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
