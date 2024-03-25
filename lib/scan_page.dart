import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

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

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final _imagesStitch = ImagesStitch();
  final ImagePicker _picker = ImagePicker();
  String? _imagePathToShow = null;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              InkWell(
                child: const Text('Click here'),
                onTap: () async {
                  final imageFiles = await _picker.pickMultiImage();
                  final imagePaths = imageFiles.map((imageFile) {
                    return imageFile.path;
                  }).toList();
                  String dirPath =
                      "${(await getApplicationDocumentsDirectory()).path}/${DateTime.now()}_.jpg";
                  _imagesStitch.stitchImages(
                    imagePaths,
                    dirPath,
                    false,
                        (stitchedImagesPath) {
                      setState(() {
                        _imagePathToShow = dirPath;
                      });
                    },
                  );
                },
              ),
              Image.file(File(_imagePathToShow ?? ""))
            ],
          ),
        ),
      ),
    );
  }
}
