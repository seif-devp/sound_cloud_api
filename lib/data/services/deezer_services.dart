import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sound_cloud_api/data/models/playlist_model.dart';
import 'package:sound_cloud_api/data/models/track_model.dart';

class DeezerServices {
  final String baseUrl = "https://api.deezer.com";
  late final Dio dio;

  DeezerServices() {
    dio =
        Dio(
            BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
              sendTimeout: const Duration(seconds: 15),
              headers: {
                'User-Agent':
                    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
                'Accept': 'application/json',
              },
            ),
          )
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
  }

  Future<List<Track>> searchTracks({required String name}) async {
    try {
      String path;

      // Use search endpoint - it's most reliable
      if (name.toLowerCase() == 'trending') {
        // Search for popular content
        path = "/search?q=harry%20styles&limit=50";
      } else {
        // Regular search
        path = "/search?q=$name&limit=50";
      }

    

      final response = await dio.get(path);

     
      // Parse the response
      final trackResponse = TrackResponse.fromJson(response.data);
      return trackResponse.data;
    } on DioException catch (e) {
    
      // More specific error handling
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
          "⏱️ Connection timeout (15s) - The API server didn't respond in time. Check your internet connection.",
        );
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
          "⏱️ Receive timeout (15s) - Taking too long to download response. The server may be slow.",
        );
      } else if (e.type == DioExceptionType.sendTimeout) {
        throw Exception(
          "⏱️ Send timeout (15s) - Taking too long to send request.",
        );
      } else if (e.type == DioExceptionType.unknown) {
        final errorStr = e.error.toString();
        if (errorStr.contains('SocketException') ||
            errorStr.contains('Network is unreachable')) {
          throw Exception(
            "🌐 Network error - No internet connection or network unreachable. Check your WiFi/Mobile data.",
          );
        } else if (errorStr.contains('Connection refused')) {
          throw Exception(
            "🔌 Connection refused - The server rejected the connection. The API may be blocked or down.",
          );
        } else if (errorStr.contains('DNS')) {
          throw Exception(
            "🔍 DNS error - Can't resolve api.deezer.com. Check your internet or DNS settings.",
          );
        }
        throw Exception("Network error - ${e.message}\nDetails: $errorStr");
      } else if (e.type == DioExceptionType.badResponse) {
        throw Exception(
          "Bad response (${e.response?.statusCode}) - The server returned an error.",
        );
      }
      rethrow;
    } catch (e) {
     
      throw Exception("Failed to search tracks: $e");
    }
  }

  Future<Playlist> fetchPlaylist(String playlistId) async {
    try {
      final response = await dio.get("/playlist/$playlistId");
      return Playlist.fromJson(response.data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
          "⏱️ Connection timeout (15s) - The API server didn't respond in time. Check your internet connection.",
        );
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
          "⏱️ Receive timeout (15s) - Taking too long to download response. The server may be slow.",
        );
      } else if (e.type == DioExceptionType.sendTimeout) {
        throw Exception(
          "⏱️ Send timeout (15s) - Taking too long to send request.",
        );
      } else if (e.type == DioExceptionType.unknown) {
        final errorStr = e.error.toString();
        if (errorStr.contains('SocketException') ||
            errorStr.contains('Network is unreachable')) {
          throw Exception(
            "🌐 Network error - No internet connection or network unreachable. Check your WiFi/Mobile data.",
          );
        } else if (errorStr.contains('Connection refused')) {
          throw Exception(
            "🔌 Connection refused - The server rejected the connection. The API may be blocked or down.",
          );
        } else if (errorStr.contains('DNS')) {
          throw Exception(
            "🔍 DNS error - Can't resolve api.deezer.com. Check your internet or DNS settings.",
          );
        }
        throw Exception("Network error - ${e.message}\nDetails: $errorStr");
      } else if (e.type == DioExceptionType.badResponse) {
        throw Exception(
          "Bad response (${e.response?.statusCode}) - The server returned an error.",
        );
      }
      rethrow;
    } catch (e) {
      throw Exception("Failed to fetch playlist: $e");
    }
  }
}
