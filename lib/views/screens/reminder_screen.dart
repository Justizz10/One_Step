import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/notification_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/motivasi_helper.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() =>
      _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final NotificationService _notifService =
  NotificationService();
  bool _reminderAktif = false;
  TimeOfDay _waktuReminder =
  const TimeOfDay(hour: 7, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadPreferensi();
  }

  Future<void> _loadPreferensi() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _reminderAktif =
          prefs.getBool('reminder_aktif') ?? false;
      _waktuReminder = TimeOfDay(
        hour: prefs.getInt('reminder_jam') ?? 7,
        minute: prefs.getInt('reminder_menit') ?? 0,
      );
    });
  }

  Future<void> _simpanPreferensi() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('reminder_aktif', _reminderAktif);
    await prefs.setInt(
        'reminder_jam', _waktuReminder.hour);
    await prefs.setInt(
        'reminder_menit', _waktuReminder.minute);
  }

  Future<void> _toggleReminder(bool aktif) async {
    setState(() => _reminderAktif = aktif);

    if (aktif) {
      await _notifService.jadwalkanReminder(
        id: 1,
        judul: '🏃 Waktunya Olahraga!',
        isi: MotivasiHelper.getMotivasiHariIni(),
        jam: _waktuReminder.hour,
        menit: _waktuReminder.minute,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Reminder aktif pukul '
                  '${_waktuReminder.format(context)} ✅',
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } else {
      await _notifService.batalkanReminder(1);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reminder dinonaktifkan'),
            backgroundColor: AppColors.warning,
          ),
        );
      }
    }

    await _simpanPreferensi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Pengaturan Reminder',
            style: AppTextStyles.heading2),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildKartuToggle(context),
            const SizedBox(height: 20),
            _buildPilihWaktu(context),
            const SizedBox(height: 20),
            _buildKartuMotivasi(),
            const SizedBox(height: 20),
            _buildTombolTest(context),
            const SizedBox(height: 12),
            _buildTombolCekTerjadwal(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ─── TOGGLE REMINDER ──────────────────────────────
  Widget _buildKartuToggle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reminder Harian',
                  style: AppTextStyles.heading3
                      .copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  _reminderAktif
                      ? 'Aktif · Setiap hari pukul '
                      '${_waktuReminder.format(context)}'
                      : 'Nonaktif · Tap toggle untuk aktifkan',
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13),
                ),
              ],
            ),
          ),
          Switch(
            value: _reminderAktif,
            onChanged: _toggleReminder,
            activeColor: Colors.white,
            activeTrackColor: Colors.white30,
          ),
        ],
      ),
    );
  }

  // ─── PILIH WAKTU ──────────────────────────────────
  Widget _buildPilihWaktu(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Waktu Pengingat',
            style: AppTextStyles.heading3),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () async {
            final waktu = await showTimePicker(
              context: context,
              initialTime: _waktuReminder,
            );
            if (waktu != null) {
              setState(() => _waktuReminder = waktu);
              await _simpanPreferensi();
              if (_reminderAktif) {
                await _toggleReminder(true);
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppColors.blueBg),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time,
                    color: AppColors.primary, size: 24),
                const SizedBox(width: 16),
                Text(
                  _waktuReminder.format(context),
                  style: AppTextStyles.heading2,
                ),
                const Spacer(),
                const Icon(Icons.chevron_right,
                    color: AppColors.textGrey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── MOTIVASI ─────────────────────────────────────
  Widget _buildKartuMotivasi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pesan Reminder Hari Ini',
            style: AppTextStyles.heading3),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.blueBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primaryLight
                  .withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              const Text('💬',
                  style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  MotivasiHelper.getMotivasiHariIni(),
                  style: AppTextStyles.bodyText.copyWith(
                    color: AppColors.primary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── TOMBOL TEST ──────────────────────────────────
  Widget _buildTombolTest(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () async {
          await _notifService.tampilkanNotifikasi(
            id: 99,
            judul: '🏃 One-Step Test Notifikasi',
            isi: MotivasiHelper.getMotivasiHariIni(),
          );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    '✅ Test dikirim! Cek status bar HP'),
              ),
            );
          }
        },
        icon: const Icon(Icons.notifications_active),
        label: const Text('Test Notifikasi Sekarang'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // ─── TOMBOL CEK TERJADWAL ─────────────────────────
  Widget _buildTombolCekTerjadwal(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () async {
          final pending =
          await _notifService.getPendingNotifikasi();
          if (mounted) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text(
                    'Status Notifikasi Terjadwal'),
                content: pending.isEmpty
                    ? const Text(
                  '❌ Tidak ada notifikasi terjadwal.\n\n'
                      'Aktifkan toggle Reminder Harian '
                      'di atas terlebih dahulu.',
                )
                    : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      '✅ ${pending.length} '
                          'notifikasi terjadwal:',
                      style: const TextStyle(
                          fontWeight:
                          FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...pending.map(
                          (p) => Padding(
                        padding:
                        const EdgeInsets.only(
                            bottom: 4),
                        child: Text(
                          '• ${p.title}',
                          style: const TextStyle(
                              fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '⚠️ Pastikan Battery '
                          'Optimization sudah '
                          'dinonaktifkan agar notifikasi '
                          'selalu muncul tepat waktu.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () =>
                        Navigator.pop(context),
                    child: const Text('Tutup'),
                  ),
                ],
              ),
            );
          }
        },
        icon: const Icon(Icons.schedule),
        label: const Text('Cek Status Reminder'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accent,
          side:
          const BorderSide(color: AppColors.accent),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}