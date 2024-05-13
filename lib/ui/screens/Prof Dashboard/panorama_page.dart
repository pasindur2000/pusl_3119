
import 'package:flutter/material.dart';
import 'package:pano1/ui/screens/Prof%20Dashboard/prof_3dmodel.dart';

class ViewPano extends StatefulWidget {
  final String panolink;
  const ViewPano({Key? key, required this.panolink}) : super(key: key);

  @override
  State<ViewPano> createState() => _ViewPanoState();
}

class _ViewPanoState extends State<ViewPano> {
 late String newpano;
  @override
  void initState() {
    super.initState();
    newpano = widget.panolink;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'View Panorama',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bgr.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Display the panorama image
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(newpano),

                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
