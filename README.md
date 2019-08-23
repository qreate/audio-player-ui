# audioplayerui


Audio Player UI Plugin.


## Features
* Play (url / local file)
* Resume / pause

## Installation

First, add `audioplayerui` as a dependency in your `pubspec.yaml` file. 

Then add the audioplayer like this 

```dart
  AudioPlayerController audioPlayerController = AudioPlayerController();

  @override
  Widget build(BuildContext context) {
    return AudioPlayerView(
      audioPlayerController: audioPlayerController,
      trackUrl: "",
      trackTitle: "",
    );
  }
``` 

