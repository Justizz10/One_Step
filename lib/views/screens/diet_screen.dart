import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/diet_model.dart';
import '../../services/diet_service.dart';
import '../../services/auth_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/menu_helper.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen>
    with SingleTickerProviderStateMixin {
  final DietService _dietService = DietService();
  final AuthService _authService = AuthService();
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  late TabController _tabController;

  double _targetKalori = 2000;
  double _protein = 0, _carbs = 0, _fat = 0;

  // Data makanan dummy
  final List<Map<String, dynamic>> _daftarMakanan = [
    {'name': 'Nasi Putih (100g)', 'cal': 130.0, 'p': 2.7, 'c': 28.0, 'f': 0.3},
    {'name': 'Ayam Goreng (100g)', 'cal': 260.0, 'p': 27.0, 'c': 0.0, 'f': 16.0},
    {'name': 'Telur Rebus', 'cal': 78.0, 'p': 6.0, 'c': 0.6, 'f': 5.0},
    {'name': 'Tempe Goreng (50g)', 'cal': 100.0, 'p': 7.0, 'c': 8.0, 'f': 4.0},
    {'name': 'Tahu Goreng (50g)', 'cal': 76.0, 'p': 5.0, 'c': 2.0, 'f': 5.0},
    {'name': 'Sayur Bayam (100g)', 'cal': 23.0, 'p': 2.9, 'c': 3.6, 'f': 0.4},
    {'name': 'Pisang (1 buah)', 'cal': 89.0, 'p': 1.1, 'c': 23.0, 'f': 0.3},
    {'name': 'Apel (1 buah)', 'cal': 72.0, 'p': 0.4, 'c': 19.0, 'f': 0.2},
    {'name': 'Susu (200ml)', 'cal': 122.0, 'p': 6.0, 'c': 12.0, 'f': 6.0},
    {'name': 'Roti Gandum (1 lembar)', 'cal': 69.0, 'p': 3.6, 'c': 12.0, 'f': 1.0},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadProfilUser();
  }

  Future<void> _loadProfilUser() async {
    final user = await _authService.getUserData(userId);
    if (user != null && mounted) {
      setState(() {
        _targetKalori = _dietService.hitungKaloriHarian(
          weight: user.weight > 0 ? user.weight : 60,
          height: user.height > 0 ? user.height : 165,
          age: user.age > 0 ? user.age : 25,
          gender: user.gender.isNotEmpty ? user.gender : 'M',
          activityLevel: user.activityLevel.isNotEmpty
              ? user.activityLevel : 'moderate',
          goal: user.goal.isNotEmpty ? user.goal : 'maintain',
        );
        _protein = _targetKalori * 0.3 / 4;
        _carbs = _targetKalori * 0.45 / 4;
        _fat = _targetKalori * 0.25 / 9;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Program Diet', style: AppTextStyles.heading2),
        backgroundColor: AppColors.background,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textGrey,
          tabs: const [
            Tab(text: 'Ringkasan'),
            Tab(text: 'Catat Makan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTabRingkasan(),
          _buildTabCatatMakan(),
        ],
      ),
    );
  }

  // ── TAB 1: RINGKASAN ─────────────────────────────────
  Widget _buildTabRingkasan() {
    return StreamBuilder<List<FoodLogModel>>(
      stream: _dietService.getFoodLogHariIni(userId),
      builder: (context, snapshot) {
        final logs = snapshot.data ?? [];
        double totalKalori = logs.fold(0, (s, l) => s + l.calories);
        double totalProtein = logs.fold(0, (s, l) => s + l.protein);
        double totalCarbs = logs.fold(0, (s, l) => s + l.carbs);
        double totalFat = logs.fold(0, (s, l) => s + l.fat);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildKartuKalori(totalKalori),
              const SizedBox(height: 20),
              _buildKartuMakronutrien(
                  totalProtein, totalCarbs, totalFat),
              const SizedBox(height: 20),
              _buildPanduanMenu(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildKartuKalori(double totalKalori) {
    final persen = (totalKalori / _targetKalori).clamp(0.0, 1.0);
    final sisa = _targetKalori - totalKalori;
    final melebihi = totalKalori > _targetKalori;  // ← tambahan

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kalori Hari Ini',
                      style: AppTextStyles.caption
                          .copyWith(color: Colors.white70)),
                  Text('${totalKalori.toInt()} kkal',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Target',
                      style: AppTextStyles.caption
                          .copyWith(color: Colors.white70)),
                  Text('${_targetKalori.toInt()} kkal',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: persen,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(
                melebihi ? Colors.orange : Colors.white,  // ← warna berubah
              ),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            melebihi
                ? '⚠️ Kalori melebihi target ${(totalKalori - _targetKalori).toInt()} kkal!'
                : sisa > 0
                ? '${sisa.toInt()} kkal tersisa hari ini'
                : '🎉 Target kalori harian tercapai!',
            style: TextStyle(
              color: melebihi ? Colors.orange[200] : Colors.white70,
              fontSize: 13,
              fontWeight: melebihi ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKartuMakronutrien(
      double protein, double carbs, double fat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Makronutrien', style: AppTextStyles.heading3),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildKartuMakro('Protein', protein, _protein,
                AppColors.primaryLight, 'g'),
            const SizedBox(width: 10),
            _buildKartuMakro('Karbo', carbs, _carbs,
                AppColors.warning, 'g'),
            const SizedBox(width: 10),
            _buildKartuMakro('Lemak', fat, _fat,
                AppColors.danger, 'g'),
          ],
        ),
      ],
    );
  }

  Widget _buildKartuMakro(String label, double nilai,
      double target, Color warna, String satuan) {
    final persen = target > 0
        ? (nilai / target).clamp(0.0, 1.0)
        : 0.0;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6)
          ],
        ),
        child: Column(
          children: [
            Text(label, style: AppTextStyles.caption),
            const SizedBox(height: 6),
            Text('${nilai.toInt()}$satuan',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: warna)),
            Text('/ ${target.toInt()}$satuan',
                style: AppTextStyles.caption),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: persen,
                backgroundColor: warna.withOpacity(0.15),
                valueColor: AlwaysStoppedAnimation<Color>(warna),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPanduanMenu() {
    final menuHariIni = MenuHelper.getMenuHariIni();
    final namaHari = MenuHelper.getNamaHari();
    final daftarMenu =
    menuHariIni['menu'] as List<Map<String, dynamic>>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header tema menu
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Panduan Menu $namaHari',
                      style: AppTextStyles.heading3),
                  const SizedBox(height: 2),
                  Text(
                    menuHariIni['tema'] as String,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.accent,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            // Badge total kalori
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColors.primary
                        .withValues(alpha: 0.3)),
              ),
              child: Text(
                menuHariIni['totalKalori'] as String,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Standar WHO info
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.blueBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline,
                  color: AppColors.accent, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Menu disusun sesuai panduan WHO: '
                      'Protein 10-35% · Karbo 45-65% · Lemak 20-35%',
                  style: AppTextStyles.caption.copyWith(
                      color: AppColors.accent),
                ),
              ),
            ],
          ),
        ),

        // Daftar menu per waktu makan
        ...daftarMenu.map((item) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.blueBg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item['waktu'] as String,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 12,
                          color: AppColors.textGrey),
                      const SizedBox(width: 4),
                      Text(
                        item['jam'] as String,
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                item['makanan'] as String,
                style: AppTextStyles.bodyText,
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  // Kalori
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.warning
                          .withValues(alpha: 0.1),
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                    child: Text(
                      item['kalori'] as String,
                      style: AppTextStyles.caption
                          .copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // Nutrisi
                  Text(
                    item['nutrisi'] as String,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.accent,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )),
      ],
    );
  }

  // ── TAB 2: CATAT MAKAN ────────────────────────────────
  Widget _buildTabCatatMakan() {
    return StreamBuilder<List<FoodLogModel>>(
      stream: _dietService.getFoodLogHariIni(userId),
      builder: (context, snapshot) {
        final logs = snapshot.data ?? [];
        return Column(
          children: [
            Expanded(
              child: logs.isEmpty
                  ? Center(
                  child: Text('Belum ada catatan makan hari ini',
                      style: AppTextStyles.caption))
                  : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: logs.length,
                itemBuilder: (context, i) =>
                    _buildItemLog(logs[i]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => _showTambahMakan(context),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: Text('Catat Makanan',
                      style: AppTextStyles.buttonText),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildItemLog(FoodLogModel log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.blueBg),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(log.foodName, style: AppTextStyles.heading3),
                Text('${log.mealType} · ${log.calories.toInt()} kkal',
                    style: AppTextStyles.caption),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline,
                color: AppColors.danger, size: 20),
            onPressed: () => _dietService.hapusFoodLog(log.logId),
          ),
        ],
      ),
    );
  }

  void _showTambahMakan(BuildContext context) {
    Map<String, dynamic>? makananPilihan;
    String mealTypePilihan = 'breakfast';

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
              Text('Catat Makanan', style: AppTextStyles.heading2),
              const SizedBox(height: 16),

              // Pilih waktu makan
              Text('Waktu Makan', style: AppTextStyles.heading3),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: mealTypePilihan,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                      value: 'breakfast', child: Text('Sarapan')),
                  DropdownMenuItem(
                      value: 'lunch', child: Text('Makan Siang')),
                  DropdownMenuItem(
                      value: 'dinner', child: Text('Makan Malam')),
                  DropdownMenuItem(
                      value: 'snack', child: Text('Cemilan')),
                ],
                onChanged: (val) =>
                    setModalState(() => mealTypePilihan = val!),
              ),
              const SizedBox(height: 16),

              // Pilih makanan
              Text('Pilih Makanan', style: AppTextStyles.heading3),
              const SizedBox(height: 8),
              DropdownButtonFormField<Map<String, dynamic>>(
                value: makananPilihan,
                hint: const Text('Pilih makanan'),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: _daftarMakanan
                    .map((m) => DropdownMenuItem(
                    value: m, child: Text(m['name'])))
                    .toList(),
                onChanged: (val) =>
                    setModalState(() => makananPilihan = val),
              ),
              const SizedBox(height: 24),

              // Tombol simpan
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: makananPilihan == null
                      ? null
                      : () async {
                    final log = FoodLogModel(
                      logId: '',
                      userId: userId,
                      logDate: DateTime.now(),
                      mealType: mealTypePilihan,
                      foodName: makananPilihan!['name'],
                      portion: 1,
                      calories: makananPilihan!['cal'],
                      protein: makananPilihan!['p'],
                      carbs: makananPilihan!['c'],
                      fat: makananPilihan!['f'],
                    );
                    await _dietService.tambahFoodLog(log);
                    if (context.mounted) Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Simpan',
                      style: AppTextStyles.buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}