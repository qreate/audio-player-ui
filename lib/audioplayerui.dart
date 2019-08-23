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

  //
  String trackPosition = "0:00";
  String trackLength = "0:00";

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
      Duration audioPlayerDuration =
          Duration(milliseconds: await audioPlayer.getDuration());
      int trackDuration = ((await audioPlayer.getDuration()) / 1000).round();
      String trackLengthFormat = _printDuration(audioPlayerDuration);
      String trackPositionFormat = _printDuration(p);
      setState(() {
        playbackPosition = (p.inSeconds / trackDuration).toDouble();
        trackLength = trackLengthFormat;
        trackPosition = trackPositionFormat;
      });
    });
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
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
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
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
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        trackTitle != null || trackSubtitle != null
                            ? Expanded(
                                child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 12, top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    trackTitle != null
                                        ? Text(
                                            trackTitle,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          )
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
                              ))
                            : Container(
                                child: null,
                              ),
                        Container(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 18.0, right: 18),
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
                                    ? FloatingActionButton(
                                        onPressed: () {
                                          audioPlayer.resume();
                                        },
                                        tooltip: 'Play',
                                        child: Icon(Icons.play_arrow),
                                        mini: true,
                                      )
                                    : FloatingActionButton(
                                        onPressed: () {
                                          audioPlayer.pause();
                                        },
                                        tooltip: 'Pause',
                                        child: Icon(Icons.pause),
                                        mini: true,
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
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          top: 0.0,
                        ),
                        child: Slider(
                          onChanged: _seekTrack,
                          value: playbackPosition,
                          activeColor: theme.accentColor,
                          inactiveColor:
                              Color.alphaBlend(theme.accentColor, Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 28.0,
                          right: 28.0,
                          bottom: 12.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              trackPosition,
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              trackLength,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    ],
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
    audioPlayer.dispose();
    super.dispose();
  }
}
