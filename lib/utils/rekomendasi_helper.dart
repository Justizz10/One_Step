class RekomendasiHelper {
  static const List<Map<String, dynamic>> _daftarRekomendasi = [
    // ── SENIN ──────────────────────────────────────────
    {
      'nama': 'Jogging Pagi',
      'deskripsi': 'Lari santai di sekitar lingkungan rumah atau taman terdekat untuk memulai minggu dengan semangat.',
      'durasi': '30 menit',
      'intensitas': 'Sedang',
      'kalori': '~250 kkal',
      'ikons': 'run',
      'tips': 'Mulai dengan pemanasan 5 menit jalan kaki, lalu jogging 20 menit, dinginkan 5 menit.',
    },
    // ── SELASA ─────────────────────────────────────────
    {
      'nama': 'Yoga & Peregangan',
      'deskripsi': 'Serangkaian gerakan yoga untuk meningkatkan fleksibilitas, keseimbangan, dan ketenangan pikiran.',
      'durasi': '40 menit',
      'intensitas': 'Ringan',
      'kalori': '~150 kkal',
      'ikons': 'yoga',
      'tips': 'Fokus pada pernapasan dalam. Lakukan di ruangan tenang dengan alas yoga atau karpet.',
    },
    // ── RABU ───────────────────────────────────────────
    {
      'nama': 'Bersepeda',
      'deskripsi': 'Bersepeda santai di sekitar lingkungan atau taman. Baik untuk kesehatan jantung dan sendi.',
      'durasi': '45 menit',
      'intensitas': 'Sedang',
      'kalori': '~300 kkal',
      'ikons': 'bike',
      'tips': 'Gunakan helm dan pastikan ban dalam kondisi baik. Pilih jalur yang aman dari kendaraan.',
    },
    // ── KAMIS ──────────────────────────────────────────
    {
      'nama': 'Senam Aerobik',
      'deskripsi': 'Gerakan aerobik berirama untuk meningkatkan kebugaran kardiovaskular dan membakar kalori efektif.',
      'durasi': '35 menit',
      'intensitas': 'Tinggi',
      'kalori': '~280 kkal',
      'ikons': 'senam',
      'tips': 'Ikuti video senam aerobik di YouTube. Pastikan ada ruang gerak yang cukup di sekitar Anda.',
    },
    // ── JUMAT ──────────────────────────────────────────
    {
      'nama': 'Jalan Kaki Cepat',
      'deskripsi': 'Berjalan kaki dengan tempo cepat selama 30-45 menit. Cocok untuk semua usia dan kondisi kebugaran.',
      'durasi': '40 menit',
      'intensitas': 'Ringan',
      'kalori': '~180 kkal',
      'ikons': 'walk',
      'tips': 'Jaga postur tubuh tegak, ayunkan tangan, dan langkah kaki lebih lebar dari biasanya.',
    },
    // ── SABTU ──────────────────────────────────────────
    {
      'nama': 'Lompat Tali',
      'deskripsi': 'Olahraga sederhana namun efektif untuk kardio, koordinasi, dan membakar kalori dalam waktu singkat.',
      'durasi': '25 menit',
      'intensitas': 'Tinggi',
      'kalori': '~300 kkal',
      'ikons': 'jump',
      'tips': 'Lakukan 3 set × 5 menit dengan istirahat 2 menit antar set. Gunakan alas yang empuk.',
    },
    // ── MINGGU ─────────────────────────────────────────
    {
      'nama': 'Renang Santai',
      'deskripsi': 'Berenang gaya bebas atau gaya punggung dengan tempo santai. Olahraga full-body yang minim risiko cedera.',
      'durasi': '45 menit',
      'intensitas': 'Sedang',
      'kalori': '~350 kkal',
      'ikons': 'swim',
      'tips': 'Lakukan pemanasan di tepi kolam dulu. Bergantian gaya renang agar semua otot terlatih.',
    },
  ];

  // Ambil rekomendasi berdasarkan hari
  static Map<String, dynamic> getRekomendasiHariIni() {
    final index = DateTime.now().weekday - 1; // 0=Senin, 6=Minggu
    return _daftarRekomendasi[index % _daftarRekomendasi.length];
  }

  // Ambil nama hari
  static String getNamaHari() {
    const namaHari = [
      'Senin', 'Selasa', 'Rabu', 'Kamis',
      'Jumat', 'Sabtu', 'Minggu'
    ];
    return namaHari[DateTime.now().weekday - 1];
  }

  // Warna intensitas
  static Map<String, dynamic> getInfoIntensitas(
      String intensitas) {
    switch (intensitas) {
      case 'Ringan':
        return {'warna': 0xFF2E7D32, 'bg': 0xFFE8F5E9};
      case 'Tinggi':
        return {'warna': 0xFFC62828, 'bg': 0xFFFFEBEE};
      default: // Sedang
        return {'warna': 0xFFF9A825, 'bg': 0xFFFFFDE7};
    }
  }

  // Ikon berdasarkan jenis olahraga
  static String getIkon(String ikons) {
    switch (ikons) {
      case 'run': return '🏃';
      case 'yoga': return '🧘';
      case 'bike': return '🚴';
      case 'senam': return '🤸';
      case 'walk': return '🚶';
      case 'jump': return '⏭️';
      case 'swim': return '🏊';
      default: return '💪';
    }
  }
}