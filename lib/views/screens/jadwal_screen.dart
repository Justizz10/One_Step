import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/schedule_model.dart';
import '../../services/schedule_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../services/progress_service.dart';

class JadwalScreen extends StatefulWidget {
  const JadwalScreen({super.key});

  @override
  State<JadwalScreen> createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  final ScheduleService _scheduleService = ScheduleService();
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  // Daftar aktivitas pilihan
  final List<String> _aktivitas = [
    'Jogging', 'Berjalan Kaki', 'Bersepeda',
    'Yoga', 'Senam', 'Renang',
    'Lompat Tali', 'Zumba', 'Lainnya',
  ];

  // Estimasi kalori berdasarkan jenis aktivitas & durasi
  double _hitungKalori(String aktivitas, int durasi) {
    const Map<String, double> kaloriPerMenit = {
      'Jogging': 10.0,
      'Berjalan Kaki': 5.0,
      'Bersepeda': 8.0,
      'Yoga': 4.0,
      'Senam': 7.0,
      'Renang': 9.0,
      'Lompat Tali': 12.0,
      'Zumba': 8.0,
      'Lainnya': 6.0,
    };
    final kaloriPerMenitAktivitas =
        kaloriPerMenit[aktivitas] ?? 6.0;
    return kaloriPerMenitAktivitas * durasi;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Jadwal Latihan', style: AppTextStyles.heading2),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTambahJadwal(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Tambah Jadwal',
            style: AppTextStyles.buttonText),
      ),
      body: StreamBuilder<List<ScheduleModel>>(
        stream: _scheduleService.getJadwal(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildKosong();
          }
          return _buildDaftarJadwal(snapshot.data!);
        },
      ),
    );
  }

  Widget _buildKosong() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today,
              size: 80, color: AppColors.textGrey.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text('Belum ada jadwal latihan',
              style: AppTextStyles.heading3.copyWith(
                  color: AppColors.textGrey)),
          const SizedBox(height: 8),
          Text('Tap tombol + untuk menambah jadwal',
              style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Widget _buildDaftarJadwal(List<ScheduleModel> jadwalList) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: jadwalList.length,
      itemBuilder: (context, index) {
        final jadwal = jadwalList[index];
        return _buildItemJadwal(jadwal);
      },
    );
  }

  Widget _buildItemJadwal(ScheduleModel jadwal) {
    final selesai = jadwal.status == 'completed';
    final warna = selesai ? AppColors.success : AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selesai
              ? AppColors.success.withOpacity(0.3)
              : AppColors.blueBg,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ikon aktivitas
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: warna.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              selesai ? Icons.check_circle : Icons.directions_run,
              color: warna,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),

          // Info jadwal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jadwal.activityName,
                  style: AppTextStyles.heading3.copyWith(
                    decoration: selesai
                        ? TextDecoration.lineThrough
                        : null,
                    color: selesai
                        ? AppColors.textGrey
                        : AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_formatTanggal(jadwal.scheduledDate)} · ${jadwal.duration} menit',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 4),
                _buildBadgeIntensitas(jadwal.intensity),
              ],
            ),
          ),

          // Menu aksi
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'selesai') {
                // Update status jadwal
                await _scheduleService.updateStatus(
                    jadwal.scheduleId, 'completed');

                // Simpan ke progress Firebase
                await ProgressService().simpanSesi(
                  activityName: jadwal.activityName,
                  duration: jadwal.duration,
                  caloriesBurned: _hitungKalori(
                      jadwal.activityName, jadwal.duration),
                );

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '✅ ${jadwal.activityName} berhasil dicatat!'),
                      backgroundColor: const Color(0xFF2E7D32),
                    ),
                  );
                }
              } else if (value == 'hapus') {
                await _scheduleService.hapusJadwal(jadwal.scheduleId);
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                  value: 'selesai',
                  child: Text('Tandai Selesai')),
              const PopupMenuItem(
                  value: 'hapus',
                  child: Text('Hapus Jadwal')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeIntensitas(String intensitas) {
    Color warna;
    String label;
    switch (intensitas) {
      case 'low':
        warna = AppColors.success;
        label = 'Ringan';
        break;
      case 'high':
        warna = AppColors.danger;
        label = 'Berat';
        break;
      default:
        warna = AppColors.warning;
        label = 'Sedang';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: warna.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: AppTextStyles.caption.copyWith(color: warna)),
    );
  }

  String _formatTanggal(DateTime date) {
    const hari = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    const bulan = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${hari[date.weekday - 1]}, ${date.day} ${bulan[date.month - 1]} · ${date.hour.toString().padLeft(2, '0')}.${date.minute.toString().padLeft(2, '0')}';
  }

  // Bottom sheet tambah jadwal
  void _showTambahJadwal(BuildContext context) {
    String aktivitasPilihan = _aktivitas[0];
    int durasiPilihan = 30;
    String intensitasPilihan = 'medium';
    DateTime tanggalPilihan = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 24, right: 24, top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tambah Jadwal Latihan',
                  style: AppTextStyles.heading2),
              const SizedBox(height: 20),

              // Pilih Aktivitas
              Text('Jenis Aktivitas', style: AppTextStyles.heading3),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: aktivitasPilihan,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: _aktivitas
                    .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                    .toList(),
                onChanged: (val) =>
                    setModalState(() => aktivitasPilihan = val!),
              ),
              const SizedBox(height: 16),

              // Pilih Tanggal & Waktu
              Text('Tanggal & Waktu', style: AppTextStyles.heading3),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final tgl = await showDatePicker(
                    context: context,
                    initialDate: tanggalPilihan,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now()
                        .add(const Duration(days: 30)),
                  );
                  if (tgl != null) {
                    final wkt = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(tanggalPilihan),
                    );
                    if (wkt != null) {
                      setModalState(() {
                        tanggalPilihan = DateTime(
                          tgl.year, tgl.month, tgl.day,
                          wkt.hour, wkt.minute,
                        );
                      });
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          color: AppColors.primary, size: 20),
                      const SizedBox(width: 10),
                      Text(_formatTanggal(tanggalPilihan),
                          style: AppTextStyles.bodyText),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Durasi
              Text('Durasi: $durasiPilihan menit',
                  style: AppTextStyles.heading3),
              Slider(
                value: durasiPilihan.toDouble(),
                min: 10, max: 120, divisions: 11,
                activeColor: AppColors.primary,
                label: '$durasiPilihan menit',
                onChanged: (val) =>
                    setModalState(() => durasiPilihan = val.toInt()),
              ),
              const SizedBox(height: 8),

              // Intensitas
              Text('Intensitas', style: AppTextStyles.heading3),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildPilihIntensitas('low', 'Ringan',
                      AppColors.success, intensitasPilihan,
                          (v) => setModalState(
                              () => intensitasPilihan = v)),
                  const SizedBox(width: 8),
                  _buildPilihIntensitas('medium', 'Sedang',
                      AppColors.warning, intensitasPilihan,
                          (v) => setModalState(
                              () => intensitasPilihan = v)),
                  const SizedBox(width: 8),
                  _buildPilihIntensitas('high', 'Berat',
                      AppColors.danger, intensitasPilihan,
                          (v) => setModalState(
                              () => intensitasPilihan = v)),
                ],
              ),
              const SizedBox(height: 24),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    final jadwalBaru = ScheduleModel(
                      scheduleId: '',
                      userId: userId,
                      activityName: aktivitasPilihan,
                      scheduledDate: tanggalPilihan,
                      duration: durasiPilihan,
                      intensity: intensitasPilihan,
                      status: 'planned',
                    );
                    await _scheduleService.tambahJadwal(jadwalBaru);
                    if (context.mounted) Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Simpan Jadwal',
                      style: AppTextStyles.buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPilihIntensitas(String value, String label,
      Color warna, String selected, Function(String) onTap) {
    final aktif = value == selected;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: aktif ? warna.withOpacity(0.15) : AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: aktif ? warna : Colors.transparent,
            ),
          ),
          child: Text(label,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: aktif ? warna : AppColors.textGrey,
                fontWeight: aktif ? FontWeight.w600 : FontWeight.normal,
              )),
        ),
      ),
    );
  }
}