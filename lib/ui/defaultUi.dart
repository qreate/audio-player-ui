import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class DefaultUi extends StatelessWidget {
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

  const DefaultUi({
    Key key,
    this.audioPlayer,
    this.imageUrl,
    this.trackTitle,
    this.trackSubtitle,
    this.hasNext = false,
    this.hasPrevious = false,
    this.playbackPosition = 0.0,
    this.audioPlayerState = AudioPlayerState.STOPPED,
    this.trackPosition = "00:00",
    this.trackLength = "00:00",
    this.seekTrack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
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

            imageUrl != null
                ? Column(
                    children: <Widget>[
                      Image.network(imageUrl),
                      Divider(),
                    ],
                  )
                : Container(
                    child: null,
                  ),
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
                                    const EdgeInsets.only(left: 18, top: 10),
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
                                            AudioPlayerState.PAUSED ||
                                        audioPlayerState ==
                                            AudioPlayerState.COMPLETED
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
                          onChanged: seekTrack,
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
}
