import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_market_app/colors.dart';
import 'package:share_market_app/provider/market_data.dart';
import 'package:share_market_app/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => ThemeProvider(),
            ),
            ChangeNotifierProvider(
              create: (context) => MarketDataProvider(),
            )
          ],
          builder: (context, _) {
            final themeProvider = Provider.of<ThemeProvider>(context);
            return MaterialApp(
              title: 'Share Market',
              themeMode: themeProvider.themeMode,
              theme: MyThemes.lightTheme,
              darkTheme: MyThemes.darkTheme,
              home: Splashscreen(),
              debugShowCheckedModeBanner: false,

              // theme: ThemeData(
              //   primarySwatch: Colors.blue,
              //   visualDensity: VisualDensity.adaptivePlatformDensity,
              // ),
            );

            // ChangeNotifierProvider(
            //     create: (context) => ThemeProvider(),
            //     builder:
          });
}
