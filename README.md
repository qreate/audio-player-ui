# audioplayerui


Audio Player UI Plugin.


## Features
* Play (url / local file)
* Resume / pause

## Installation

First, add `audioplayerui` as a dependency in your `pubspec.yaml` file. 

Then add the AudioPlayerView like this 

```dart
  AudioPlayerController audioPlayerController = AudioPlayerController();

  @override
  Widget build(BuildContext context) {
    return AudioPlayerView(
              audioPlayerController: audioPlayerController,
              trackUrl: "",
              isLocal: false,
              trackTitle: "",
              trackSubtitle: "",
              imageUrl: ""
              );
  }
``` 

## Available methods for AudioPlayerController
| Method        | description           | parameters  | notes |
| ------------- |:-------------:| -----:|-----:|
| play      | Plays a audio file from an remote link | url ||
| playLocal      | Plays a local audio file |  path ||
| pause      | Pause's the currently playing track      |    ||
| resume |  Resumes the currently paused track      |     ||
| stop |  Stops the playback of the current track     |    ||

## Example

Demonstrates how to use the audioplayerui plugin.

See the [example documentation](example/README.md) for more information.

## Contributing

Feel free to contribute by opening issues and/or pull requests. Your feedback is very welcome!

## Changelog

See [CHANGELOG.md](CHANGELOG.md).

## License

MIT License

Copyright (c) [2019] [Joran Dob]
Copyright (c) [2019] [QREATE]


