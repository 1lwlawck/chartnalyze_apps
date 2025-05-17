import 'package:characters/characters.dart';

/// Memotong string dengan aman berdasarkan jumlah karakter visible (bukan byte),
/// dan menambahkan `…` jika string lebih panjang dari batas.
String safeTruncate(String text, int maxChars) {
  final chars = text.characters;
  return chars.length > maxChars ? '${chars.take(maxChars)}…' : text;
}
