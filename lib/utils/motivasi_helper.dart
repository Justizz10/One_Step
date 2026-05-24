class MotivasiHelper {
  // Daftar 31 kata motivasi (cukup untuk 1 bulan penuh)
  static const List<String> _daftarMotivasi = [
    "Mulai dari langkah kecil, hasilnya luar biasa! 💪",
    "Tubuh sehat adalah investasi terbaik hidupmu. 🌟",
    "Konsistensi mengalahkan motivasi sesaat. 🔥",
    "Setiap tetes keringat adalah langkah menuju versi terbaikmu. 💦",
    "Tidak ada yang sia-sia, setiap usaha pasti terbayar. ✨",
    "Hari ini lebih baik dari kemarin, besok lebih baik dari hari ini. 📈",
    "Tubuhmu bisa menanggung hampir segalanya, latihlah pikiranmu. 🧠",
    "Jangan berhenti saat lelah, berhentilah saat selesai. 🏁",
    "Satu langkah kecil setiap hari = perubahan besar setahun kemudian. 🚀",
    "Kesehatan bukan segalanya, tapi tanpa kesehatan segalanya bukan apa-apa. ❤️",
    "Kamu lebih kuat dari yang kamu bayangkan. 💥",
    "Olahraga hari ini adalah hadiah untuk dirimu di masa depan. 🎁",
    "Semangat! Setengah perjuangan adalah memulai. ⚡",
    "Jadikan sehat sebagai gaya hidupmu, bukan sekadar tren. 🌿",
    "Bergeraklah! Tubuhmu dirancang untuk aktif. 🏃",
    "Rasa lelah hari ini adalah kekuatan hari esok. 💫",
    "Setiap rep, setiap langkah membawamu lebih dekat ke tujuan. 🎯",
    "Jangan bandingkan perjalananmu dengan orang lain. Fokus pada dirimu! 👊",
    "Hidup sehat bukan hukuman, melainkan hadiah untuk dirimu. 🌈",
    "Pikiran positif menghasilkan tubuh yang sehat. 😊",
    "Kamu sudah memulai, itu saja sudah luar biasa! 🙌",
    "Disiplin hari ini = kebebasan di masa depan. 🕊️",
    "Jaga tubuhmu, itu satu-satunya tempat tinggalmu. 🏠",
    "Setiap olahraga yang kamu lakukan adalah kemenangan kecil. 🏆",
    "Mulai sekarang, bukan besok! Waktu terbaik adalah sekarang. ⏰",
    "Gerakan kecil yang konsisten lebih baik dari usaha besar yang sesekali. 🌊",
    "Percaya pada prosesmu. Hasilnya pasti datang. 🌱",
    "Tubuh yang aktif adalah jiwa yang bahagia. 😄",
    "Satu sesi olahraga tidak akan mengubahmu, tapi tidak pernah berolahraga pasti mengubahmu. 📉",
    "Kamu sudah melangkah lebih jauh dari mereka yang belum mulai. 👣",
    "One Way, One Closer — satu langkah lebih dekat ke tujuanmu! 🎽",
  ];

  // Ambil motivasi berdasarkan tanggal hari ini
  static String getMotivasiHariIni() {
    final hariIni = DateTime.now().day; // 1 - 31
    final index = (hariIni - 1) % _daftarMotivasi.length;
    return _daftarMotivasi[index];
  }

  // Ambil motivasi berdasarkan index tertentu (opsional)
  static String getMotivasi(int index) {
    return _daftarMotivasi[index % _daftarMotivasi.length];
  }
}