import 'package:flutter/material.dart';
import 'package:fluttertube/models/youtube_video.dart';
import 'package:fluttertube/services/youtube_api.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'package:youtube_player/youtube_player.dart';

class VideosPage extends StatefulWidget {
  VideosPage({Key key, this.playListId}) : super(key: key);
  final String playListId;
  @override
  _VideosPageState createState() => new _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  bool _isLoading = false;
  bool _isPlaying = false;
  String _videoId = "";
  List<YouTubeVideo> _videos = [];
  ScrollController _scrollController = ScrollController();
  // VideoPlayerController _videoPlayerController;
  YoutubePlayerController _controller;

  _getVideos(bool isFirst) async {
    setState(() {
      _isLoading = true;
    });

    try {
      var api = YouTubeApiService();
      _videos.addAll(await api.getVideosFromPlaylistId(
          playlistId: widget.playListId, isFirst: isFirst));
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
    _getVideos(true);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getVideos(false);
      }
    });
  }

  listener() {
    print("LISTNER");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _videoPlayerController?.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Videos"),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                _isPlaying
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: YoutubePlayer(
                          controller: _controller,
                          showVideoProgressIndicator: true,
                          // videoProgressIndicatorColor: Colors.amber,
                          progressColors: ProgressBarColors(
                            playedColor: Colors.amber,
                            handleColor: Colors.amberAccent,
                          ),
                          onReady: () {
                            _controller.addListener(listener);
                          },
                        ),
                        // child: YoutubePlayer(
                        //   context: context,
                        //   source: _videoId,
                        //   quality: YoutubeQuality.MEDIUM,
                        //   aspectRatio: 16 / 9,
                        //   autoPlay: true,
                        //   loop: false,
                        //   reactToOrientationChange: true,
                        //   startFullScreen: false,
                        //   controlsActiveBackgroundOverlay: true,
                        //   controlsTimeOut: Duration(seconds: 4),
                        //   playerMode: YoutubePlayerMode.DEFAULT,
                        //   // callbackController is (optional).
                        //   // use it to control player on your own.
                        //   callbackController: (controller) {
                        //     _videoPlayerController = controller;
                        //   },
                        //   onError: (error) {
                        //     print(error);
                        //   },
                        //   onVideoEnded: () {
                        //     print("DONE");
                        //   },
                        // ),
                      )
                    : Container(),
                SizedBox(
                  height: _isPlaying
                      ? MediaQuery.of(context).size.height * 0.55
                      : MediaQuery.of(context).size.height * 0.85,
                  // height: MediaQuery.of(context).size.height * 0.85,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      var play = _videos[index];
                      return ListTile(
                        leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(play.thumbnailUrl, scale: 1.0)),
                        title: Text(play.title),
                        onTap: () {
                          // play video
                          if (_isPlaying) {
                            _controller.dispose();
                          }
                          setState(() {
                            _isPlaying = true;
                            _videoId = play.id;
                          });

                          _controller = YoutubePlayerController(
                            initialVideoId: _videoId,
                            flags: YoutubePlayerFlags(
                              mute: false,
                              autoPlay: true,
                            ),
                          );
                        },
                      );
                    },
                    itemCount: _videos.length,
                  ),
                ),
              ],
            ),
          ),
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(),
        ],
      ),
    );
  }
}
