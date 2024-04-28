import 'package:flutter/material.dart';
import 'package:pano1/constants.dart';
import 'package:pano1/ui/onboarding_screen.dart';
import 'package:pano1/scan_page.dart';
import 'package:pano1/ui/screens/Leaves Diseases/homeL.dart';


class SelectPage extends StatefulWidget {
  const SelectPage({Key? key}) : super(key: key);

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white.withOpacity(.6),
                    ),
                    child: Icon(Icons.arrow_back_outlined,color: Constants.primaryColor,),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeLeaves()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.6), // Change this value to adjust the opacity
                    minimumSize: const Size(200, 50), // Change these values to adjust the size
                  ),
                  child: const Text(
                    'LEAVES DISEASES',
                    style: TextStyle(
                      color: Color(0xff296e48),
                        fontSize: 20
                    ), ),
                ),
                const SizedBox(height: 40), // Change this value to adjust the space
                ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PanoramaScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.6), // Change this value to adjust the opacity
                    minimumSize: const Size(200, 50), // Change these values to adjust the size
                  ),
                  child: const Text(
                    'TUMOR DISEASES',
                    style: TextStyle(
                        color: Color(0xff296e48),
                        fontSize: 20
                    ),  // Change this value to adjust the font size
                  ),
                ),
              ],
            ),
          )

        ],
      ),

    );
  }
}
