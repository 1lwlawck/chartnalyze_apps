import 'package:flutter_dotenv/flutter_dotenv.dart';

String replaceLocalhost(String url) {
  if (url.isEmpty) return url;

  final imageBaseUrl = dotenv.env['IMAGE_BASE_URL'] ?? 'http://localhost';

  // Extract host dari env (bisa berupa IP atau domain)
  final replacementHost = Uri.parse(imageBaseUrl).host;

  final parsedUrl = Uri.tryParse(url);

  // Kalau URL valid dan host-nya localhost, ganti
  if (parsedUrl != null && parsedUrl.host == 'localhost') {
    return url.replaceFirst('localhost', replacementHost);
  }

  return url;
}
