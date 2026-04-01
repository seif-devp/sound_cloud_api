import 'dart:convert';

TrackResponse trackResponseFromJson(String str) => TrackResponse.fromJson(json.decode(str));

String trackResponseToJson(TrackResponse data) => json.encode(data.toJson());

class TrackResponse {
    final List<Track> data; // هنا خلينا الليست من نوع Track
    final int total;
    final String next;

    TrackResponse({
        required this.data,
        required this.total,
        required this.next,
    });

    factory TrackResponse.fromJson(Map<String, dynamic> json) => TrackResponse(
        data: List<Track>.from(json["data"].map((x) => Track.fromJson(x))),
        total: json["total"] ?? 0,
        next: json["next"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "total": total,
        "next": next,
    };
}

// غيرنا اسم Datum لـ Track
class Track {
    final int id;
    final bool readable;
    final String title;
    final String titleShort;
    final String titleVersion;
    final String? isrc;
    final String? link;
    final int duration;
    final int rank;
    final bool explicitLyrics;
    final int explicitContentLyrics;
    final int explicitContentCover;
    final String? preview;
    final String md5Image;
    final Artist artist;
    final Album album;
    final String type;

    Track({
        required this.id,
        required this.readable,
        required this.title,
        required this.titleShort,
        required this.titleVersion,
        this.isrc,
        this.link,
        required this.duration,
        required this.rank,
        required this.explicitLyrics,
        required this.explicitContentLyrics,
        required this.explicitContentCover,
        this.preview,
        required this.md5Image,
        required this.artist,
        required this.album,
        required this.type,
    });

    factory Track.fromJson(Map<String, dynamic> json) => Track(
        id: json["id"] ?? 0,
        readable: json["readable"] ?? false,
        title: json["title"] ?? "",
        titleShort: json["title_short"] ?? "",
        titleVersion: json["title_version"] ?? "",
        isrc: json["isrc"],
        link: json["link"],
        duration: json["duration"] ?? 0,
        rank: json["rank"] ?? 0,
        explicitLyrics: json["explicit_lyrics"] ?? false,
        explicitContentLyrics: json["explicit_content_lyrics"] ?? 0,
        explicitContentCover: json["explicit_content_cover"] ?? 0,
        preview: json["preview"],
        md5Image: json["md5_image"] ?? "",
        artist: Artist.fromJson(json["artist"]),
        album: Album.fromJson(json["album"]),
        type: json["type"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "readable": readable,
        "title": title,
        "title_short": titleShort,
        "title_version": titleVersion,
        "isrc": isrc,
        "link": link,
        "duration": duration,
        "rank": rank,
        "explicit_lyrics": explicitLyrics,
        "explicit_content_lyrics": explicitContentLyrics,
        "explicit_content_cover": explicitContentCover,
        "preview": preview,
        "md5_image": md5Image,
        "artist": artist.toJson(),
        "album": album.toJson(),
        "type": type,
    };
}

class Album {
    final int id;
    final String title;
    final String cover;
    final String coverSmall;
    final String coverMedium;
    final String coverBig;
    final String coverXl;
    final String md5Image;
    final String tracklist;
    final String type;

    Album({
        required this.id,
        required this.title,
        required this.cover,
        required this.coverSmall,
        required this.coverMedium,
        required this.coverBig,
        required this.coverXl,
        required this.md5Image,
        required this.tracklist,
        required this.type,
    });

    factory Album.fromJson(Map<String, dynamic> json) => Album(
        id: json["id"] ?? 0,
        title: json["title"] ?? "",
        cover: json["cover"] ?? "",
        coverSmall: json["cover_small"] ?? "",
        coverMedium: json["cover_medium"] ?? "",
        coverBig: json["cover_big"] ?? "",
        coverXl: json["cover_xl"] ?? "",
        md5Image: json["md5_image"] ?? "",
        tracklist: json["tracklist"] ?? "",
        type: json["type"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "cover": cover,
        "cover_small": coverSmall,
        "cover_medium": coverMedium,
        "cover_big": coverBig,
        "cover_xl": coverXl,
        "md5_image": md5Image,
        "tracklist": tracklist,
        "type": type,
    };
}

class Artist {
    final int id;
    final String name;
    final String link;
    final String picture;
    final String pictureSmall;
    final String pictureMedium;
    final String pictureBig;
    final String pictureXl;
    final String tracklist;
    final String type;

    Artist({
        required this.id,
        required this.name,
        required this.link,
        required this.picture,
        required this.pictureSmall,
        required this.pictureMedium,
        required this.pictureBig,
        required this.pictureXl,
        required this.tracklist,
        required this.type,
    });

    factory Artist.fromJson(Map<String, dynamic> json) => Artist(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        link: json["link"] ?? "",
        picture: json["picture"] ?? "",
        pictureSmall: json["picture_small"] ?? "",
        pictureMedium: json["picture_medium"] ?? "",
        pictureBig: json["picture_big"] ?? "",
        pictureXl: json["picture_xl"] ?? "",
        tracklist: json["tracklist"] ?? "",
        type: json["type"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "link": link,
        "picture": picture,
        "picture_small": pictureSmall,
        "picture_medium": pictureMedium,
        "picture_big": pictureBig,
        "picture_xl": pictureXl,
        "tracklist": tracklist,
        "type": type,
    };
}