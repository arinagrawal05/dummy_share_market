import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:share_market_app/add_stocks.dart';
import 'package:share_market_app/change_theme.dart';
import 'package:share_market_app/components.dart';
import 'package:share_market_app/const.dart';
import 'package:share_market_app/functions.dart';
import 'package:share_market_app/provider/market_data.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, int> stocksHolding = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // getMyPortfolio();
    // rateChangeScheduler();
  }

  Widget build(BuildContext context) {
    var provider = Provider.of<MarketDataProvider>(context, listen: true);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      print(provider.mySharesList);
                    },
                    child: CircleAvatar(
                      maxRadius: 35,
                      child: Image.network(
                        "https://cdn4.iconfinder.com/data/icons/users-14/128/Users_Circle_Man-512.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        headings(constname, 28),
                        subheading(
                            // "Current balance",
                            "joined in feburary",
                            fontsize: 13,
                            letterSpacing: 1.3)
                      ],
                    ),
                  ),
                ],
              ),
            ),

// stocksHolding.containsKey(sname)
//                         ? headings(stocksHolding[sname].toString(), 21)
//                         :headings("".toString(), 21)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                statsBox(provider.totalStockCount.toString(), "stocks"),
                statsBox("#4", "Rank"),
                statsBox(provider.currentBalance.toString(), "Balance"),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: headings("Your Portfolio", 24),
            ),
            provider.mySharesList.isEmpty
                ? Container()
                : Container(
                    height: 150,
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: provider.mySharesList.length,

                        // itemCount: 2,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 150,
                            child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("Stocks")
                                    .where("userid",
                                        isEqualTo: provider.mySharesList[index])
                                    // .where("userid".toString(), isEqualTo: "43351")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return gettingData("Stocks");
                                  } else {
                                    return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        // physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          return portBox(
                                              snapshot.data!.docs[index].id,
                                              snapshot.data!.docs[index]
                                                  ["stock_name"],
                                              snapshot.data!.docs[index]
                                                  ["stock_code"],
                                              snapshot.data!.docs[index]
                                                  ["last_rate"],
                                              snapshot.data!.docs[index]
                                                  ["current_rate"],
                                              snapshot.data!.docs[index]
                                                  ["past_rates"],
                                              context);
                                        });
                                  }
                                }),
                          );
                        })),

            Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Stocks")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return gettingData("your Portfolio");
                    } else {
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          // physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return portBox(
                                snapshot.data!.docs[index].id,
                                snapshot.data!.docs[index]["stock_name"],
                                snapshot.data!.docs[index]["stock_code"],
                                snapshot.data!.docs[index]["last_rate"],
                                snapshot.data!.docs[index]["current_rate"],
                                snapshot.data!.docs[index]["past_rates"],
                                context);
                          });
                    }
                  }),
            ),
            Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [],
                )),
            const Divider(),
            tile("Dark theme"),
            const Divider(),
          ],
        ),
      ),
    );
  }

  getMyPortfolio() {
    List locallist = [];
    var provider = Provider.of<MarketDataProvider>(context, listen: true);
    for (int i = 0; i < provider.stocksHoldingLiveList.length; i++) {
      locallist.addAll(provider.stocksHoldingLiveList.keys);
      // print(provider.stocksHoldingLiveList);
      // print(locallist);
    }
  }

  Widget portBox(String stockId, String stockName, String stockCode,
      int lastprice, int currentPrice, List pastRates, BuildContext context) {
    var provider = Provider.of<MarketDataProvider>(context, listen: true);

    return GestureDetector(
      onTap: () {
        navigateslide(
            AddStocks(
              stockCode: stockCode,
              stockPrice: currentPrice,
              stockLastPrice: lastprice,
              stockId: stockId,
              stockName: stockName,
              pastRates: pastRates,
            ),
            context);
      },
      child: Container(
        height: 100,
        width: 130,
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(9)),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 9),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                headings(stockCode, 17),
                Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(7)),
                    child: Center(
                        child: subheading(
                            provider.stocksHoldingLiveList[stockCode] == null
                                ? "0"
                                : provider.stocksHoldingLiveList[stockCode]
                                    .toString(),
                            fontsize: 17)))
              ],
            ),
            Center(
              child: Icon(
                lastprice > currentPrice
                    ? Ionicons.trending_down
                    : Ionicons.trending_up,
                size: 65,
              ),
            ),
            headings(currentPrice.toString(), 17,
                color: lastprice > currentPrice ? Colors.red : Colors.green),
          ],
        ),
      ),
    );
  }

  Widget statsBox(String title, String subtitle) {
    return Container(
      height: 85,
      width: 85,
      decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(9)),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 9),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 9),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [headings(title, 21), subheading(subtitle, fontsize: 14)],
      ),
    );
  }

  Widget tile(
    String title,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 9),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [subheading(title), ChangeThemeButtonWidget()],
      ),
    );
  }
}
