class YouTubeVideo {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;

  YouTubeVideo({
    this.id,
    this.title,
    this.thumbnailUrl,
    this.channelTitle,
  });

  factory YouTubeVideo.fromMap(Map<String, dynamic> snippet) {
    return YouTubeVideo(
      id: snippet['resourceId']['videoId'],
      title: snippet['title'],
      thumbnailUrl: snippet['thumbnails']['high']['url'],
      channelTitle: snippet['channelTitle'],
    );
  }
}
