import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final picker = ImagePicker();
  List<File> _images = []; // List to store picked images
  bool showCaptureButton = true; // Flag to control capture button visibility

  Future<void> getImages() async {
    final result = await picker.pickMultiImage();
    if (result != null) {
      final imageFiles = result.map((x) => File(x.path)).toList();
      setState(() {
        _images.addAll(imageFiles);
        // Reset capture button visibility after selection
        showCaptureButton = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Page'),
      ),
      body: _images.isEmpty
          ? const Center(child: Text('No images selected'))
          : Column(
        children: [
          // Display selected images in a GridView
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two images per row
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) => Image.file(_images[index]),
            ),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Visibility( // Control capture button visibility
                visible: showCaptureButton,
                child: ElevatedButton.icon(
                  onPressed: getImages,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Capture Images'),
                ),
              ),
              ElevatedButton( // "Create" button is always visible
                onPressed: () {
                  // Handle "Create" button press (logic specific to your app)
                  print('Create button pressed!'); // Placeholder for now
                },
                child: const Text('Create'),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: showCaptureButton
          ? FloatingActionButton(
        onPressed: getImages,
        tooltip: 'Capture Images',
        child: const Icon(Icons.camera_alt),
      )
          : null, // Hide FAB after selection
    );
  }
}
