import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class SimpleUi extends StatelessWidget {
  final AudioPlayer audioPlayer;
  final String imageUrl;
  final String trackTitle;
  final String trackSubtitle;
  final bool hasNext;
  final bool hasPrevious;
  final String trackPosition;
  final String trackLength;
  final double playbackPosition;
  final AudioPlayerState audioPlayerState;
  final Function(double position) seekTrack;

  const SimpleUi(
      {Key key,
      this.audioPlayer,
      this.imageUrl,
      this.trackTitle,
      this.trackSubtitle,
      this.hasNext,
      this.hasPrevious,
      this.trackPosition,
      this.trackLength,
      this.playbackPosition,
      this.audioPlayerState,
      this.seekTrack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          color: Color.fromRGBO(21, 27, 33, 1.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: <Widget>[
                audioPlayerState == AudioPlayerState.STOPPED ||
                        audioPlayerState == AudioPlayerState.PAUSED ||
                        audioPlayerState == AudioPlayerState.COMPLETED
                    ? FloatingActionButton(
                        onPressed: () {
                          audioPlayer.resume();
                        },
                        tooltip: 'Play',
                        backgroundColor: theme.accentColor,
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                        mini: true,
                      )
                    : FloatingActionButton(
                        onPressed: () {
                          audioPlayer.pause();
                        },
                        tooltip: 'Pause',
                        backgroundColor: theme.accentColor,
                        child: Icon(
                          Icons.pause,
                          color: Colors.white,
                        ),
                        mini: true,
                      ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          top: 0.0,
                        ),
                        child: SliderTheme(
                          data: SliderThemeData(
                              trackShape: RoundedRectSliderTrackShape()),
                          child: Slider(
                            onChanged: seekTrack,
                            value: playbackPosition,
                            activeColor: theme.accentColor,
                            inactiveColor: Colors.white,
                          ),
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
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                            Text(
                              trackLength,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Text(
            trackTitle,
            style: TextStyle(
                color: Color.fromRGBO(188, 189, 193, 1.0),
                fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }
}
