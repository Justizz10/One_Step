import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import 'beranda_screen.dart';
import 'jadwal_screen.dart';
import 'diet_screen.dart';
import 'progres_screen.dart';
import 'profil_screen.dart';

// Key global untuk akses pindah tab dari luar
final GlobalKey<MainScreenState> mainScreenKey =
GlobalKey<MainScreenState>();

class MainScreen extends StatefulWidget {
  MainScreen() : super(key: mainScreenKey); // ← hapus const

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _halamanAktif = 0;

  void pindahKeTab(int index) {
    setState(() => _halamanAktif = index);
  }

  final List<Widget> _halaman = const [
    BerandaScreen(),
    JadwalScreen(),
    DietScreen(),
    ProgresScreen(),
    ProfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _halaman[_halamanAktif],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _halamanAktif,
        onTap: (index) => setState(() => _halamanAktif = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.cardBg,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textGrey,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
        elevation: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Jadwal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_outlined),
            activeIcon: Icon(Icons.restaurant),
            label: 'Diet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Progres',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}