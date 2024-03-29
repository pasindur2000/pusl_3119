import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pusl_3119/ui/screens/cart_page.dart';
import 'package:pusl_3119/ui/screens/diseases_page.dart';
import 'package:pusl_3119/ui/screens/home_page.dart';
import 'package:pusl_3119/ui/screens/profile_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pusl_3119/scan_page.dart';

import '../constants.dart';
import 'screens/signin_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _bottomNavIndex = 0;

  //List of the pages
  List<Widget> pages = const [
    HomePage(),
    DiseasesPage(),
    ProfilePage(),
    CartPage(),
  ];

  //List of the pages icons
  List<IconData> iconList = [
    Icons.home,
    Icons.shopping_cart,
    Icons.person,
    Icons.shopping_cart,
  ];

  //List of theh pages titles
  List<String> titleList = [
    'Home',
    'Diseases',
    'Profile',
    'Cart',
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(titleList[_bottomNavIndex], style: TextStyle(
              color: Constants.blackColor,
              fontWeight: FontWeight.w500,
              fontSize: 24,
            ),),
            Icon(Icons.notifications, color: Constants.blackColor, size: 30.0,)
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
      ),
      body: IndexedStack(
        index: _bottomNavIndex,
        children: pages,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, PageTransition(child: const ScanPage(), type: PageTransitionType.bottomToTop));
        },
        child: Image.asset('assets/images/2nd_icon.png', height: 38.0,),
        backgroundColor: Constants.primaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        splashColor: Constants.primaryColor,
        activeColor: Constants.primaryColor,
        inactiveColor: Colors.black.withOpacity(.5),
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        onTap: (index){
          setState(() {
            _bottomNavIndex = index;
          });
        },
      ),


    );
  }
}
