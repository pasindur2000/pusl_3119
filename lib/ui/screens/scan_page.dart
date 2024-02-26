import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFileList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Page'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(), // Add any content you want above the button here
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: OutlinedButton(
                  onPressed: () {},
                  child: Text("Select Images"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
