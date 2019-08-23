library audioplayerui;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerController {
  AudioPlayer audioPlayer = AudioPlayer();

  void play(String url) {
    audioPlayer.play(url);
  }

  void playLocal(String localPath) {
    audioPlayer.play(localPath, isLocal: true);
  }
}

class AudioPlayerView extends StatefulWidget {
  final AudioPlayerController audioPlayerController;
  final String trackTitle;
  final String trackSubtitle;
  final String trackUrl;
  final bool isLocal;

  const AudioPlayerView(
      {Key key,
      @required this.audioPlayerController,
      this.trackTitle,
      this.trackSubtitle,
      this.trackUrl,
      this.isLocal = false})
      : super(key: key);

  @override
  _AudioPlayerViewState createState() => _AudioPlayerViewState(
      audioPlayerController,
      trackTitle,
      trackSubtitle,
      this.trackUrl,
      this.isLocal);
}

class _AudioPlayerViewState extends State<AudioPlayerView> {
  Duration duration = Duration();
  final AudioPlayerController audioPlayerController;
  AudioPlayer audioPlayer;
  bool hasNext = false;
  bool hasPrevious = false;
  double playbackPosition = 0.0;
  AudioPlayerState audioPlayerState = AudioPlayerState.STOPPED;
  final String trackTitle;
  final String trackSubtitle;
  final String trackUrl;
  final bool isLocal;

  _AudioPlayerViewState(this.audioPlayerController, this.trackTitle,
      this.trackSubtitle, this.trackUrl, this.isLocal);

  @override
  void initState() {
    audioPlayer = audioPlayerController.audioPlayer;
    _initTrackPlayback();
    _initPositionChangeListener();
    _initTrackChangeListener();

    super.initState();
  }

  _initTrackPlayback() {
    audioPlayer.play(trackUrl, isLocal: isLocal);
  }

  _initPositionChangeListener() async {
    audioPlayer.onAudioPositionChanged.listen((Duration p) async {
      int trackDuration = ((await audioPlayer.getDuration()) / 1000).round();
      setState(() {
        playbackPosition = (p.inSeconds / trackDuration).toDouble();
      });
    });
  }

  _initTrackChangeListener() {
    audioPlayer.onPlayerStateChanged
        .listen((AudioPlayerState audioPlayerStateUpdate) {
      setState(() {
        audioPlayerState = audioPlayerStateUpdate;
      });
    });
  }

  _seekTrack(double position) async {
    int trackDuration = ((await audioPlayer.getDuration()) / 1000).round();
    int seekPosition = (position * trackDuration).round();
    audioPlayer.seek(Duration(seconds: seekPosition));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle titleStyle =
        theme.textTheme.headline.copyWith(color: Colors.white);
    final TextStyle descriptionStyle = theme.textTheme.subhead;
    return Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Photo and title.

            DefaultTextStyle(
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: descriptionStyle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 4.0),
                        child: Slider(
                          onChanged: _seekTrack,
                          value: playbackPosition,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 18, right: 18, bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        trackTitle != null || trackSubtitle != null
                            ? Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    trackTitle != null
                                        ? Text(trackTitle)
                                        : Container(
                                            child: null,
                                          ),
                                    trackSubtitle != null
                                        ? Text(trackSubtitle)
                                        : Container(
                                            child: null,
                                          ),
                                  ],
                                ),
                              )
                            : Container(
                                child: null,
                              ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                hasPrevious
                                    ? IconButton(
                                        icon: Icon(Icons.skip_previous),
                                        onPressed: () {},
                                      )
                                    : Container(
                                        child: null,
                                      ),
                                audioPlayerState == AudioPlayerState.STOPPED ||
                                        audioPlayerState ==
                                            AudioPlayerState.PAUSED
                                    ? IconButton(
                                        icon: Icon(Icons.play_arrow),
                                        onPressed: () {
                                          audioPlayer.resume();
                                        },
                                      )
                                    : IconButton(
                                        icon: Icon(Icons.pause),
                                        onPressed: () {
                                          audioPlayer.pause();
                                        },
                                      ),
                                hasNext
                                    ? IconButton(
                                        icon: Icon(Icons.skip_next),
                                        onPressed: () {},
                                      )
                                    : Container(
                                        child: null,
                                      ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    audioPlayer.release();
    super.dispose();
  }
}
