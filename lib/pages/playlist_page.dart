import 'package:flutter/material.dart';
import 'package:fluttertube/models/youtube_playlist.dart';
import 'package:fluttertube/pages/videos_page.dart';
import 'package:fluttertube/services/youtube_api.dart';
import 'package:fluttertube/utils/keys.dart';

class PlayListPage extends StatefulWidget {
  PlayListPage({Key key, @required this.channelId}) : super(key: key);
  final String channelId;
  @override
  _PlayListPageState createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage> {
  bool _isLoading = false;
  List<YouTubePlayList> _playlists = [];

  _getPlayList() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var api = YouTubeApiService();
      var list = YOUTUBE_CHANNELS_ID[widget.channelId];
      for (var id in list) {
        _playlists.add(await api.getPlaylistFromChannel(playlistId: id));
      }
    } catch (e) {
      print(e);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPlayList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Playlist"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(10.0),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  var play = _playlists[index];
                  return ListTile(
                    leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(play.thumbnail, scale: 1.0)),
                    title: Text(play.title),
                    onTap: () {
                      // Navigate to video
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              VideosPage(playListId: play.id)));
                    },
                  );
                },
                itemCount: _playlists.length,
              ),
            ),
    );
  }
}
