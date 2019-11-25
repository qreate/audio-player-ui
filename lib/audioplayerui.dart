library audioplayerui;

import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayerui/ui/defaultUi.dart';
import 'package:audioplayerui/ui/simpleUi.dart';
import 'package:flutter/material.dart';

class AudioPlayerController {
  AudioPlayer audioPlayer = AudioPlayer();

  final bool autoPlay;

  AudioPlayerController({this.autoPlay = false});

  void play(String url) {
    audioPlayer.play(url);
  }

  void playLocal(String localPath) {
    audioPlayer.play(localPath, isLocal: true);
  }

  void pause() {
    audioPlayer.pause();
  }

  void stop() {
    audioPlayer.stop();
  }

  void resume() {
    audioPlayer.resume();
  }
}

class AudioPlayerView extends StatefulWidget {
  final AudioPlayerController audioPlayerController;
  final String trackTitle;
  final String trackSubtitle;
  final String trackUrl;
  final bool isLocal;
  final String imageUrl;
  final bool simpleDesign;

  const AudioPlayerView(
      {Key key,
      @required this.audioPlayerController,
      this.trackTitle,
      this.trackSubtitle,
      this.trackUrl,
      this.isLocal = false,
      this.imageUrl,
      this.simpleDesign = false})
      : super(key: key);

  @override
  _AudioPlayerViewState createState() => _AudioPlayerViewState(
        audioPlayerController,
        trackTitle,
        trackSubtitle,
        this.trackUrl,
        this.isLocal,
        this.imageUrl,
        this.simpleDesign,
      );
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
  final String imageUrl;
  final bool simpleDesign;

  //
  String trackPosition = "00:00";
  String trackLength = "00:00";

  _AudioPlayerViewState(
    this.audioPlayerController,
    this.trackTitle,
    this.trackSubtitle,
    this.trackUrl,
    this.isLocal,
    this.imageUrl,
    this.simpleDesign,
  );

  @override
  void initState() {
    audioPlayer = audioPlayerController.audioPlayer;
    if (audioPlayerController.autoPlay) {
      _playTrack();
    } else {
      _initTrackPlayback();
    }
    _initPositionChangeListener();
    _initTrackChangeListener();

    super.initState();
  }

  _initTrackPlayback() async {
    await audioPlayer.setUrl(trackUrl, isLocal: isLocal).then((val) {
      audioPlayer.getDuration().then((duration) {
        Duration audioPlayerDuration = Duration(milliseconds: duration);
        print("audioPlayerDuration $duration");
        setState(() {
          trackLength = _printDuration(audioPlayerDuration);
        });
      });
    });
    print(trackUrl);
  }

  _playTrack() {
    audioPlayer.play(trackUrl, isLocal: isLocal);
  }

  _initPositionChangeListener() async {
    audioPlayer.onAudioPositionChanged.listen((Duration p) async {
      if (p.inMilliseconds ==
          Duration(milliseconds: await audioPlayer.getDuration())
              .inMilliseconds) {
        audioPlayer.seek(Duration(seconds: 0));
        audioPlayer.stop();
      }
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
    return simpleDesign
        ? SimpleUi(
            audioPlayer: audioPlayer,
            imageUrl: imageUrl,
            trackTitle: trackTitle,
            trackSubtitle: trackSubtitle,
            hasNext: hasNext,
            hasPrevious: hasPrevious,
            playbackPosition: playbackPosition,
            audioPlayerState: audioPlayerState,
            trackPosition: trackPosition,
            trackLength: trackLength,
            seekTrack: _seekTrack,
          )
        : DefaultUi(
            audioPlayer: audioPlayer,
            imageUrl: imageUrl,
            trackTitle: trackTitle,
            trackSubtitle: trackSubtitle,
            hasNext: hasNext,
            hasPrevious: hasPrevious,
            playbackPosition: playbackPosition,
            audioPlayerState: audioPlayerState,
            trackPosition: trackPosition,
            trackLength: trackLength,
            seekTrack: _seekTrack,
          );
  }

  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    super.dispose();
  }
}
