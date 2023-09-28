// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_market_app/functions.dart';
import 'package:share_market_app/passbook.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:share_market_app/components.dart';

class CompetitionScreen extends StatefulWidget {
  @override
  _CompetitionScreenState createState() => _CompetitionScreenState();
}

class _CompetitionScreenState extends State<CompetitionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 90,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: headings(" Competition", 22, isbold: true),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(9)),
                height: 37,
                child: TextField(
                  onTap: () {},
                  // scrollPadding: EdgeInsets.symmetric(vertical: 10),
                  // controller: _sea,
                  autofocus: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,

                    prefixIcon: const Icon(
                      Icons.search,
                      size: 26,
                      color: Colors.grey,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    hintText: "Search Player",
                    hintStyle: GoogleFonts.montserrat(
                        //  .withOpacity(0.12),
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                    // border:
                    // OutlineInputBorder(borderRadius: BorderRadius.circular(6))
                  ),

                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w400, fontSize: 17),
                ),
              )),
          Container(
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("Users").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                        // height: 600,
                        // child: Center(child: Customindicator()),
                        );
                  } else {
                    return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return playerTile(
                            snapshot.data!.docs[index]["userimg"],
                            snapshot.data!.docs[index]["name"],
                            snapshot.data!.docs[index]["last_active"],
                            snapshot.data!.docs[index]["current_balance"],
                          );
                        });
                  }
                }),
          ),
          Container(
              // width: 500,
              // height: 100,
              // color: Colors.red,
              // child: playerTile(
              //     "https://cdn.dribbble.com/users/247394/screenshots/17130376/media/384491630fda20c904b08af7dca4ccec.png",
              //     "Ayush Agrawal",
              //     DateTime.now(),
              //     36373),
              ),
          // playerTile(Ionicons.logo_apple, "AAPL", "apple inc.", 323.23),
          // playerTile(Ionicons.logo_apple, "AAPL", "apple inc.", 323.23),
          // playerTile(Ionicons.logo_apple, "AAPL", "apple inc.", 323.23),
        ],
      ),
    );
  }

  Widget playerTile(
      String icon, String name, Timestamp lastActive, int totalStocks) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(60)),
                    height: 40,
                    width: 40,
                    child: Image.network(
                      icon,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headings(name, 20, isbold: true),
                        headings(
                          "Last Active " +
                              timeago.format(
                                lastActive.toDate(),
                              ),
                          15,
                          color: Colors.grey.shade500,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.dollarSign,
                    size: 17,
                  ),
                  headings(totalStocks.toString(), 15),
                ],
              )
              // Container(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       GestureDetector(
              //         onTap: () {
              // var random = new Random();
              // int stockid = random.nextInt(1000000);
              // print(stockid);
              // FirebaseFirestore.instance
              //     .collection("Stocks")
              //     .doc(stockid.toString())
              //     .set({
              //   "stock_id": stockid.toString(),
              //   "stock_code": "MARUTI",
              //   "stock_img":
              //       "https://iconape.com/wp-content/png_logo_vector/maruti-suzuki-logo.png",
              //   "stock_name": "Maruti Suzuki India Ltd",
              //   "current_rate": 8556,
              //   "last_rate": 8336,
              //   "timestamp": DateTime.now(),
              // }).then((value) {
              //   print("Stock Done!");
              // });
              // },
              // child: headings(rateChange(currentRate).toString(), 21)

              // headings(currentRate.toString(), 21)
              // ),
              // headings(nume(currentRate, lastRate).toInt().toString(), 16,
              //     color: nume(currentRate, lastRate) > 0
              //         ? Colors.green
              //         : Colors.red,
              //     isbold: true)
              // headings((currentRate - lastRate).toString(), 16,
              //     color: Colors.red)
              // ],
              // ),
              // ),
              ,
            ],
          ),
          const Divider(
            endIndent: 10,
            indent: 10,
          ),
          InkWell(
            onTap: () {
              navigateslide(PassbookScreen(), context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                headings("View Portfolio", 15),
                const Icon(Ionicons.chevron_forward)
              ],
            ),
          )
        ],
      ),
    );
  }

  int rateChange(int current) {
    var random = new Random();
    int varyPercent1 = random.nextInt(10);
    int varyPercent2 = random.nextInt(10);
    int diffPercent = varyPercent2 - varyPercent1;
    int ss = ((current * diffPercent) / 100).toInt();
    int frate = current + ss;
    return frate;
  }

  double nume(int currentrate, int lastrate) {
    int diff = currentrate - lastrate;

    double percent = ((diff / currentrate) * 100);
    return percent;
  }
}
