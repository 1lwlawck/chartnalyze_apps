// lib/app/services/news_meta_service.dart
import 'package:metadata_fetch/metadata_fetch.dart';

class NewsMetaService {
  Future<String?> getThumbnail(String url) async {
    final data = await MetadataFetch.extract(url);
    return data?.image;
  }
}
