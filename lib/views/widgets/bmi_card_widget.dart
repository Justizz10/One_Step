import 'package:flutter/material.dart';
import '../../utils/bmi_helper.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';

class BMICardWidget extends StatelessWidget {
  final double berat;
  final double tinggi;
  final String gender;
  final bool isKompak; // true = versi ringkas untuk beranda

  const BMICardWidget({
    super.key,
    required this.berat,
    required this.tinggi,
    required this.gender,
    this.isKompak = false,
  });

  @override
  Widget build(BuildContext context) {
    final bmi = BMIHelper.hitungBMI(berat, tinggi);
    final kategori = BMIHelper.getKategori(bmi);
    final warna = BMIHelper.getWarna(bmi);
    final ikon = BMIHelper.getIkon(bmi);
    final saran = BMIHelper.getSaran(bmi);
    final bbIdeal = BMIHelper.getBBIdeal(tinggi, gender);
    final progress = BMIHelper.getProgress(bmi);
    final bmiText = bmi > 0
        ? bmi.toStringAsFixed(1)
        : '-';

    if (isKompak) {
      return _buildKompak(
          bmi, bmiText, kategori, warna, ikon, progress);
    }
    return _buildLengkap(
        bmi, bmiText, kategori, warna, ikon,
        saran, bbIdeal, progress);
  }

  // ── Versi Kompak untuk Beranda ──────────────────────
  Widget _buildKompak(double bmi, String bmiText,
      String kategori, Color warna,
      IconData ikon, double progress) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: warna.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: warna.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: warna.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(ikon, color: warna, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text('Indeks Massa Tubuh (BMI)',
                        style: AppTextStyles.caption),
                    const SizedBox(height: 2),
                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.end,
                      children: [
                        Text(
                          bmiText,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: warna,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 4),
                          child: Text(
                            kategori,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: warna,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress bar BMI
          _buildProgressBar(progress, warna),
          const SizedBox(height: 6),

          // Label range BMI
          _buildLabelRange(),
        ],
      ),
    );
  }

  // ── Versi Lengkap untuk Profil ──────────────────────
  Widget _buildLengkap(double bmi, String bmiText,
      String kategori, Color warna, IconData ikon,
      String saran, String bbIdeal, double progress) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: warna.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: warna.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: warna.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(ikon, color: warna, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text('Indeks Massa Tubuh (BMI)',
                        style: AppTextStyles.caption
                            .copyWith(
                            fontWeight:
                            FontWeight.w600)),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.end,
                      children: [
                        Text(
                          bmiText,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: warna,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 6),
                          child: Container(
                            padding:
                            const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4),
                            decoration: BoxDecoration(
                              color: warna
                                  .withValues(alpha: 0.12),
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
                            child: Text(
                              kategori,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: warna,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress bar
          _buildProgressBar(progress, warna),
          const SizedBox(height: 8),
          _buildLabelRange(),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Detail info
          Row(
            children: [
              _buildInfoBox(
                'Berat Badan',
                bmi > 0 ? '${berat.toInt()} kg' : '-',
                Icons.monitor_weight_outlined,
                AppColors.primaryLight,
              ),
              const SizedBox(width: 10),
              _buildInfoBox(
                'Tinggi Badan',
                bmi > 0 ? '${tinggi.toInt()} cm' : '-',
                Icons.height,
                AppColors.accent,
              ),
              const SizedBox(width: 10),
              _buildInfoBox(
                'BB Ideal',
                bbIdeal,
                Icons.flag_outlined,
                AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Saran
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: warna.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: warna.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline,
                    color: warna, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    saran,
                    style: AppTextStyles.caption.copyWith(
                      color: warna,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double progress, Color warna) {
    return Stack(
      children: [
        // Background bar
        Container(
          height: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF2196F3), // Biru - kurang
                Color(0xFF2E7D32), // Hijau - normal
                Color(0xFFF9A825), // Kuning - berlebih
                Color(0xFFC62828), // Merah - obesitas
              ],
            ),
          ),
        ),
        // Indikator posisi BMI
        Positioned(
          left: (progress * (double.infinity == double.infinity
              ? 200
              : 200))
              .clamp(0, 200),
          top: 0,
          bottom: 0,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return FractionallySizedBox(
                widthFactor: progress,
                child: Container(),
              );
            },
          ),
        ),
        // Marker
        Align(
          alignment: Alignment(
              (progress * 2 - 1).clamp(-1.0, 1.0), 0),
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: warna, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabelRange() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('< 18.5', style: _labelStyle()),
        Text('18.5', style: _labelStyle()),
        Text('25.0', style: _labelStyle()),
        Text('30.0', style: _labelStyle()),
        Text('> 30', style: _labelStyle()),
      ],
    );
  }

  TextStyle _labelStyle() => const TextStyle(
    fontSize: 10,
    color: AppColors.textGrey,
  );

  Widget _buildInfoBox(String label, String nilai,
      IconData ikon, Color warna) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: warna.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(ikon, color: warna, size: 18),
            const SizedBox(height: 4),
            Text(
              nilai,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: warna,
              ),
              textAlign: TextAlign.center,
            ),
            Text(label,
                style: AppTextStyles.caption
                    .copyWith(fontSize: 10),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}