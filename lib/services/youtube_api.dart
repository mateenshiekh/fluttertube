import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fluttertube/models/youtube_channel.dart';
import 'package:fluttertube/models/youtube_playlist.dart';
import 'package:fluttertube/models/youtube_video.dart';
import 'package:fluttertube/services/datahandling.dart';
import 'package:fluttertube/utils/keys.dart';

class YouTubeApiService {
  YouTubeApiService._instantiate();
  static final _instance = YouTubeApiService._instantiate();
  factory YouTubeApiService() => _instance;

  final String _baseUrl = "www.googleapis.com";
  String _nextPageToken = "";

  Future<YouTubeChannel> getChannelWithId({@required String channelId}) async {
    Map<String, String> queryParam = {
      "id": channelId,
      'part': "snippet, contentDetails, statistics",
      'key': YOUTUBE_API_KEY
    };

    var uri = Uri.https(_baseUrl, "/youtube/v3/channels", queryParam);

    var headers = {HttpHeaders.contentTypeHeader: "application/json"};
    var h = HttpRestClient();
    var res = await h.getAsync(uri, headers: headers);

    if (res.success) {
      return YouTubeChannel.fromMap(res.content['items'][0]);
    } else {
      throw Exception(res.content['error']['message']);
    }
  }

  Future<List<YouTubeVideo>> getVideosFromPlaylistId(
      {@required String playlistId, bool isFirst = false}) async {
    if (isFirst) _nextPageToken = "";

    Map<String, String> queryParam = {
      'part': 'snippet',
      'playlistId': playlistId,
      'maxResults': '15',
      'pageToken': _nextPageToken,
      'key': YOUTUBE_API_KEY,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      queryParam,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    var h = HttpRestClient();
    var res = await h.getAsync(uri, headers: headers);

    if (res.success) {
      _nextPageToken = res.content['nextPageToken'] ?? '';
      List<dynamic> videosJson = res.content['items'];

      // Fetch first eight videos from uploads playlist
      List<YouTubeVideo> videos = [];
      videosJson.forEach(
        (json) => videos.add(
          YouTubeVideo.fromMap(json['snippet']),
        ),
      );
      return videos;
    } else {
      throw Exception(res.content['error']['message']);
    }
  }

  Future<YouTubePlayList> getPlaylistFromChannel(
      {@required String playlistId}) async {
    Map<String, String> queryParam = {
      "id": playlistId,
      'part': 'snippet',
      'key': YOUTUBE_API_KEY,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlists',
      queryParam,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    var h = HttpRestClient();
    var response = await h.getAsync(uri, headers: headers);

    if (response.success) {
      return YouTubePlayList.fromMap(response.content['items'][0]);
    } else {
      throw Exception(response.content['error']['message']);
    }
  }
}
