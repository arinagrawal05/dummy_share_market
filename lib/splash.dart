import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:share_market_app/bottom_nav.dart';
import 'package:share_market_app/colors.dart';
import 'package:share_market_app/components.dart';
import 'package:share_market_app/const.dart';
import 'package:share_market_app/functions.dart';
import 'package:share_market_app/provider/market_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with WidgetsBindingObserver {
  bool islogged = true;
  String userimg = constuserimg;
  String userid = constuserid;
  late bool private;
  String username = constusername;
  String name = constname;
  String weburl = constname;
  String bio = constbio;
  late String theme;
  @override
  void initState() {
    super.initState();
    // getPermissions();

    // getprefab();
    // setprefab();
    Provider.of<MarketDataProvider>(context, listen: false).listenBankBalance();
    Provider.of<MarketDataProvider>(context, listen: false).listenPortfolio();
    updateLastActive();
    Timer(
        Duration(seconds: 4),
        () => islogged == true
            ? navigatedirect(Bottomnavbar(), context)
            : navigatedirect(Bottomnavbar(), context));
  }

  @override
  // getPermissions() async {
  //   if (await Permission.contacts.request().isGranted) {
  //     // getAllContacts();
  //     // searchController.addListener(() {
  //     //   // filterContacts();
  //     // });
  //   }
  // }
  // setprefab() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool("isLogged", false).then((value) {
  //     print("Bool Set!");
  //   });
  // }

  getprefab() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      islogged = prefs.getBool("isLogged")!;
      name = prefs.getString("name")!;
      userimg = prefs.getString("userimg")!;
      username = prefs.getString("ThemeSettings")!;
      bio = prefs.getString("bio")!;

      theme = prefs.getString("ThemeSettings")!;

      print("theme is  " + theme.toString());
    });
    if (theme == null || theme == "light") {
      final provider = Provider.of<ThemeProvider>(context, listen: false);
      provider.toggleTheme(false);
    } else {
      final provider = Provider.of<ThemeProvider>(context, listen: false);
      provider.toggleTheme(true);
    }
  }

  setprefab() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userid == null ? prefs.setString("userid", constuserid) : print("userid");
      userimg == null
          ? prefs.setString("userimg", constuserimg)
          : print("userimg");
      name == null ? prefs.setString("name", constname) : print("name");
      username == null
          ? prefs.setString("username", constusername)
          : print("username");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.7,
        margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.15,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Container(
            //   height: 200,
            //   width: 200,
            //   margin: EdgeInsets.symmetric(
            //     horizontal: MediaQuery.of(context).size.width * 0.2,
            //   ),
            //   child: Image.network(     theme == "light"
            //           ? "https://i.pinimg.com/originals/c8/95/2d/c8952d6e421a83d298a219edee783167.jpg"
            //           : "https://nighteye.app/wp-content/uploads/2019/01/instagram-dark-mode-night-mode.jpg"),
            // ),
            Icon(
              Ionicons.shield_checkmark_outline,
              size: 200,
            ),
            Column(
              children: [
                headings("Grow Together", 40),
                subheading("Safe & Secure")
              ],
            ),
          ],
        ),
      ),
    );
  }
}
