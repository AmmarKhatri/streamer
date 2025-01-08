import 'package:flutter/material.dart';
import 'package:streamer/streamer/streamer_page.dart';
import 'package:streamer/watcher/watcher_page.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teleparty App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StreamerPage()),
              ),
              child: const Text('Be the Streamer'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WatcherPage()),
              ),
              child: const Text('Be the Watcher'),
            ),
          ],
        ),
      ),
    );
  }
}
