class MenuHelper {
  // 7 variasi menu mingguan sesuai standar WHO
  // Kalori target: 1800-2200 kkal/hari
  // Protein: 10-35%, Karbo: 45-65%, Lemak: 20-35%

  static const List<Map<String, dynamic>> _daftarMenu = [
    // ── SENIN ──────────────────────────────────────────
    {
      'tema': 'Menu Tinggi Protein',
      'totalKalori': '1.850 kkal',
      'menu': [
        {
          'waktu': '☀️ Sarapan',
          'jam': '06.00 - 08.00',
          'makanan': 'Oatmeal + Telur Rebus 2 butir + Susu Rendah Lemak',
          'kalori': '~420 kkal',
          'nutrisi': 'P: 24g | K: 52g | L: 12g',
        },
        {
          'waktu': '🍎 Snack Pagi',
          'jam': '10.00 - 10.30',
          'makanan': 'Pisang + Kacang Almond segenggam',
          'kalori': '~180 kkal',
          'nutrisi': 'P: 5g | K: 24g | L: 8g',
        },
        {
          'waktu': '🌤️ Makan Siang',
          'jam': '12.00 - 13.00',
          'makanan': 'Nasi Merah + Ayam Panggang + Tumis Brokoli + Sup Sayur',
          'kalori': '~580 kkal',
          'nutrisi': 'P: 38g | K: 68g | L: 14g',
        },
        {
          'waktu': '🍊 Snack Sore',
          'jam': '15.00 - 16.00',
          'makanan': 'Yogurt Greek + Buah Stroberi',
          'kalori': '~150 kkal',
          'nutrisi': 'P: 12g | K: 18g | L: 2g',
        },
        {
          'waktu': '🌙 Makan Malam',
          'jam': '18.00 - 19.30',
          'makanan': 'Nasi Merah + Ikan Salmon Panggang + Salad Sayur',
          'kalori': '~520 kkal',
          'nutrisi': 'P: 36g | K: 48g | L: 16g',
        },
      ],
    },

    // ── SELASA ─────────────────────────────────────────
    {
      'tema': 'Menu Seimbang & Serat Tinggi',
      'totalKalori': '1.900 kkal',
      'menu': [
        {
          'waktu': '☀️ Sarapan',
          'jam': '06.00 - 08.00',
          'makanan': 'Roti Gandum 2 lembar + Telur Dadar + Jus Jeruk Segar',
          'kalori': '~390 kkal',
          'nutrisi': 'P: 18g | K: 48g | L: 10g',
        },
        {
          'waktu': '🍎 Snack Pagi',
          'jam': '10.00 - 10.30',
          'makanan': 'Apel Merah + Keju Rendah Lemak',
          'kalori': '~160 kkal',
          'nutrisi': 'P: 6g | K: 22g | L: 5g',
        },
        {
          'waktu': '🌤️ Makan Siang',
          'jam': '12.00 - 13.00',
          'makanan': 'Nasi + Tempe Bacem + Sayur Asem + Kerupuk',
          'kalori': '~550 kkal',
          'nutrisi': 'P: 22g | K: 72g | L: 12g',
        },
        {
          'waktu': '🍊 Snack Sore',
          'jam': '15.00 - 16.00',
          'makanan': 'Smoothie Pisang + Bayam + Madu',
          'kalori': '~180 kkal',
          'nutrisi': 'P: 4g | K: 38g | L: 2g',
        },
        {
          'waktu': '🌙 Makan Malam',
          'jam': '18.00 - 19.30',
          'makanan': 'Nasi + Tahu Goreng + Tumis Kangkung + Sup Tomat',
          'kalori': '~520 kkal',
          'nutrisi': 'P: 20g | K: 62g | L: 14g',
        },
      ],
    },

    // ── RABU ───────────────────────────────────────────
    {
      'tema': 'Menu Rendah Kalori & Detoks',
      'totalKalori': '1.750 kkal',
      'menu': [
        {
          'waktu': '☀️ Sarapan',
          'jam': '06.00 - 08.00',
          'makanan': 'Smoothie Bowl: Pisang + Blueberry + Granola + Susu Almond',
          'kalori': '~380 kkal',
          'nutrisi': 'P: 10g | K: 62g | L: 8g',
        },
        {
          'waktu': '🍎 Snack Pagi',
          'jam': '10.00 - 10.30',
          'makanan': 'Timun + Wortel + Hummus 2 sdm',
          'kalori': '~120 kkal',
          'nutrisi': 'P: 4g | K: 16g | L: 5g',
        },
        {
          'waktu': '🌤️ Makan Siang',
          'jam': '12.00 - 13.00',
          'makanan': 'Salad Ayam + Nasi Merah + Dressing Lemon Olive Oil',
          'kalori': '~520 kkal',
          'nutrisi': 'P: 34g | K: 54g | L: 14g',
        },
        {
          'waktu': '🍊 Snack Sore',
          'jam': '15.00 - 16.00',
          'makanan': 'Teh Hijau Tanpa Gula + Kacang Edamame',
          'kalori': '~130 kkal',
          'nutrisi': 'P: 8g | K: 14g | L: 4g',
        },
        {
          'waktu': '🌙 Makan Malam',
          'jam': '18.00 - 19.30',
          'makanan': 'Sup Ayam Sayuran + Roti Gandum + Buah Pepaya',
          'kalori': '~600 kkal',
          'nutrisi': 'P: 28g | K: 72g | L: 10g',
        },
      ],
    },

    // ── KAMIS ──────────────────────────────────────────
    {
      'tema': 'Menu Karbohidrat Kompleks',
      'totalKalori': '2.000 kkal',
      'menu': [
        {
          'waktu': '☀️ Sarapan',
          'jam': '06.00 - 08.00',
          'makanan': 'Bubur Ayam + Telur Rebus + Kerupuk + Kedelai Hitam',
          'kalori': '~450 kkal',
          'nutrisi': 'P: 22g | K: 58g | L: 14g',
        },
        {
          'waktu': '🍎 Snack Pagi',
          'jam': '10.00 - 10.30',
          'makanan': 'Kurma 3 butir + Susu Kedelai Tanpa Gula',
          'kalori': '~170 kkal',
          'nutrisi': 'P: 6g | K: 28g | L: 3g',
        },
        {
          'waktu': '🌤️ Makan Siang',
          'jam': '12.00 - 13.00',
          'makanan': 'Nasi + Rendang Daging Sapi + Sayur Nangka + Lalapan',
          'kalori': '~620 kkal',
          'nutrisi': 'P: 32g | K: 70g | L: 20g',
        },
        {
          'waktu': '🍊 Snack Sore',
          'jam': '15.00 - 16.00',
          'makanan': 'Ubi Rebus + Teh Chamomile',
          'kalori': '~160 kkal',
          'nutrisi': 'P: 2g | K: 36g | L: 1g',
        },
        {
          'waktu': '🌙 Makan Malam',
          'jam': '18.00 - 19.30',
          'makanan': 'Nasi Merah + Pepes Ikan + Tumis Tauge + Buah Semangka',
          'kalori': '~600 kkal',
          'nutrisi': 'P: 30g | K: 72g | L: 12g',
        },
      ],
    },

    // ── JUMAT ──────────────────────────────────────────
    {
      'tema': 'Menu Anti Inflamasi',
      'totalKalori': '1.850 kkal',
      'menu': [
        {
          'waktu': '☀️ Sarapan',
          'jam': '06.00 - 08.00',
          'makanan': 'Overnight Oats + Chia Seed + Blueberry + Madu',
          'kalori': '~420 kkal',
          'nutrisi': 'P: 14g | K: 58g | L: 10g',
        },
        {
          'waktu': '🍎 Snack Pagi',
          'jam': '10.00 - 10.30',
          'makanan': 'Kacang Walnut + Buah Anggur',
          'kalori': '~190 kkal',
          'nutrisi': 'P: 4g | K: 22g | L: 10g',
        },
        {
          'waktu': '🌤️ Makan Siang',
          'jam': '12.00 - 13.00',
          'makanan': 'Nasi + Ikan Tuna Bakar + Tumis Bayam Bawang Putih + Jeruk',
          'kalori': '~560 kkal',
          'nutrisi': 'P: 36g | K: 64g | L: 12g',
        },
        {
          'waktu': '🍊 Snack Sore',
          'jam': '15.00 - 16.00',
          'makanan': 'Jus Kunyit + Jahe + Madu (Golden Milk)',
          'kalori': '~100 kkal',
          'nutrisi': 'P: 1g | K: 22g | L: 1g',
        },
        {
          'waktu': '🌙 Makan Malam',
          'jam': '18.00 - 19.30',
          'makanan': 'Quinoa + Ayam Kukus + Brokoli + Wortel Rebus',
          'kalori': '~580 kkal',
          'nutrisi': 'P: 38g | K: 62g | L: 14g',
        },
      ],
    },

    // ── SABTU ──────────────────────────────────────────
    {
      'tema': 'Menu Pemulihan Otot',
      'totalKalori': '2.100 kkal',
      'menu': [
        {
          'waktu': '☀️ Sarapan',
          'jam': '06.00 - 08.00',
          'makanan': 'Pancake Pisang Oat + Telur Dadar 2 butir + Susu Coklat',
          'kalori': '~520 kkal',
          'nutrisi': 'P: 26g | K: 64g | L: 16g',
        },
        {
          'waktu': '🍎 Snack Pagi',
          'jam': '10.00 - 10.30',
          'makanan': 'Protein Bar / Kacang Tanah + Pisang',
          'kalori': '~220 kkal',
          'nutrisi': 'P: 10g | K: 28g | L: 8g',
        },
        {
          'waktu': '🌤️ Makan Siang',
          'jam': '12.00 - 13.00',
          'makanan': 'Nasi + Ayam Geprek + Tempe + Lalapan + Es Teh',
          'kalori': '~680 kkal',
          'nutrisi': 'P: 40g | K: 76g | L: 18g',
        },
        {
          'waktu': '🍊 Snack Sore',
          'jam': '15.00 - 16.00',
          'makanan': 'Yogurt + Granola + Buah Kiwi',
          'kalori': '~200 kkal',
          'nutrisi': 'P: 8g | K: 30g | L: 5g',
        },
        {
          'waktu': '🌙 Makan Malam',
          'jam': '18.00 - 19.30',
          'makanan': 'Nasi Merah + Telur Balado + Tumis Buncis + Pepaya',
          'kalori': '~480 kkal',
          'nutrisi': 'P: 24g | K: 62g | L: 12g',
        },
      ],
    },

    // ── MINGGU ─────────────────────────────────────────
    {
      'tema': 'Menu Santai & Bergizi',
      'totalKalori': '1.950 kkal',
      'menu': [
        {
          'waktu': '☀️ Sarapan',
          'jam': '07.00 - 09.00',
          'makanan': 'Nasi Uduk + Telur Ceplok + Tempe Orek + Teh Manis',
          'kalori': '~480 kkal',
          'nutrisi': 'P: 20g | K: 62g | L: 16g',
        },
        {
          'waktu': '🍎 Snack Pagi',
          'jam': '10.30 - 11.00',
          'makanan': 'Buah Potong Campur + Air Kelapa',
          'kalori': '~160 kkal',
          'nutrisi': 'P: 2g | K: 36g | L: 1g',
        },
        {
          'waktu': '🌤️ Makan Siang',
          'jam': '12.30 - 13.30',
          'makanan': 'Soto Ayam + Nasi + Perkedel + Kerupuk',
          'kalori': '~620 kkal',
          'nutrisi': 'P: 30g | K: 74g | L: 18g',
        },
        {
          'waktu': '🍊 Snack Sore',
          'jam': '15.30 - 16.00',
          'makanan': 'Pisang Goreng 2 + Teh Tawar',
          'kalori': '~200 kkal',
          'nutrisi': 'P: 2g | K: 38g | L: 6g',
        },
        {
          'waktu': '🌙 Makan Malam',
          'jam': '18.30 - 19.30',
          'makanan': 'Mie Goreng Sehat + Ayam + Sayuran + Telur + Buah Jeruk',
          'kalori': '~490 kkal',
          'nutrisi': 'P: 28g | K: 58g | L: 14g',
        },
      ],
    },
  ];

  // Ambil menu berdasarkan hari (0=Senin, 6=Minggu)
  static Map<String, dynamic> getMenuHariIni() {
    // weekday: 1=Senin ... 7=Minggu
    final index = DateTime.now().weekday - 1;
    return _daftarMenu[index % _daftarMenu.length];
  }

  // Ambil nama hari dalam Bahasa Indonesia
  static String getNamaHari() {
    const namaHari = [
      'Senin', 'Selasa', 'Rabu', 'Kamis',
      'Jumat', 'Sabtu', 'Minggu'
    ];
    return namaHari[DateTime.now().weekday - 1];
  }
}