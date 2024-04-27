import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'model_page.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';


class ImagesStitch {
  final dynamicLibrary = Platform.isAndroid
      ? DynamicLibrary.open("libOpenCV_ffi.so")
      : DynamicLibrary.process();

  Future<void> stitchImages(
      final List<String> imagesPathToStitch,
      final String imagePathToCreate,
      final bool isVertical,
      final Function onCompleted) async {
    final stitchFunction = dynamicLibrary.lookupFunction<
        Void Function(Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>),
        void Function(Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>)>('stitch');
    stitchFunction(
      imagesPathToStitch.toString().toNativeUtf8(),
      imagePathToCreate.toNativeUtf8(),
      isVertical.toString().toNativeUtf8(),
    );
    onCompleted(imagePathToCreate);
  }
}

class PanoramaScreen extends StatefulWidget {
  const PanoramaScreen({Key? key}) : super(key: key);

  @override
  State<PanoramaScreen> createState() => _PanoramaScreenState();
}

class _PanoramaScreenState extends State<PanoramaScreen> {
  final _imagesStitch = ImagesStitch();
  final ImagePicker _picker = ImagePicker();
  String? _imagePathToShow = null;

  Future<void> _uploadImage() async{
    if(_imagePathToShow != null) {
      File file = File(_imagePathToShow!);
      try {
        // Initialize Firebase Storage with your bucket
        FirebaseStorage storage = FirebaseStorage.instanceFor(bucket: 'gs://disector-33450.appspot.com');

        // Create a reference to the location you want to upload to in Firebase Storage
        Reference storageReference = storage.ref('uploads/${basename(file.path)}');

        // Upload the file to Firebase Storage
        await storageReference.putFile(file);

        // Success!
        print('Image uploaded successfully');
      } catch (e) {
        // If any error occurs
        print(e);
      }
    }
  }

  Future<void> _pickImages() async {
    final imageFiles = await _picker.pickMultiImage();
    if (imageFiles != null) {
      final imagePaths = imageFiles.map((imageFile) => imageFile.path).toList();
      String dirPath =
          "${(await getApplicationDocumentsDirectory()).path}/${DateTime.now()}_.jpg";
      _imagesStitch.stitchImages(
          imagePaths, dirPath, false, (stitchedImagesPath) {
        setState(() {
          _imagePathToShow = dirPath;
        });
      });
    }
  }

  Future<void> _goNext() async {
    // Navigate to the ModelPage
    Navigator.push(
      context as BuildContext, // Pass the BuildContext from the current widget
      MaterialPageRoute(builder: (context) => ModelPage()),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panorama Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickImages,
              child: const Text('Select Images'),
            ),
            if (_imagePathToShow != null) Image.file(File(_imagePathToShow!)),
            ElevatedButton(
              onPressed: _uploadImage,
              child: const Text('Upload'),
            ),
            ElevatedButton(
              onPressed: _goNext,
              child: const Text('Next'),
            ),
          ],

        ),
      ),
    );
  }
}
