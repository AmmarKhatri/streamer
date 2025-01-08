import 'package:flutter/material.dart';

class WatcherPage extends StatelessWidget {
  const WatcherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watcher'),
      ),
      body: const Center(
        child: Text('Watcher Page - Waiting to connect to a stream.'),
      ),
    );
  }
}