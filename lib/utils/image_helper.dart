import 'dart:convert';
import 'package:flutter/material.dart';

class ImageHelper {
  static bool isBase64(String str) {
    return str.startsWith('data:image');
  }

  static Widget buildFotoProfil({
    required String photoUrl,
    required double radius,
    Color backgroundColor = const Color(0xFFDEEAF1),
    Widget? placeholder,
  }) {
    if (photoUrl.isEmpty) {
      return placeholder ??
          Icon(
            Icons.person,
            size: radius,
            color: const Color(0xFF1A3A5C),
          );
    }

    if (isBase64(photoUrl)) {
      try {
        final base64Str = photoUrl.split(',').last;
        final bytes = base64Decode(base64Str);
        return ClipOval(
          child: Image.memory(
            bytes,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Icon(Icons.person,
                    size: radius, color: const Color(0xFF1A3A5C)),
          ),
        );
      } catch (e) {
        return placeholder ??
            Icon(Icons.person,
                size: radius, color: const Color(0xFF1A3A5C));
      }
    }

    return ClipOval(
      child: Image.network(
        photoUrl,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Icon(Icons.person,
                size: radius, color: const Color(0xFF1A3A5C)),
      ),
    );
  }
}