# دليل التثبيت والتشغيل

## المتطلبات الأساسية

### 1. Flutter SDK
تأكد من تثبيت Flutter SDK (الإصدار 3.9.0 أو أحدث):
```bash
flutter --version
```

### 2. Android Studio أو VS Code
- Android Studio مع Android SDK
- أو VS Code مع ملحقات Flutter و Dart

---

## خطوات التثبيت

### 1. تثبيت المكتبات
```bash
flutter pub get
```

### 2. توليد ملفات Hive (اختياري - تم إنشاؤها مسبقًا)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. إعداد Android

#### تحديث Gradle (إذا لزم الأمر)
تأكد من أن `android/build.gradle.kts` يحتوي على:
```kotlin
buildscript {
    ext.kotlin_version = '1.9.0'
}
```

#### الحد الأدنى لإصدار Android
في `android/app/build.gradle.kts`:
```kotlin
minSdk = 21
targetSdk = 34
```

### 4. الأذونات
جميع الأذونات المطلوبة تم إضافتها بالفعل في `AndroidManifest.xml`

---

## التشغيل

### 1. تشغيل التطبيق في وضع التطوير
```bash
flutter run
```

### 2. بناء APK للإصدار
```bash
flutter build apk --release
```

### 3. بناء App Bundle
```bash
flutter build appbundle --release
```

---

## استكشاف الأخطاء

### مشكلة: خطأ في المكتبات
**الحل:**
```bash
flutter clean
flutter pub get
```

### مشكلة: خطأ في Hive Adapters
**الحل:**
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### مشكلة: الإشعارات لا تعمل
**الحل:**
- تأكد من منح أذونات الإشعارات من إعدادات الجهاز
- تحقق من إعدادات توفير البطارية
- اسمح للتطبيق بالعمل في الخلفية

### مشكلة: API لا يعمل
**الحل:**
- تحقق من اتصال الإنترنت
- تأكد من أن API متاح: https://alquran.cloud/api
- امسح Cache من إعدادات التطبيق

---

## اختبار الميزات الجديدة

### 1. اختبار الورد اليومي
```
1. افتح القائمة الجانبية
2. اختر "الورد اليومي"
3. سجل قراءة جديدة
4. تحقق من التقدم والإحصائيات
```

### 2. اختبار خريطة التسبيح
```
1. افتح القائمة الجانبية
2. اختر "خريطة التسبيح"
3. اضغط على الدائرة للتسبيح
4. احفظ الجلسة
5. تحقق من الإحصائيات
```

### 3. اختبار التذكيرات
```
1. افتح القائمة الجانبية
2. اختر "التذكيرات"
3. فعّل تذكير القرآن
4. حدد وقتًا قريبًا للاختبار
5. احفظ وانتظر الإشعار
```

### 4. اختبار مشاركة الآيات
```
1. افتح أي سورة
2. اضغط مطولاً على آية
3. اختر "مشاركة"
4. جرّب المشاركة كنص وكصورة
```

---

## بنية المشروع

```
lib/
├── app/
│   ├── api/
│   │   └── alquran_api_service.dart       # خدمة API
│   ├── models/
│   │   ├── daily_goal_model.dart          # نموذج الورد اليومي
│   │   ├── tasbeeh_model.dart             # نموذج التسبيح
│   │   └── *.g.dart                       # Hive Adapters
│   ├── pages/
│   │   ├── daily_goal/                    # صفحة الورد اليومي
│   │   ├── tasbeeh/                       # صفحة التسبيح
│   │   ├── notifications/                 # صفحة الإشعارات
│   │   └── ...
│   ├── services/
│   │   └── notification_service.dart      # خدمة الإشعارات
│   ├── statemanagment/
│   │   └── daily_goal_provider.dart       # Provider للورد اليومي
│   └── widgets/
│       └── ayah_share_widget.dart         # ويدجت المشاركة
└── main.dart                              # نقطة الدخول الرئيسية
```

---

## ملاحظات مهمة

### 1. قاعدة البيانات
- يستخدم التطبيق Hive للتخزين المحلي
- البيانات تُحفظ في مسار التطبيق الخاص
- يمكن مسح البيانات من إعدادات التطبيق

### 2. الإشعارات
- تتطلب Android 13+ موافقة صريحة من المستخدم
- يجب السماح للتطبيق بالعمل في الخلفية
- قد تحتاج لتعطيل توفير البطارية للتطبيق

### 3. الأداء
- التطبيق مُحسّن للأداء العالي
- يستخدم Caching للتقليل من طلبات API
- الرسوم البيانية تُحدّث تلقائيًا

### 4. التوافق
- Android 7.0 (API 24) وأعلى
- iOS 12.0 وأعلى (غير مختبر بالكامل)

---

## الدعم الفني

في حال واجهت أي مشاكل:

1. تحقق من سجلات Flutter:
```bash
flutter logs
```

2. امسح البيانات وأعد المحاولة:
```bash
flutter clean
flutter pub get
flutter run
```

3. تحقق من الأذونات في الإعدادات

4. تأكد من تحديث Flutter:
```bash
flutter upgrade
```

---

## موارد مفيدة

- [وثائق Flutter](https://flutter.dev/docs)
- [Hive Database](https://docs.hivedb.dev/)
- [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)
- [AlQuran Cloud API](https://alquran.cloud/api)

---

تم التطوير بحب لخدمة كتاب الله العزيز 💚
