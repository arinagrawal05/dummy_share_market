import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

String theme = "Light";

// gettheme() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();

//   theme = prefs.getString("theme");
//   print("value is" + theme.toString());
// }

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  ThemeMode getCurrentThemes() {
    return themeMode;
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    visualDensity: VisualDensity.comfortable,
    brightness: Brightness.dark,
    backgroundColor: const Color.fromRGBO(18, 18, 18, 1),

    bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color.fromRGBO(38, 38, 38, 1)),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color.fromRGBO(38, 38, 38, 1),
      contentTextStyle: GoogleFonts.montserrat(color: Colors.white),
    ),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      // titleTextStyle: GoogleFonts.roboto(
      //   fontWeight: FontWeight.w600,
      //   fontSize: 20,
      //   color: Colors.white,
      // ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      color: Colors.black,
    ),
    // navigationRailTheme: NavigationRailThemeData(backgroundColor: Colors.black),
    // bottomAppBarColor: Colors.black,
    // primarySwatch: Colors.black,
    // accentColor: const Color.fromRGBO(55, 55, 55, 1),
    canvasColor: const Color.fromRGBO(39, 39, 39, 1),
    scaffoldBackgroundColor: const Color.fromRGBO(18, 18, 18, 1),
    primaryColor: Colors.red,
    // cardTheme: CardTheme(
    //   clipBehavior: Clip.antiAliasWithSaveLayer,
    //   elevation: 2,
    //   color: Color.fromRGBO(39, 39, 39, 1),
    //   margin: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
    // ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.shifting,
      backgroundColor: Colors.black,
      selectedIconTheme: IconThemeData(color: Colors.white),
      unselectedIconTheme: IconThemeData(color: Colors.white),
    ),
    colorScheme: const ColorScheme.dark(),
  );

  static final lightTheme = ThemeData(
    canvasColor: const Color.fromRGBO(217, 217, 217, 1),
    bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.grey.shade200,
        modalBackgroundColor: Colors.grey.shade200),
    brightness: Brightness.light,
    backgroundColor: Colors.white,

    // accentColor: const Color.fromRGBO(200, 200, 200, 1),
    // bottomSheetTheme: BottomSheetThemeData(),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.grey.shade50,
      contentTextStyle: GoogleFonts.montserrat(color: Colors.white),
    ),
    primaryTextTheme: TextTheme(bodySmall: GoogleFonts.poppins()),
    // primarySwatch: Colors.grey.shade200,
    // buttonColor: Colors.yellow,

    appBarTheme: const AppBarTheme(
      elevation: 0,
      // textTheme: TextTheme(),
      // textTheme: GoogleFonts.roboto(
      //   fontWeight: FontWeight.w600,
      //   fontSize: 20,
      //   color: Colors.black,
      // ),

      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      color: Colors.white,
    ),
    iconTheme: const IconThemeData(color: Colors.white),

    bottomAppBarColor: Colors.white,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedIconTheme: IconThemeData(color: Colors.black),
        unselectedIconTheme: IconThemeData(color: Colors.black)),

    scaffoldBackgroundColor: const Color.fromRGBO(238, 238, 238, 1),
    primaryColor: Colors.white,

    colorScheme: const ColorScheme.light(),
    // iconTheme: IconThemeData(
    //   color: Colors.black,
    // ),
  );
}

class ColorPalatte {
  static Color themeColor = Colors.black;
  static Color textthemeColor = Colors.white;
  // static Color themeColor = theme == "Dark" ? Colors.black : Colors.white;
  // static Color textthemeColor = theme == "Dark" ? Colors.white : Colors.black;
  static Color themeshadeColor = const Color.fromRGBO(28, 28, 28, 1);

  //
}
