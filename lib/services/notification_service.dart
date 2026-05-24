import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance =
  NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  bool _sudahInit = false;

  Future<void> init() async {
    if (_sudahInit) return;

    tz.initializeTimeZones();
    final offsetJam =
        DateTime.now().timeZoneOffset.inHours;

    String namaTimezone;
    switch (offsetJam) {
      case 7:
        namaTimezone = 'Asia/Jakarta';
        break;
      case 8:
        namaTimezone = 'Asia/Makassar';
        break;
      case 9:
        namaTimezone = 'Asia/Jayapura';
        break;
      default:
        namaTimezone = 'Asia/Jakarta';
    }
    tz.setLocalLocation(tz.getLocation(namaTimezone));

    const AndroidInitializationSettings android =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(
      const InitializationSettings(android: android),
    );

    await _mintaSemuaIzin();
    _sudahInit = true;
  }

  // Minta semua izin yang dibutuhkan sekaligus
  Future<void> _mintaSemuaIzin() async {
    // 1. Izin notifikasi
    final statusNotif =
    await Permission.notification.status;
    if (!statusNotif.isGranted) {
      await Permission.notification.request();
    }

    // 2. Izin battery optimization
    // (agar notifikasi tetap jalan saat app di background)
    final statusBattery =
    await Permission.ignoreBatteryOptimizations.status;
    if (!statusBattery.isGranted) {
      await Permission.ignoreBatteryOptimizations.request();
    }
  }

  // Tampilkan notifikasi sekarang (test)
  Future<void> tampilkanNotifikasi({
    required int id,
    required String judul,
    required String isi,
  }) async {
    const AndroidNotificationDetails android =
    AndroidNotificationDetails(
      'one_step_channel',
      'One-Step Notifikasi',
      channelDescription: 'Notifikasi aplikasi One-Step',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    await _plugin.show(
      id,
      judul,
      isi,
      const NotificationDetails(android: android),
    );
  }

  // Jadwalkan reminder harian
  Future<void> jadwalkanReminder({
    required int id,
    required String judul,
    required String isi,
    required int jam,
    required int menit,
  }) async {
    // Pastikan izin sudah ada
    await _mintaSemuaIzin();

    // Batalkan yang lama
    await _plugin.cancel(id);

    final jadwal = _waktuBerikutnya(jam, menit);

    await _plugin.zonedSchedule(
      id,
      judul,
      isi,
      jadwal,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'one_step_reminder',
          'One-Step Reminder Harian',
          channelDescription:
          'Pengingat olahraga harian One-Step',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          fullScreenIntent: true,
          category: AndroidNotificationCategory.alarm,
        ),
      ),
      androidScheduleMode:
      AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation
          .absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _waktuBerikutnya(int jam, int menit) {
    final now = tz.TZDateTime.now(tz.local);
    var jadwal = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      jam,
      menit,
    );
    if (jadwal.isBefore(now) ||
        jadwal.isAtSameMomentAs(now)) {
      jadwal = jadwal.add(const Duration(days: 1));
    }
    return jadwal;
  }

  Future<List<PendingNotificationRequest>>
  getPendingNotifikasi() async {
    return await _plugin.pendingNotificationRequests();
  }

  Future<void> batalkanReminder(int id) async {
    await _plugin.cancel(id);
  }

  Future<void> batalkanSemua() async {
    await _plugin.cancelAll();
  }
}