import 'dart:convert';
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class FotoProfilScreen extends StatelessWidget {
  final String photoUrl;
  final String nama;

  const FotoProfilScreen({
    super.key,
    required this.photoUrl,
    required this.nama,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          nama,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          // Bisa zoom in/out dengan gesture
          minScale: 0.5,
          maxScale: 4.0,
          child: _buildFoto(),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16),
        child: Text(
          'Cubit untuk zoom · Tap dua kali untuk zoom penuh',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildFoto() {
    if (photoUrl.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person,
              size: 120,
              color: Colors.white.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            'Belum ada foto profil',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ],
      );
    }

    // Foto Base64
    if (photoUrl.startsWith('data:image')) {
      try {
        final base64Str = photoUrl.split(',').last;
        final bytes = base64Decode(base64Str);
        return Image.memory(
          bytes,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _buildError(),
        );
      } catch (_) {
        return _buildError();
      }
    }

    // Foto URL
    return Image.network(
      photoUrl,
      fit: BoxFit.contain,
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: progress.expectedTotalBytes != null
                ? progress.cumulativeBytesLoaded /
                progress.expectedTotalBytes!
                : null,
            color: Colors.white,
          ),
        );
      },
      errorBuilder: (_, __, ___) => _buildError(),
    );
  }

  Widget _buildError() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.broken_image,
            size: 80,
            color: Colors.white.withValues(alpha: 0.3)),
        const SizedBox(height: 16),
        Text(
          'Gagal memuat foto',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}