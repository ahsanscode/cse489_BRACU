import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CSE489 Assignment 2',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

// HomeScreen with Drawer Menu
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Project - CSE489 Assignment 2'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: const Text('Menu', style: TextStyle(fontSize: 24, color: Colors.white)),
            ),
            ListTile(
              title: const Text('Broadcast Receiver'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BroadcastOptionScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Image Scale'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ImageScaleScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Video'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VideoScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Audio'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AudioScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Select an option from the drawer menu.'),
      ),
    );
  }
}

//
// Broadcast Receiver Flow
//

// Screen 1: Select Broadcast Type
class BroadcastOptionScreen extends StatefulWidget {
  const BroadcastOptionScreen({Key? key}) : super(key: key);
  @override
  _BroadcastOptionScreenState createState() => _BroadcastOptionScreenState();
}

class _BroadcastOptionScreenState extends State<BroadcastOptionScreen> {
  String? _selectedOption;
  final List<String> _options = [
    'Custom Broadcast Receiver',
    'System Battery Notification Receiver'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Broadcast Type')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              hint: const Text('Select an option'),
              value: _selectedOption,
              items: _options.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedOption = newValue;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedOption == null) return;
                if (_selectedOption == 'Custom Broadcast Receiver') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CustomInputScreen()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BroadcastResultScreen(option: _selectedOption!),
                    ),
                  );
                }
              },
              child: const Text('Proceed'),
            ),
          ],
        ),
      ),
    );
  }
}

// Screen 2: Custom Broadcast Receiver - User Input
class CustomInputScreen extends StatefulWidget {
  const CustomInputScreen({Key? key}) : super(key: key);
  @override
  _CustomInputScreenState createState() => _CustomInputScreenState();
}

class _CustomInputScreenState extends State<CustomInputScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Message')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter text for custom broadcast',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String message = _controller.text;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BroadcastResultScreen(
                      option: 'Custom Broadcast Receiver',
                      message: message,
                    ),
                  ),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

// Screen 3: Display Broadcast Result
class BroadcastResultScreen extends StatelessWidget {
  final String option;
  final String? message;
  const BroadcastResultScreen({Key? key, required this.option, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String displayText = option == 'Custom Broadcast Receiver'
        ? 'Broadcast received message: $message'
        : 'Battery percentage: 85%';
    return Scaffold(
      appBar: AppBar(title: const Text('Broadcast Result')),
      body: Center(
        child: Text(
          displayText,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

//
// Image Scale Screen
//
class ImageScaleScreen extends StatelessWidget {
  const ImageScaleScreen({Key? key}) : super(key: key);
  final String imageUrl = 'https://via.placeholder.com/300';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Scale')),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}

//
// Video Playback Simulation Screen
//
class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  bool isPlaying = false;

  void togglePlay() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Player (Simulation)')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.black12,
              width: 300,
              height: 200,
              alignment: Alignment.center,
              child: Text(
                isPlaying ? 'Playing Video...' : 'Video Stopped',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: togglePlay,
              child: Text(isPlaying ? 'Pause' : 'Play'),
            ),
          ],
        ),
      ),
    );
  }
}

//
// Audio Playback Simulation Screen
//
class AudioScreen extends StatefulWidget {
  const AudioScreen({Key? key}) : super(key: key);
  @override
  _AudioScreenState createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  bool isPlaying = false;

  void toggleAudio() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void stopAudio() {
    setState(() {
      isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audio Player (Simulation)')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.blueGrey[50],
              width: 300,
              height: 100,
              alignment: Alignment.center,
              child: Text(
                isPlaying ? 'Audio Playing...' : 'Audio Stopped',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: toggleAudio,
                  child: Text(isPlaying ? 'Pause' : 'Play'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: stopAudio,
                  child: const Text('Stop'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
