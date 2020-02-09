class YouTubePlayList {
  final String id;
  final String title;
  final String thumbnail;

  YouTubePlayList({this.id, this.title, this.thumbnail});

  factory YouTubePlayList.fromMap(Map<String, dynamic> map) {
    return YouTubePlayList(
      id: map['id'],
      title: map['snippet']['title'],
      thumbnail: map['snippet']['thumbnails']['default']['url'],
    );
  }
}
