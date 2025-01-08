import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:video_player/video_player.dart';
import 'dart:math';

class StreamerPage extends StatefulWidget {
  const StreamerPage({super.key});

  @override
  _StreamerPageState createState() => _StreamerPageState();
}

class _StreamerPageState extends State<StreamerPage> {
  File? selectedFile;
  VideoPlayerController? videoController;
  RTCPeerConnection? peerConnection;
  RTCDataChannel? dataChannel;
  String sessionId = '';

  @override
  void initState() {
    super.initState();
    generateSessionId();
  }

  // Generate a unique session ID
  void generateSessionId() {
    sessionId = Random().nextInt(999999).toString().padLeft(6, '0'); // e.g., 123456
    setState(() {});
  }

  // Pick a media file
  Future<void> pickMediaFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      selectedFile = File(result.files.single.path!);
      initializeVideoPlayer();
    }
  }

  // Initialize the video player
  void initializeVideoPlayer() {
    if (selectedFile != null) {
      videoController = VideoPlayerController.file(selectedFile!)
        ..initialize().then((_) {
          setState(() {});
          videoController!.play(); // Auto-play after initialization
        });
    }
  }

  // Set up WebRTC
  Future<void> setupWebRTC() async {
    final configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    };

    peerConnection = await createPeerConnection(configuration);

    dataChannel = await peerConnection!.createDataChannel(
      'playbackSync',
      RTCDataChannelInit(),
    );

    // Handle incoming connections
    dataChannel!.onMessage = (RTCDataChannelMessage message) {
      final data = message.text; // Parse commands like "play", "pause", etc.
      handleControlMessage(data);
    };

    setState(() {});
  }

  // Handle playback control messages
  void handleControlMessage(String message) {
    if (message == 'play') {
      videoController?.play();
    } else if (message == 'pause') {
      videoController?.pause();
    } else if (message.startsWith('seek:')) {
      final position = double.parse(message.split(':')[1]);
      videoController?.seekTo(Duration(seconds: position.toInt()));
    }
  }

  // Share the session link
  void shareSessionLink() {
  final link = "teleparty://stream/$sessionId";

  // Copy to clipboard
  Clipboard.setData(ClipboardData(text: link));

  // Notify the user
  debugPrint("Share this link with your watcher: $link");
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Link copied to clipboard: $link")),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Streamer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selectedFile != null)
              SizedBox(
                width: 300,
                height: 200,
                child: videoController != null && videoController!.value.isInitialized
                    ? VideoPlayer(videoController!)
                    : const CircularProgressIndicator(),
              ),
            if (selectedFile == null)
              ElevatedButton(
                onPressed: pickMediaFile,
                child: const Text('Pick a Media File'),
              ),
            if (selectedFile != null)
              ElevatedButton(
                onPressed: shareSessionLink,
                child: const Text('Share Session Link'),
              ),
            if (peerConnection == null)
              ElevatedButton(
                onPressed: setupWebRTC,
                child: const Text('Start WebRTC Session'),
              ),
          ],
        ),
      ),
    );
  }
}
