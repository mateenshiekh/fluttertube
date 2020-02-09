import 'package:fluttertube/models/youtube_video.dart';

class YouTubeChannel {
  final String id;
  final String title;
  final String profilePictureUrl;
  final String subscriberCount;
  final String videoCount;
  final String uploadPlaylistId;
  List<YouTubeVideo> videos;

  YouTubeChannel(
      {this.id,
      this.profilePictureUrl,
      this.subscriberCount,
      this.title,
      this.uploadPlaylistId,
      this.videoCount,
      this.videos});

  factory YouTubeChannel.fromMap(Map<String, dynamic> map) {
    return YouTubeChannel(
      id: map['id'],
      title: map['snippet']['title'],
      profilePictureUrl: map['snippet']['thumbnails']['default']['url'],
      subscriberCount: map['statistics']['subscriberCount'],
      videoCount: map['statistics']['videoCount'],
      uploadPlaylistId: map['contentDetails']['relatedPlaylists']['uploads'],
    );
  }
}
