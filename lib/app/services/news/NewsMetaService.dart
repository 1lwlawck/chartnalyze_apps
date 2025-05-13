import 'package:metadata_fetch/metadata_fetch.dart';

class NewsMetaService {
  Future<String?> getThumbnail(String url) async {
    if (!url.startsWith('http')) return null;
    final data = await MetadataFetch.extract(url);
    return data?.image;
  }
}
