import 'package:sound_cloud_api/data/models/track_model.dart';

class Playlist {
  final int id;
  final String title;
  final String description;
  final int duration;
  final int nbTracks;
  final String picture;
  final String pictureSmall;
  final String pictureMedium;
  final String pictureBig;
  final String pictureXl;
  final String tracklist;
  final String creationDate;
  final Creator? creator;
  final List<Track> tracks;

  Playlist({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.nbTracks,
    required this.picture,
    required this.pictureSmall,
    required this.pictureMedium,
    required this.pictureBig,
    required this.pictureXl,
    required this.tracklist,
    required this.creationDate,
    this.creator,
    required this.tracks,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) => Playlist(
        id: json["id"] ?? 0,
        title: json["title"] ?? "",
        description: json["description"] ?? "",
        duration: json["duration"] ?? 0,
        nbTracks: json["nb_tracks"] ?? 0,
        picture: json["picture"] ?? "",
        pictureSmall: json["picture_small"] ?? "",
        pictureMedium: json["picture_medium"] ?? "",
        pictureBig: json["picture_big"] ?? "",
        pictureXl: json["picture_xl"] ?? "",
        tracklist: json["tracklist"] ?? "",
        creationDate: json["creation_date"] ?? "",
        creator: json["creator"] != null ? Creator.fromJson(json["creator"]) : null,
        tracks: json["tracks"] != null && json["tracks"]["data"] != null
            ? List<Track>.from(
                json["tracks"]["data"].map((x) => Track.fromJson(x)))
            : [],
      );
}

class Creator {
  final int id;
  final String name;
  final String tracklist;
  final String type;

  Creator({
    required this.id,
    required this.name,
    required this.tracklist,
    required this.type,
  });

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        tracklist: json["tracklist"] ?? "",
        type: json["type"] ?? "",
      );
}
