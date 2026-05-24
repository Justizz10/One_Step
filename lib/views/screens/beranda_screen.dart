import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/bmi_card_widget.dart';
import '../../models/schedule_model.dart';
import '../../models/user_model.dart';
import '../../services/progress_service.dart';
import '../../services/schedule_service.dart';
import '../../services/profile_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/motivasi_helper.dart';
import '../../utils/rekomendasi_helper.dart';
import 'main_screen.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  final ProgressService _progressService = ProgressService();
  final ScheduleService _scheduleService = ScheduleService();
  final ProfileService _profileService = ProfileService();
  final String _userId =
      FirebaseAuth.instance.currentUser?.uid ?? '';

  UserModel? _user;
  int _sesiHariIni = 0;
  int _kaloriTerbakar = 0;
  int _streak = 0;
  bool _sudahSelesaiHariIni = false;

  @override
  void initState() {
    super.initState();
    _loadSemuaData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadSemuaData();
  }

  Future<void> _loadSemuaData() async {
    await Future.wait([
      _loadStatistikHariIni(),
      _loadUser(),
      _cekStatusHariIni(),
      _loadStreak(),
    ]);
  }

  Future<void> _loadUser() async {
    final user = await _profileService.getProfil();
    if (mounted) setState(() => _user = user);
  }

  Future<void> _loadStatistikHariIni() async {
    final data =
    await _progressService.getStatistikHariIni();
    if (mounted) {
      setState(() {
        _sesiHariIni = data['totalSesi'] ?? 0;
        _kaloriTerbakar = data['totalKalori'] ?? 0;
      });
    }
  }

  Future<void> _loadStreak() async {
    final streak =
    await _progressService.evaluasiStreak();
    if (mounted) setState(() => _streak = streak);
  }

  Future<void> _cekStatusHariIni() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final sudahHariIni =
        prefs.getInt('selesai_tanggal') == today.day &&
            prefs.getInt('selesai_bulan') == today.month &&
            prefs.getInt('selesai_tahun') == today.year;
    if (mounted) {
      setState(() => _sudahSelesaiHariIni = sudahHariIni);
    }
  }

  Future<void> _simpanStatusSelesai() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    await prefs.setInt('selesai_tanggal', today.day);
    await prefs.setInt('selesai_bulan', today.month);
    await prefs.setInt('selesai_tahun', today.year);
    if (mounted) {
      setState(() => _sudahSelesaiHariIni = true);
    }
  }

  void _keHalamanJadwal() {
    mainScreenKey.currentState?.pindahKeTab(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildKartuMotivasi(),
              const SizedBox(height: 16),
              _buildKartuRekomendasiHarian(context),
              const SizedBox(height: 20),
              _buildRingkasanHarian(),
              const SizedBox(height: 20),
              _buildBMI(),
              const SizedBox(height: 20),
              _buildJadwalTerdekat(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ─── HEADER ─────────────────────────────────────────
  Widget _buildHeader() {
    String namaDisplay = 'Pengguna';
    String subDisplay = 'Semangat olahraga hari ini!';
    if (_user != null) {
      if (_user!.name.isNotEmpty)
        namaDisplay = _user!.name;
      if (_user!.username.isNotEmpty)
        subDisplay = '@${_user!.username}';
    }
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
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text('Halo, $namaDisplay! 👋',
                    style: AppTextStyles.heading2
                        .copyWith(color: Colors.white)),
                const SizedBox(height: 4),
                Text(subDisplay,
                    style: AppTextStyles.bodyText
                        .copyWith(
                        color: Colors.white70)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              'assets/images/logo1.PNG',
              width: 44,
              height: 44,
            ),
          ),
        ],
      ),
    );
  }

  // ─── MOTIVASI ───────────────────────────────────────
  Widget _buildKartuMotivasi() {
    return Container(
      width: double.infinity,
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
              style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text('Motivasi Hari Ini',
                    style: AppTextStyles.caption
                        .copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(height: 4),
                Text(
                  MotivasiHelper.getMotivasiHariIni(),
                  style: AppTextStyles.bodyText
                      .copyWith(
                    color: AppColors.primary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── REKOMENDASI HARIAN ─────────────────────────────
  Widget _buildKartuRekomendasiHarian(
      BuildContext context) {
    final rekomendasi =
    RekomendasiHelper.getRekomendasiHariIni();
    final namaHari = RekomendasiHelper.getNamaHari();
    final infoIntensitas =
    RekomendasiHelper.getInfoIntensitas(
        rekomendasi['intensitas'] as String);
    final warnaInt =
    Color(infoIntensitas['warna'] as int);
    final warnaBg = Color(infoIntensitas['bg'] as int);
    final emojiIkon = RekomendasiHelper.getIkon(
        rekomendasi['ikons'] as String);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text('Rekomendasi Hari Ini',
                style: AppTextStyles.heading3),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(namaHari,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  )),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary
                    .withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: AppColors.blueBg,
                      borderRadius:
                      BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(emojiIkon,
                          style: const TextStyle(
                              fontSize: 28)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                            rekomendasi['nama']
                            as String,
                            style:
                            AppTextStyles.heading3),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            _buildBadge(
                              '⏱ ${rekomendasi['durasi']}',
                              AppColors.primaryLight,
                              AppColors.blueBg,
                            ),
                            _buildBadge(
                              '🔥 ${rekomendasi['kalori']}',
                              AppColors.warning,
                              const Color(0xFFFFFDE7),
                            ),
                            _buildBadge(
                              rekomendasi['intensitas']
                              as String,
                              warnaInt,
                              warnaBg,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Text(
                rekomendasi['deskripsi'] as String,
                style: AppTextStyles.bodyText.copyWith(
                    color: AppColors.textDark,
                    height: 1.5),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.blueBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Text('💡',
                        style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        rekomendasi['tips'] as String,
                        style: AppTextStyles.caption
                            .copyWith(
                          color: AppColors.primary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Tombol — 1x per hari
        SizedBox(
          width: double.infinity,
          child: _sudahSelesaiHariIni
              ? Container(
            padding: const EdgeInsets.symmetric(
                vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius:
              BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF2E7D32)
                    .withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle,
                        color: Color(0xFF2E7D32),
                        size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Sudah Selesai Hari Ini! ✅',
                      style: TextStyle(
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Besok akan ada rekomendasi baru',
                  style: TextStyle(
                    color: const Color(0xFF2E7D32)
                        .withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )
              : ElevatedButton.icon(
            onPressed: () async {
              final durasi = int.tryParse(
                (rekomendasi['durasi']
                as String)
                    .replaceAll(
                    RegExp(r'[^0-9]'),
                    ''),
              ) ??
                  30;
              final kalori = double.tryParse(
                (rekomendasi['kalori']
                as String)
                    .replaceAll(
                    RegExp(r'[^0-9]'),
                    ''),
              ) ??
                  200;

              await _progressService.simpanSesi(
                activityName:
                rekomendasi['nama'] as String,
                duration: durasi,
                caloriesBurned: kalori,
              );

              await _simpanStatusSelesai();
              await _loadStatistikHariIni();
              await _loadStreak(); // ← refresh streak

              if (context.mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  SnackBar(
                    content: Text(
                      '✅ ${rekomendasi['nama']} '
                          'berhasil dicatat!',
                    ),
                    backgroundColor:
                    const Color(0xFF2E7D32),
                    duration:
                    const Duration(seconds: 3),
                  ),
                );
              }
            },
            icon: const Icon(
                Icons.check_circle_outline),
            label: const Text('Tandai Selesai'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                  vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(
      String label, Color warnaTeks, Color warnaBg) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: warnaBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: warnaTeks,
          )),
    );
  }

  // ─── RINGKASAN HARIAN ───────────────────────────────
  Widget _buildRingkasanHarian() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ringkasan Hari Ini',
            style: AppTextStyles.heading3),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildKartuStatistik(
              'Kalori\nTerbakar',
              '$_kaloriTerbakar',
              'kkal',
              Icons.local_fire_department,
              AppColors.warning,
            ),
            const SizedBox(width: 12),
            _buildKartuStatistik(
              'Sesi\nSelesai',
              '$_sesiHariIni',
              'sesi',
              Icons.fitness_center,
              AppColors.primaryLight,
            ),
            const SizedBox(width: 12),
            // ─── STREAK CARD ──────────────────────────
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _streak > 0
                      ? const Color(0xFFFFF8E1)
                      : AppColors.cardBg,
                  borderRadius:
                  BorderRadius.circular(12),
                  border: _streak > 0
                      ? Border.all(
                      color: AppColors.warning
                          .withValues(alpha: 0.4))
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      _streak > 0 ? '🔥' : '💤',
                      style:
                      const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$_streak',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _streak > 0
                            ? AppColors.warning
                            : AppColors.textGrey,
                      ),
                    ),
                    Text(
                      _streak > 0
                          ? 'minggu 🔥'
                          : 'minggu',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Streak\nMinggu',
                      style: AppTextStyles.caption,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Pesan streak di bawah kartu
        if (_streak > 0) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.warning
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Text('🏆',
                    style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _streak >= 4
                        ? 'Luar biasa! $_streak minggu berturut-turut! Kamu konsisten!'
                        : '$_streak minggu berturut-turut! Pertahankan sampai 7 sesi minggu ini!',
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF854F0B),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildKartuStatistik(String label, String nilai,
      String satuan, IconData ikon, Color warna) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(ikon, color: warna, size: 24),
            const SizedBox(height: 8),
            Text(nilai,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: warna)),
            Text(satuan, style: AppTextStyles.caption),
            const SizedBox(height: 4),
            Text(label,
                style: AppTextStyles.caption,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  // ─── BMI ────────────────────────────────────────────
  Widget _buildBMI() {
    if (_user == null) return const SizedBox();
    if (_user!.weight <= 0 || _user!.height <= 0) {
      return GestureDetector(
        onTap: () =>
            mainScreenKey.currentState?.pindahKeTab(4),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.blueBg),
          ),
          child: Row(
            children: [
              const Icon(Icons.monitor_weight_outlined,
                  color: AppColors.textGrey, size: 32),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text('BMI Belum Tersedia',
                        style: AppTextStyles.heading3
                            .copyWith(
                            color:
                            AppColors.textGrey)),
                    Text('Tap untuk lengkapi profil',
                        style: AppTextStyles.caption),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  size: 16, color: AppColors.textGrey),
            ],
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Status BMI Saya',
            style: AppTextStyles.heading3),
        const SizedBox(height: 12),
        BMICardWidget(
          berat: _user!.weight,
          tinggi: _user!.height,
          gender: _user!.gender,
          isKompak: true,
        ),
      ],
    );
  }

  // ─── JADWAL TERDEKAT ────────────────────────────────
  Widget _buildJadwalTerdekat() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text('Jadwal Terdekat',
                style: AppTextStyles.heading3),
            GestureDetector(
              onTap: _keHalamanJadwal,
              child: Text('Lihat Semua',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.w600,
                  )),
            ),
          ],
        ),
        const SizedBox(height: 12),
        StreamBuilder<List<ScheduleModel>>(
          stream: _scheduleService.getJadwalTerdekat(
              _userId, limit: 3),
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            final jadwalList = snapshot.data ?? [];
            if (jadwalList.isEmpty) {
              return GestureDetector(
                onTap: _keHalamanJadwal,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius:
                    BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.blueBg),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 40,
                        color: AppColors.textGrey
                            .withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 10),
                      Text('Belum ada jadwal latihan',
                          style: AppTextStyles.heading3
                              .copyWith(
                              color:
                              AppColors.textGrey)),
                      const SizedBox(height: 4),
                      Text('Tap untuk tambah jadwal',
                          style: AppTextStyles.caption
                              .copyWith(
                            color: AppColors.primaryLight,
                          )),
                    ],
                  ),
                ),
              );
            }
            return Column(
              children: jadwalList
                  .map((j) => _buildItemJadwal(j))
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildItemJadwal(ScheduleModel jadwal) {
    final ikon = _getIkonAktivitas(jadwal.activityName);
    final waktu = _formatWaktu(jadwal.scheduledDate);
    final sudahLewat =
    jadwal.scheduledDate.isBefore(DateTime.now());
    return GestureDetector(
      onTap: _keHalamanJadwal,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: sudahLewat
                ? AppColors.textGrey
                .withValues(alpha: 0.3)
                : AppColors.blueBg,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: sudahLewat
                    ? AppColors.textGrey
                    .withValues(alpha: 0.1)
                    : AppColors.blueBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(ikon,
                  color: sudahLewat
                      ? AppColors.textGrey
                      : AppColors.primary,
                  size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(jadwal.activityName,
                      style:
                      AppTextStyles.heading3.copyWith(
                        color: sudahLewat
                            ? AppColors.textGrey
                            : AppColors.textDark,
                      )),
                  const SizedBox(height: 2),
                  Text(
                    '${jadwal.duration} menit · '
                        '${_labelIntensitas(jadwal.intensity)}',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(waktu,
                    style: AppTextStyles.caption),
                if (sudahLewat)
                  Text('Sudah lewat',
                      style:
                      AppTextStyles.caption.copyWith(
                        color: AppColors.warning,
                        fontSize: 10,
                      )),
              ],
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right,
                color: AppColors.textGrey, size: 18),
          ],
        ),
      ),
    );
  }

  // ─── HELPERS ────────────────────────────────────────
  String _formatWaktu(DateTime date) {
    const hari = [
      'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'
    ];
    const bulan = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    final jam = date.hour.toString().padLeft(2, '0');
    final menit = date.minute.toString().padLeft(2, '0');
    return '${hari[date.weekday - 1]} ${date.day} '
        '${bulan[date.month - 1]} · $jam.$menit';
  }

  IconData _getIkonAktivitas(String aktivitas) {
    switch (aktivitas.toLowerCase()) {
      case 'jogging': return Icons.directions_run;
      case 'berjalan kaki': return Icons.directions_walk;
      case 'bersepeda': return Icons.directions_bike;
      case 'yoga': return Icons.self_improvement;
      case 'senam': return Icons.sports_gymnastics;
      case 'renang': return Icons.pool;
      case 'lompat tali': return Icons.fitness_center;
      case 'zumba': return Icons.music_note;
      default: return Icons.sports;
    }
  }

  String _labelIntensitas(String intensitas) {
    switch (intensitas) {
      case 'low': return 'Ringan';
      case 'high': return 'Berat';
      default: return 'Sedang';
    }
  }
}