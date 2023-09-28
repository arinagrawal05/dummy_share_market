import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ionicons/ionicons.dart';
import 'package:share_market_app/competition.dart';
import 'package:share_market_app/homepage.dart';
import 'package:share_market_app/passbook.dart';
import 'package:share_market_app/profile.dart';

class Bottomnavbar extends StatefulWidget {
  // final int index;
  // Bottomnavbar({this.index});

  @override
  _BottomnavbarState createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  late PageController controller;
  var currentPageValue = 0.0;

  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex = 0;
    controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          HomepageScreen(),
          PassbookScreen(),
          CompetitionScreen(),
          ProfileScreen(),

          //    MessMenuscreen(),
          // FoodHomeScreen(),

          //    ProfileScreen(),
        ],
        controller: controller,
        onPageChanged: (n) {
          setState(() {
            _selectedIndex = n;
          });
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            // color: Color.fromRGBO(70, 67, 211, 1),
            boxShadow: [
              BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
            ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
                color: Colors.white,
                gap: 8,
                activeColor: Colors.white,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                duration: Duration(milliseconds: 800),
                tabBackgroundColor: Color.fromRGBO(255, 255, 255, 0.2),
                tabs: const [
                  GButton(
                    icon: Ionicons.home,
                    text: 'Dashboard',
                  ),
                  GButton(
                    icon: Ionicons.book,
                    text: 'Passbook',
                  ),
                  GButton(
                    icon: Ionicons.people,
                    text: 'Competition',
                  ),
                  GButton(
                    icon: Icons.person,
                    text: 'Profile',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                    controller.jumpToPage(index);
                  });
                }),
          ),
        ),
      ),
    );
  }
}
