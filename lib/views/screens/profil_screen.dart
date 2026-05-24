import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/profile_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/image_helper.dart';
import 'login_screen.dart';
import 'reminder_screen.dart';
import 'edit_profil_screen.dart';
import 'foto_profil_screen.dart';
import '../widgets/bmi_card_widget.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileService = ProfileService();
    final authService = AuthService();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: StreamBuilder<UserModel?>(
        stream: profileService.getProfilStream(),
        builder: (context, snapshot) {
          final user = snapshot.data;
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _buildHeader(
                    context, user, profileService),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      if (user != null)
                        _buildInfoKebugaran(user),
                      if (user != null)
                        _buildBMIProfil(user),
                      const SizedBox(height: 24),
                      _buildMenuList(
                          context, authService),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context,
      UserModel? user, ProfileService profileService) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding:
          const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Column(
            children: [
              // Tombol edit
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          EditProfilScreen(user: user),
                    ),
                  ),
                  icon: const Icon(Icons.edit,
                      color: Colors.white),
                  tooltip: 'Edit Profil',
                ),
              ),

              // Foto profil
              GestureDetector(
                onTap: () {
                  // Tap foto → lihat full screen
                  if (user?.photoUrl.isNotEmpty == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FotoProfilScreen(
                          photoUrl: user!.photoUrl,
                          nama: user.name.isNotEmpty
                              ? user.name
                              : 'Foto Profil',
                        ),
                      ),
                    );
                  } else {
                    // Kalau belum ada foto → langsung ke edit
                    _showOpsiGantiPhoto(
                        context, user, profileService);
                  }
                },
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 52,
                      backgroundColor: Colors.white24,
                      child: ImageHelper.buildFotoProfil(
                        photoUrl: user?.photoUrl ?? '',
                        radius: 52,
                        placeholder: const Icon(
                          Icons.person,
                          size: 52,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Nama
              Text(
                user?.name.isNotEmpty == true
                    ? user!.name
                    : 'Nama Pengguna',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Username
              if (user?.username.isNotEmpty == true) ...[
                const SizedBox(height: 4),
                Text(
                  '@${user!.username}',
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14),
                ),
              ],

              // Email
              const SizedBox(height: 4),
              Text(
                user?.email ?? '',
                style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoKebugaran(UserModel user) {
    String labelGoal = '';
    switch (user.goal) {
      case 'lose_weight':
        labelGoal = 'Turunkan BB';
        break;
      case 'maintain':
        labelGoal = 'Jaga BB';
        break;
      case 'fitness':
        labelGoal = 'Kebugaran';
        break;
      default:
        labelGoal = 'Belum diset';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Info Kebugaran',
            style: AppTextStyles.heading3),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.blueBg),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _buildInfoItem(
                      'Tinggi',
                      '${user.height.toInt()} cm',
                      Icons.height),
                  _buildGaris(),
                  _buildInfoItem(
                      'Berat',
                      '${user.weight.toInt()} kg',
                      Icons.monitor_weight_outlined),
                  _buildGaris(),
                  _buildInfoItem(
                      'Usia',
                      '${user.age} thn',
                      Icons.cake_outlined),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildInfoItem(
                    'Kelamin',
                    user.gender == 'M'
                        ? 'Laki-laki'
                        : user.gender == 'F'
                        ? 'Perempuan'
                        : '-',
                    Icons.person_outline,
                  ),
                  _buildGaris(),
                  _buildInfoItem(
                      'Tujuan',
                      labelGoal,
                      Icons.flag_outlined),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(
      String label, String nilai, IconData ikon) {
    return Expanded(
      child: Column(
        children: [
          Icon(ikon, color: AppColors.primary, size: 20),
          const SizedBox(height: 6),
          Text(nilai,
              style: AppTextStyles.heading3
                  .copyWith(fontSize: 13),
              textAlign: TextAlign.center),
          Text(label,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildGaris() {
    return Container(
        width: 1, height: 36, color: AppColors.blueBg);
  }

  Widget _buildMenuList(
      BuildContext context, AuthService authService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pengaturan', style: AppTextStyles.heading3),
        const SizedBox(height: 12),
        _buildMenuItem(
          context,
          Icons.notifications_active_outlined,
          'Pengaturan Reminder',
          'Atur jadwal notifikasi harian',
              () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                  const ReminderScreen())),
        ),
        _buildMenuItem(
          context,
          Icons.lock_outline,
          'Ubah Kata Sandi',
          'Perbarui keamanan akun Anda',
              () => _showUbahPassword(context),
        ),
        _buildMenuItem(
          context,
          Icons.delete_forever_outlined,
          'Hapus Akun',
          'Hapus akun secara permanen',
              () => _showKonfirmasiHapus(context),
          warna: AppColors.danger,
        ),
        const SizedBox(height: 20),

        // Tombol logout
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: () async {
              await authService.logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (_) =>
                      const LoginScreen()),
                      (route) => false,
                );
              }
            },
            icon: const Icon(Icons.logout,
                color: AppColors.danger),
            label: Text('Keluar',
                style: AppTextStyles.buttonText
                    .copyWith(color: AppColors.danger)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                  color: AppColors.danger),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMenuItem(
      BuildContext context,
      IconData ikon,
      String label,
      String subtitle,
      VoidCallback onTap, {
        Color warna = AppColors.primary,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        tileColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.blueBg),
        ),
        leading: Icon(ikon, color: warna),
        title: Text(label,
            style:
            AppTextStyles.heading3.copyWith(color: warna)),
        subtitle:
        Text(subtitle, style: AppTextStyles.caption),
        trailing: const Icon(Icons.chevron_right,
            color: AppColors.textGrey),
      ),
    );
  }

  Widget _buildBMIProfil(UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status BMI', style: AppTextStyles.heading3),
          const SizedBox(height: 12),
          BMICardWidget(
            berat: user.weight,
            tinggi: user.height,
            gender: user.gender,
            isKompak: false, // ← versi lengkap di profil
          ),
        ],
      ),
    );
  }

  void _showOpsiGantiPhoto(BuildContext context,
      UserModel? user, ProfileService profileService) {
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
            Text('Foto Profil',
                style: AppTextStyles.heading2),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.edit,
                  color: AppColors.primary),
              title: const Text('Ganti Foto'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          EditProfilScreen(user: user)),
                );
              },
            ),
            if (user?.photoUrl.isNotEmpty == true)
              ListTile(
                leading: const Icon(Icons.delete,
                    color: AppColors.danger),
                title: Text('Hapus Foto',
                    style: TextStyle(
                        color: AppColors.danger)),
                onTap: () async {
                  Navigator.pop(context);
                  await profileService.hapusFotoProfil();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                          content:
                          Text('Foto profil dihapus')),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showUbahPassword(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ubah Kata Sandi'),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Kata sandi baru (min. 6 karakter)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Minimal 6 karakter!')),
                );
                return;
              }
              try {
                await FirebaseAuth.instance.currentUser
                    ?.updatePassword(controller.text);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                        content: Text(
                            '✅ Kata sandi berhasil diubah!')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                        content: Text('Gagal: $e'),
                        backgroundColor: AppColors.danger),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary),
            child: const Text('Simpan',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showKonfirmasiHapus(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Akun'),
        content: const Text(
          'Semua data Anda akan dihapus secara permanen '
              'dan tidak dapat dikembalikan. Yakin ingin '
              'melanjutkan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final error =
              await ProfileService().hapusAkun();
              if (context.mounted) {
                if (error == null) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (_) =>
                        const LoginScreen()),
                        (route) => false,
                  );
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                        content: Text(error),
                        backgroundColor: AppColors.danger),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger),
            child: const Text('Hapus',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}