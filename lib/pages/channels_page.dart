import 'package:flutter/material.dart';
import 'package:fluttertube/models/youtube_channel.dart';
import 'package:fluttertube/pages/playlist_page.dart';
import 'package:fluttertube/services/youtube_api.dart';
import 'package:fluttertube/utils/keys.dart';

class ChannelsPage extends StatefulWidget {
  @override
  _ChannelsPageState createState() => _ChannelsPageState();
}

class _ChannelsPageState extends State<ChannelsPage> {
  List<YouTubeChannel> _channels = [];
  bool _isLoading = false;

  _getChannels() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var api = YouTubeApiService();
      var channelsKeys = YOUTUBE_CHANNELS_ID.keys;

      for (var i = 0; i < channelsKeys.length; i++) {
        _channels.add(
            await api.getChannelWithId(channelId: channelsKeys.elementAt(i)));
        await Future.delayed(Duration(milliseconds: 500));
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
    _getChannels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Channels"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(10.0),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  var channel = _channels[index];
                  return ListTile(
                    leading: CircleAvatar(
                        backgroundImage: NetworkImage(channel.profilePictureUrl,
                            scale: 1.0)),
                    title: Text(channel.title),
                    subtitle: Text('Subscriber: ${channel.subscriberCount}'),
                    onTap: () {
                      // Navigate to playlist
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              PlayListPage(channelId: channel.id)));
                    },
                  );
                },
                itemCount: _channels.length,
              ),
            ),
    );
  }
}
