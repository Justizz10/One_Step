import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/user_model.dart';
import '../../services/profile_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/image_helper.dart';

class EditProfilScreen extends StatefulWidget {
  final UserModel? user;
  const EditProfilScreen({super.key, this.user});

  @override
  State<EditProfilScreen> createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilScreen> {
  final _formKey = GlobalKey<FormState>();
  final _profileService = ProfileService();
  final _picker = ImagePicker();

  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;

  String _gender = 'M';
  String _goal = 'maintain';
  String _activityLevel = 'moderate';
  File? _fotoBaruFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final u = widget.user;
    _nameController =
        TextEditingController(text: u?.name ?? '');
    _usernameController =
        TextEditingController(text: u?.username ?? '');
    _ageController = TextEditingController(
        text: (u?.age ?? 0) > 0 ? '${u!.age}' : '');
    _heightController = TextEditingController(
        text: (u?.height ?? 0) > 0
            ? '${u!.height.toInt()}' : '');
    _weightController = TextEditingController(
        text: (u?.weight ?? 0) > 0
            ? '${u!.weight.toInt()}' : '');
    if (u?.gender.isNotEmpty == true) _gender = u!.gender;
    if (u?.goal.isNotEmpty == true) _goal = u!.goal;
    if (u?.activityLevel.isNotEmpty == true) {
      _activityLevel = u!.activityLevel;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _pilihFoto() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Pilih Foto Profil',
                style: AppTextStyles.heading2),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.photo_library,
                  color: AppColors.primary),
              title: const Text('Dari Galeri'),
              onTap: () async {
                Navigator.pop(context);
                final picked = await _picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 50,
                  maxWidth: 400,
                  maxHeight: 400,
                );
                if (picked != null) {
                  setState(() =>
                  _fotoBaruFile = File(picked.path));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt,
                  color: AppColors.primary),
              title: const Text('Dari Kamera'),
              onTap: () async {
                Navigator.pop(context);
                final picked = await _picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 50,
                  maxWidth: 400,
                  maxHeight: 400,
                );
                if (picked != null) {
                  setState(() =>
                  _fotoBaruFile = File(picked.path));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // Upload foto kalau ada
    if (_fotoBaruFile != null) {
      final errorFoto =
      await _profileService.updateFotoProfil(_fotoBaruFile!);
      if (errorFoto != null && mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(errorFoto),
              backgroundColor: AppColors.danger),
        );
        return;
      }
    }

    // Update data profil
    final error = await _profileService.updateProfil(
      name: _nameController.text.trim(),
      username: _usernameController.text.trim(),
      gender: _gender,
      age: int.tryParse(_ageController.text) ?? 0,
      height: double.tryParse(_heightController.text) ?? 0,
      weight: double.tryParse(_weightController.text) ?? 0,
      goal: _goal,
      activityLevel: _activityLevel,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error),
            backgroundColor: AppColors.danger),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Profil berhasil diperbarui!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Edit Profil',
            style: AppTextStyles.heading2),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _simpan,
            child: _isLoading
                ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2))
                : Text('Simpan',
                style: AppTextStyles.buttonText
                    .copyWith(color: AppColors.primary)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSeksiFoto(),
              const SizedBox(height: 28),
              _buildSeksiDataDiri(),
              const SizedBox(height: 20),
              _buildSeksiKebugaran(),
              const SizedBox(height: 20),
              _buildSeksiTujuan(),
              const SizedBox(height: 20),
              _buildSeksiAktivitas(),
              const SizedBox(height: 32),
              _buildTombolSimpan(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeksiFoto() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _pilihFoto,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.blueBg,
                  child: _fotoBaruFile != null
                      ? ClipOval(
                    child: Image.file(
                      _fotoBaruFile!,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  )
                      : ImageHelper.buildFotoProfil(
                    photoUrl:
                    widget.user?.photoUrl ?? '',
                    radius: 60,
                    placeholder: const Icon(
                        Icons.person,
                        size: 60,
                        color: AppColors.primary),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt,
                        size: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _pilihFoto,
            child: Text('Ganti Foto Profil',
                style: AppTextStyles.caption.copyWith(
                    color: AppColors.primaryLight)),
          ),
        ],
      ),
    );
  }

  Widget _buildSeksiDataDiri() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Data Diri', style: AppTextStyles.heading3),
        const SizedBox(height: 12),
        _buildInput(
          label: 'Nama Lengkap',
          controller: _nameController,
          ikon: Icons.person_outline,
          validator: (v) {
            if (v == null || v.isEmpty) {
              return 'Nama wajib diisi';
            }
            if (v.length < 3) {
              return 'Nama minimal 3 karakter';
            }
            return null;
          },
        ),
        const SizedBox(height: 14),
        _buildInput(
          label: 'Username',
          controller: _usernameController,
          ikon: Icons.alternate_email,
          hint: 'contoh: johndoe123',
        ),
        const SizedBox(height: 14),
        Text('Jenis Kelamin', style: AppTextStyles.heading3),
        const SizedBox(height: 8),
        _buildPilihGender(),
      ],
    );
  }

  Widget _buildSeksiKebugaran() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Data Kebugaran', style: AppTextStyles.heading3),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildInput(
                label: 'Usia',
                controller: _ageController,
                ikon: Icons.cake_outlined,
                hint: 'tahun',
                tipe: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInput(
                label: 'Tinggi',
                controller: _heightController,
                ikon: Icons.height,
                hint: 'cm',
                tipe: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInput(
                label: 'Berat',
                controller: _weightController,
                ikon: Icons.monitor_weight_outlined,
                hint: 'kg',
                tipe: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSeksiTujuan() {
    final options = [
      {
        'value': 'lose_weight',
        'label': 'Turunkan\nBerat Badan',
        'icon': Icons.trending_down,
      },
      {
        'value': 'maintain',
        'label': 'Jaga\nBerat Badan',
        'icon': Icons.balance,
      },
      {
        'value': 'fitness',
        'label': 'Tingkatkan\nKebugaran',
        'icon': Icons.fitness_center,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tujuan Kebugaran',
            style: AppTextStyles.heading3),
        const SizedBox(height: 8),
        Row(
          children: options.asMap().entries.map((entry) {
            final opt = entry.value;
            final aktif = _goal == opt['value'];
            final isLast =
                entry.key == options.length - 1;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(
                        () => _goal = opt['value'] as String),
                child: Container(
                  margin:
                  EdgeInsets.only(right: isLast ? 0 : 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: aktif
                        ? AppColors.primary
                        .withValues(alpha: 0.1)
                        : AppColors.cardBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: aktif
                          ? AppColors.primary
                          : AppColors.blueBg,
                      width: aktif ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        opt['icon'] as IconData,
                        color: aktif
                            ? AppColors.primary
                            : AppColors.textGrey,
                        size: 24,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        opt['label'] as String,
                        style: AppTextStyles.caption
                            .copyWith(
                          color: aktif
                              ? AppColors.primary
                              : AppColors.textGrey,
                          fontWeight: aktif
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSeksiAktivitas() {
    final options = [
      {'value': 'sedentary', 'label': 'Jarang\nGerak'},
      {'value': 'light', 'label': 'Ringan'},
      {'value': 'moderate', 'label': 'Sedang'},
      {'value': 'active', 'label': 'Aktif'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tingkat Aktivitas',
            style: AppTextStyles.heading3),
        const SizedBox(height: 8),
        Row(
          children: options.asMap().entries.map((entry) {
            final opt = entry.value;
            final aktif = _activityLevel == opt['value'];
            final isLast =
                entry.key == options.length - 1;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() =>
                _activityLevel =
                opt['value'] as String),
                child: Container(
                  margin:
                  EdgeInsets.only(right: isLast ? 0 : 8),
                  padding: const EdgeInsets.symmetric(
                      vertical: 12),
                  decoration: BoxDecoration(
                    color: aktif
                        ? AppColors.accent
                        .withValues(alpha: 0.15)
                        : AppColors.cardBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: aktif
                          ? AppColors.accent
                          : AppColors.blueBg,
                      width: aktif ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    opt['label'] as String,
                    style: AppTextStyles.caption.copyWith(
                      color: aktif
                          ? AppColors.accent
                          : AppColors.textGrey,
                      fontWeight: aktif
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTombolSimpan() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _simpan,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(
            color: Colors.white)
            : Text('Simpan Perubahan',
            style: AppTextStyles.buttonText),
      ),
    );
  }

  Widget _buildPilihGender() {
    return Row(
      children: [
        _buildChipGender(
            'Laki-laki', 'M', Icons.male,
            AppColors.primaryLight),
        const SizedBox(width: 12),
        _buildChipGender(
            'Perempuan', 'F', Icons.female,
            AppColors.accent),
      ],
    );
  }

  Widget _buildChipGender(String label, String value,
      IconData ikon, Color warna) {
    final aktif = _gender == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _gender = value),
        child: Container(
          padding:
          const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: aktif
                ? warna.withValues(alpha: 0.15)
                : AppColors.cardBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: aktif ? warna : AppColors.blueBg,
              width: aktif ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(ikon,
                  color: aktif
                      ? warna
                      : AppColors.textGrey,
                  size: 20),
              const SizedBox(width: 8),
              Text(label,
                  style: TextStyle(
                    color: aktif
                        ? warna
                        : AppColors.textGrey,
                    fontWeight: aktif
                        ? FontWeight.w600
                        : FontWeight.normal,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
    required IconData ikon,
    String? hint,
    TextInputType tipe = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: tipe,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon:
        Icon(ikon, color: AppColors.textGrey),
        filled: true,
        fillColor: AppColors.cardBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          const BorderSide(color: AppColors.blueBg),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          const BorderSide(color: AppColors.blueBg),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: AppColors.danger),
        ),
      ),
    );
  }
}