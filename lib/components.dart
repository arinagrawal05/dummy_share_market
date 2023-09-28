import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_market_app/const.dart';
import 'package:share_market_app/provider/market_data.dart';

Widget headings(String text, double size,
    {Color color = Colors.white, bool isbold = true}) {
  return Text(text,
      style: GoogleFonts.poppins(
          color: color,
          fontSize: size,
          fontWeight: isbold ? FontWeight.w500 : FontWeight.w200));
}

Widget subheading(String text,
    {Color color = Colors.white,
    bool isbold = false,
    double fontsize = 19,
    double letterSpacing = 1}) {
  return Text(text,
      style: GoogleFonts.poppins(
          letterSpacing: letterSpacing,
          color: color,
          fontSize: fontsize,
          fontWeight: isbold ? FontWeight.w500 : FontWeight.w200));
}

Widget gettingData(String text) {
  return Container(
    height: 300,
    child: Center(
      child: subheading(
        "Getting " + text,
      ),
    ),
  );
}

Widget balanceWidget(BuildContext context) {
  var provider = Provider.of<MarketDataProvider>(context, listen: true);

  return Padding(
    padding: const EdgeInsets.all(22.0),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(FontAwesomeIcons.dollarSign),
            headings(
              provider.currentBalance.toString(),
              28,
            ),
          ],
        ),
        subheading(
            // "Current balance",
            "CURRENT BALANCE",
            fontsize: 14,
            letterSpacing: 1.5)
      ],
    ),
  );
}
