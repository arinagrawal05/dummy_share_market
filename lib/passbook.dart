import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_market_app/const.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:share_market_app/components.dart';

class PassbookScreen extends StatefulWidget {
  @override
  _PassbookScreenState createState() => _PassbookScreenState();
}

class _PassbookScreenState extends State<PassbookScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 200,
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 58),
            child: balanceWidget(context),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: subheading("Buying"),
              ),
              Tab(
                icon: subheading("Selling"),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: stream(buyingTerm),
            ),
            SingleChildScrollView(
              child: stream(sellingTerm),
            ),
          ],
        ),
      ),
    );
  }

  Widget transactionCard(String stockCode, int price, int stocks,
      String transactionType, Timestamp time, BuildContext context) {
    return Container(
      // height: 100,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(6)),
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 9),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Ionicons.wallet_outline,
              size: 40,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headings(
                      transactionType == sellingTerm
                          ? "sold " +
                              stocks.toString() +
                              " shares of \n" +
                              stockCode +
                              " @ " +
                              price.toString()
                          : "bought " +
                              stocks.toString() +
                              " shares of \n" +
                              stockCode +
                              " @ " +
                              price.toString(),
                      17),
                  subheading(
                      timeago.format(
                        time.toDate(),
                      ),
                      fontsize: 13)
                ],
              ),
              // Container(
              //     height: 25,
              //     width: 25,
              //     decoration: BoxDecoration(
              //         color: Theme.of(context).accentColor,
              //         borderRadius: BorderRadius.circular(7)),
              //     child: Center(
              //         child: subheading(stocks.toString(), fontsize: 17)))
            ],
          ),
          subheading(transactionType == sellingTerm
              ? "+" + (price * stocks).toString()
              : "-" + (price * stocks).toString())
          // Center(
          //   child: Icon(
          //     lastprice > currentPrice
          //         ? Ionicons.trending_down
          //         : Ionicons.trending_up,
          //     size: 65,
          //   ),
          // ),
          // headings(currentPrice.toString(), 17,
          //     color: lastprice > currentPrice ? Colors.red : Colors.green),
        ],
      ),
    );
  }

  Widget stream(String term) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Passbooks")
              .where("transaction_type", isEqualTo: term)
              .where("user_id", isEqualTo: constuserid)
              .orderBy("timestamp", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return gettingData("Passbooks");
            } else {
              return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return transactionCard(
                        snapshot.data!.docs[index]["stock_code"],
                        snapshot.data!.docs[index]["stock_price"],
                        snapshot.data!.docs[index]["stock_qty"],
                        snapshot.data!.docs[index]["transaction_type"],
                        snapshot.data!.docs[index]["timestamp"],
                        context);
                  });
            }
          }),
    );
  }
}
