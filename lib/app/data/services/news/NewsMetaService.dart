import 'package:metadata_fetch/metadata_fetch.dart';

class NewsMetaService {
  /// Mengambil thumbnail dari URL berita
  Future<String?> getThumbnail(String url) async {
    if (!url.startsWith('http')) return null;

    try {
      final data = await MetadataFetch.extract(url);
      return data?.image;
    } catch (e) {
      print('Failed to fetch metadata for $url: $e');
      return null;
    }
  }
}
