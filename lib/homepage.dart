// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:share_market_app/add_stocks.dart';
import 'package:share_market_app/components.dart';
import 'package:share_market_app/const.dart';
import 'package:share_market_app/functions.dart';
import 'package:share_market_app/provider/market_data.dart';

class HomepageScreen extends StatefulWidget {
  @override
  _HomepageScreenState createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  Map<String, int> stocksHolding = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // rateChangeScheduler();
  }

  // getCounts() {
  //   FirebaseFirestore.instance
  //       .collection("Booked_stocks")
  //       .where("user_id", isEqualTo: constuserid)
  //       .get()
  //       .then((value) => {
  //             for (int i = 0; i < value.docs.length; i++)
  //               {
  //                 stocksHolding.addAll({
  //                   value.docs[i]["stock_code"]: value.docs[i]["stock_qty"]
  //                 }),
  //               },
  //           })
  //       .then((value) {
  //     print(stocksHolding.toString() + "  ffff");
  //   });
  // }

  //

  // rateChangeScheduler() {
  //   while (true) {
  //     print("changed again");
  //     Future.delayed(Duration(seconds: 10), () {
  //       rateChange();
  //     });
  //   }
  // }

  // ss() {
  //   print("ss called");
  //   Future.delayed(Duration(seconds: 10), () {
  //     rateChange();
  //     ss();
  //   });
  // }

  // final _debouncer = Debouncer(milliseconds: 4000);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MarketDataProvider>(context, listen: true);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headings("Welcome Back,", 16),
                        GestureDetector(
                            onTap: () {
                              // _debouncer.run(() {
                              rateChange();
                              print("Called");
                              // });
                              //  Provider.of<MarketDataProvider>(context,
                              //     listen: false).stocksHoldingLiveList[""]
                              // getCounts();

                              // String name;
                              // DocumentReference docRef;
                              // FirebaseFirestore.instance
                              //     .collection("Booked_stocks")
                              //     .doc("gqm6ZRRoqwGxdDz70g3w")
                              //     .get()
                              //     .then((value) => {
                              //           docRef = value["stock_id"],
                              //         });

                              // docRef.get().then((value) => {});
                            },
                            child: headings("$constname 🖐", 26, isbold: true))
                      ],
                    ),
                  ),
                  const CircleAvatar(
                    child: Icon(Ionicons.person),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: headings("Top Trending Stocks", 22, isbold: true),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Stocks")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return gettingData("Stocks");
                    } else {
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return stocktile(
                                snapshot.data!.docs[index]["stock_img"],
                                snapshot.data!.docs[index]["stock_code"],
                                snapshot.data!.docs[index]["stock_name"],
                                snapshot.data!.docs[index].id,
                                snapshot.data!.docs[index]["last_rate"],
                                snapshot.data!.docs[index]["current_rate"],
                                snapshot.data!.docs[index]["past_rates"],
                                context);
                          });
                    }
                  }),
            ),
            // stocktile(Ionicons.logo_apple, "AAPL", "apple inc.", 323.23),
            // stocktile(Ionicons.logo_apple, "AAPL", "apple inc.", 323.23),
            // stocktile(Ionicons.logo_apple, "AAPL", "apple inc.", 323.23),
            // stocktile(Ionicons.logo_apple, "AAPL", "apple inc.", 323.23),
          ],
        ),
      ),
    );
  }

  void rateChange() {
    int newPrice;

    List locallist = [];
    FirebaseFirestore.instance.collection("Stocks").get().then((stocksList) => {
          for (int i = 0; i < stocksList.size; i++)
            {
              newPrice = generateNewPrice(stocksList.docs[i]["current_rate"]),
              locallist = stocksList.docs[i]["past_rates"],
              if (locallist.length > 8)
                {
                  locallist.remove(locallist[0]),
                },
              locallist.add(newPrice),
              FirebaseFirestore.instance
                  .collection("Stocks")
                  .doc(stocksList.docs[i].id)
                  .update({
                "current_rate": newPrice,
                "last_rate": stocksList.docs[i]["current_rate"],
                "past_rates": locallist,
                "last_updated": DateTime.now()
              }).then((value) => {})
            },
          print("updated all")
        });
  }

  Widget stocktile(String icon, String sname, fname, stockid, int lastRate,
      int currentRate, List pastRates, BuildContext context) {
    var provider = Provider.of<MarketDataProvider>(context, listen: true);

    return GestureDetector(
      onTap: () {
        navigateslide(
            AddStocks(
              stockCode: sname,
              stockPrice: currentRate,
              stockLastPrice: lastRate,
              stockId: stockid,
              stockName: fname,
              pastRates: pastRates,
            ),
            context);
      },
      child: Stack(
        children: [
          provider.stocksHoldingLiveList[sname] != null
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 9),
                  margin: EdgeInsets.only(
                      top: 70, left: MediaQuery.of(context).size.width * 0.1),
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.circular(6)),
                  child: subheading(
                      "you own " +
                          provider.stocksHoldingLiveList[sname].toString(),
                      fontsize: 17),
                )
              : Container(),
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: BorderRadius.circular(10)),
                      height: 40,
                      width: 40,
                      child: Image.network(icon),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          headings(sname, 21, isbold: true),
                          headings(fname, 16)
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
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
                          },
                          child: headings(currentRate.toString(), 19)

                          // headings(currentRate.toString(), 21)
                          ),
                      headings(
                          nume(currentRate, lastRate).toInt().toString() + "%",
                          15,
                          color: nume(currentRate, lastRate) > 0
                              ? Colors.green
                              : Colors.red,
                          isbold: true)
                      // headings((currentRate - lastRate).toString(), 16,
                      //     color: Colors.red)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// stocksHolding.containsKey(sname)
//                         ? headings(stocksHolding[sname].toString(), 21)
//                         :headings("".toString(), 21)
  int generateNewPrice(int current) {
    var random = new Random();
    int varyPercent1 = random.nextInt(10);
    int varyPercent2 = random.nextInt(10);
    int diffPercent = varyPercent2 - varyPercent1;
    int ss = ((current * diffPercent * 2) / 100).toInt();
    int frate = current + ss;
    return frate;
  }

  double nume(int currentrate, int lastrate) {
    int diff = currentrate - lastrate;

    double percent = ((diff / currentrate) * 100);
    return percent;
  }
}
