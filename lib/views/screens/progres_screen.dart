import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/progress_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';

class ProgresScreen extends StatefulWidget {
  const ProgresScreen({super.key});

  @override
  State<ProgresScreen> createState() =>
      _ProgresScreenState();
}

class _ProgresScreenState extends State<ProgresScreen> {
  final ProgressService _progressService =
  ProgressService();
  Map<String, dynamic> _statistik = {
    'totalSesi': 0,
    'totalMenit': 0,
    'totalKalori': 0,
  };
  int _streak = 0;
  int _sesiMingguIni = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistik();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadStatistik();
  }

  Future<void> _loadStatistik() async {
    if (mounted) setState(() => _isLoading = true);
    final data =
    await _progressService.getStatistikMingguan();
    final streak =
    await _progressService.evaluasiStreak();
    final sesiMingguIni =
    await _progressService.getSesiMinggu(
        DateTime.now());
    if (mounted) {
      setState(() {
        _statistik = data;
        _streak = streak;
        _sesiMingguIni = sesiMingguIni;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Progres Saya',
            style: AppTextStyles.heading2),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh,
                color: AppColors.primary),
            onPressed: _loadStatistik,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadStatistik,
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              _buildHeaderMingguIni(),
              const SizedBox(height: 20),
              _buildKartuStreak(),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(
                  child: CircularProgressIndicator())
                  : _buildStatistikMinggu(),
              const SizedBox(height: 20),
              _buildRiwayatLatihan(),
            ],
          ),
        ),
      ),
    );
  }

  // ─── HEADER ─────────────────────────────────────────
  Widget _buildHeaderMingguIni() {
    final totalSesi = _statistik['totalSesi'] as int;
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
                Text('Minggu Ini',
                    style: AppTextStyles.caption
                        .copyWith(
                        color: Colors.white70)),
                const SizedBox(height: 4),
                Text('$totalSesi Sesi Selesai',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  totalSesi >= 7
                      ? '🏆 Target minggu ini tercapai!'
                      : totalSesi >= 3
                      ? '🔥 Konsisten! Pertahankan!'
                      : '💪 Ayo tambah sesi latihan!',
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _sesiMingguIni >= 7
                  ? AppColors.success.withValues(alpha: 0.3)
                  : Colors.white24,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  '$_sesiMingguIni/7',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'sesi',
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── KARTU STREAK ───────────────────────────────────
  Widget _buildKartuStreak() {
    final streakNyala = _streak > 0;
    final warnaUtama = streakNyala
        ? AppColors.warning
        : AppColors.textGrey;
    final warnaBg = streakNyala
        ? const Color(0xFFFFF8E1)
        : AppColors.cardBg;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: warnaBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: warnaUtama.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: warnaUtama.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ikon streak besar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: warnaUtama.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                streakNyala ? '🔥' : '💤',
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Info streak
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Streak Mingguan',
                  style: AppTextStyles.caption
                      .copyWith(
                    color: warnaUtama,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$_streak',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: warnaUtama,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 6, left: 6),
                      child: Text(
                        'minggu',
                        style: AppTextStyles.caption
                            .copyWith(
                            color: warnaUtama),
                      ),
                    ),
                  ],
                ),
                Text(
                  streakNyala
                      ? _streak >= 4
                      ? '🏆 Luar biasa! Kamu sangat konsisten!'
                      : '✅ Selesaikan 7 sesi/minggu untuk lanjutkan'
                      : '❌ Selesaikan 7 sesi minggu ini untuk mulai streak',
                  style: AppTextStyles.caption
                      .copyWith(
                    color: warnaUtama,
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

  // ─── STATISTIK MINGGU ───────────────────────────────
  Widget _buildStatistikMinggu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Statistik Minggu Ini',
            style: AppTextStyles.heading3),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildKartuStatistik(
                'Total Sesi',
                '${_statistik['totalSesi']}',
                'sesi',
                Icons.fitness_center,
                AppColors.primary),
            const SizedBox(width: 12),
            _buildKartuStatistik(
                'Total Waktu',
                '${_statistik['totalMenit']}',
                'menit',
                Icons.timer,
                AppColors.accent),
            const SizedBox(width: 12),
            _buildKartuStatistik(
                'Kalori Terbakar',
                '${_statistik['totalKalori']}',
                'kkal',
                Icons.local_fire_department,
                AppColors.warning),
          ],
        ),
        const SizedBox(height: 12),

        // Progress bar menuju 7 sesi
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.blueBg),
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Text('Progress Target Minggu Ini',
                      style: AppTextStyles.caption
                          .copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      )),
                  Text(
                    '$_sesiMingguIni / 7 sesi',
                    style: AppTextStyles.caption
                        .copyWith(
                      color: _sesiMingguIni >= 7
                          ? AppColors.success
                          : AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: (_sesiMingguIni / 7)
                      .clamp(0.0, 1.0),
                  backgroundColor: AppColors.blueBg,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _sesiMingguIni >= 7
                        ? AppColors.success
                        : AppColors.primary,
                  ),
                  minHeight: 10,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _sesiMingguIni >= 7
                    ? '🎉 Target tercapai! Streak akan bertambah minggu depan!'
                    : '${7 - _sesiMingguIni} sesi lagi untuk mencapai target & menjaga streak',
                style: AppTextStyles.caption.copyWith(
                  color: _sesiMingguIni >= 7
                      ? AppColors.success
                      : AppColors.textGrey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKartuStatistik(String label,
      String nilai, String satuan,
      IconData ikon, Color warna) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black
                    .withValues(alpha: 0.04),
                blurRadius: 6)
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
            Text(satuan,
                style: AppTextStyles.caption),
            const SizedBox(height: 4),
            Text(label,
                style: AppTextStyles.caption,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  // ─── RIWAYAT ────────────────────────────────────────
  Widget _buildRiwayatLatihan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Riwayat Latihan',
            style: AppTextStyles.heading3),
        const SizedBox(height: 12),
        StreamBuilder<List<Map<String, dynamic>>>(
          stream: _progressService.getRiwayat(),
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator());
            }
            final riwayat = snapshot.data ?? [];
            if (riwayat.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius:
                  BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                      'Belum ada riwayat latihan',
                      style: AppTextStyles.caption),
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics:
              const NeverScrollableScrollPhysics(),
              itemCount: riwayat.length,
              itemBuilder: (context, i) =>
                  _buildItemRiwayat(riwayat[i]),
            );
          },
        ),
      ],
    );
  }

  Widget _buildItemRiwayat(
      Map<String, dynamic> item) {
    DateTime tanggal = DateTime.now();
    if (item['completedAt'] is Timestamp) {
      tanggal =
          (item['completedAt'] as Timestamp).toDate();
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.blueBg),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.blueBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.check_circle,
                color: AppColors.success, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(item['activityName'] ?? '-',
                    style: AppTextStyles.heading3),
                Text(
                  '${item['duration'] ?? 0} menit · '
                      '${(item['caloriesBurned'] ?? 0).toInt()} kkal',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          Text(
            '${tanggal.day}/${tanggal.month}/${tanggal.year}',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}
