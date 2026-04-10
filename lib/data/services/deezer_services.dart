import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sound_cloud_api/data/models/track_model.dart';

class DeezerServices {
  final String baseUrl = "https://api.deezer.com/search?q=";
  final Dio dio = Dio()
    ..interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );

  Future<List<Track>> searchTracks({required String name}) async {
    // 👇 ضفنا الـ name في نهاية اللينك هنا
    final response = await dio.get("$baseUrl$name");

    // 1. بناخد الـ Map اللي راجع ونحوله لـ TrackResponse
    final trackResponse = TrackResponse.fromJson(response.data);

    // 2. بنرجع الـ data اللي جواه (اللي هي عبارة عن List<Track>)
    return trackResponse.data;
  }
}
