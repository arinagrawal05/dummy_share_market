import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_market_app/const.dart';
import 'package:share_market_app/functions.dart';

class MarketDataProvider extends ChangeNotifier {
  Map<String, int> stocksHoldingLiveList = {};
  List<String> mySharesList = [];
  int totalStockCount = 0;
  int currentBalance = 0;
  // getCounts() {
  //   stocksHoldingList = {};

  //   FirebaseFirestore.instance
  //       .collection("Booked_stocks")
  //       .where("user_id", isEqualTo: constuserid)
  //       .get()
  //       .then((value) => {
  //             totalStockCount = 0,
  //             for (int i = 0; i < value.docs.length; i++)
  //               {
  //                 stocksHoldingList.addAll({
  //                   value.docs[i]["stock_code"]: value.docs[i]["stock_qty"]
  //                 }),
  //                 totalStockCount += value.docs[i]["stock_qty"],
  //               },
  //           })
  //       .then((value) {
  //     print(stocksHoldingList.toString() + " called from provider");
  //     notifyListeners();
  //   });
  // }

  getMyShares() {
    print("listening portfolio");
    FirebaseFirestore.instance
        .collection("Booked_stocks")
        .where("user_id", isEqualTo: constuserid)
        .snapshots()
        .listen((event) {
      for (int i = 0; i < event.docs.length; i++) {
        mySharesList.add(event.docs[i]["stock_code"]);
      }
      print(mySharesList.toString() + " called from listen provider");

      notifyListeners();
    });

    // print("Rate updated to " + event["current_balance"].toString());
    print(currentBalance);
  }

  listenPortfolio() {
    print("listening portfolio");
    FirebaseFirestore.instance
        .collection("Booked_stocks")
        .where("user_id", isEqualTo: constuserid)
        .snapshots()
        .listen((event) {
      totalStockCount = 0;
      for (int i = 0; i < event.docs.length; i++) {
        stocksHoldingLiveList
            .addAll({event.docs[i]["stock_code"]: event.docs[i]["stock_qty"]});
        totalStockCount += int.parse(event.docs[i]["stock_qty"]);
      }
      print(stocksHoldingLiveList.toString() + " called from listen provider");
      print(totalStockCount.toString() + " called from listen provider");

      notifyListeners();
    });

    // print("Rate updated to " + event["current_balance"].toString());
    print(currentBalance);
  }

  listenBankBalance() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(constuserid)
        .snapshots()
        .listen((event) {
      currentBalance = event["current_balance"];
      notifyListeners();
      // print("Rate updated to " + event["current_balance"].toString());
      print(currentBalance);
    });
  }

  late QuerySnapshot allLiveStockPrices;
  listenStockPrices() {
    FirebaseFirestore.instance.collection("Stocks").snapshots().listen((event) {
      allLiveStockPrices = event;

      notifyListeners();
    });
  }

  makeAPurchase(String stockCode, int newStockQty, String stockId,
      int stockCurrentPrice, GlobalKey<ScaffoldState> scaffoldKey) {
    print("Making a purchase");
    int initalStocks = 0;

    if (currentBalance > (newStockQty * stockCurrentPrice)) {
      if (stocksHoldingLiveList.containsKey(stockCode)) {
        initalStocks = stocksHoldingLiveList[stockCode]!;
        print("initil stock is " + initalStocks.toString());
        FirebaseFirestore.instance
            .collection("Booked_stocks")
            .where("stock_code", isEqualTo: stockCode)
            .where("user_id", isEqualTo: constuserid)
            .get()
            .then((value) => {
                  if (value.docs.length == 1)
                    FirebaseFirestore.instance
                        .collection("Booked_stocks")
                        .doc(value.docs[0].id)
                        .update({"stock_qty": newStockQty + initalStocks})
                });
      } else {
        FirebaseFirestore.instance.collection("Booked_stocks").add({
          "stock_qty": newStockQty,
          "user_id": constuserid,
          "stock_code": stockCode,
          "stock_id":
              FirebaseFirestore.instance.collection("Stocks").doc(stockId),
        });
      }
      FirebaseFirestore.instance.collection('Users').doc(constuserid).update({
        "current_balance": currentBalance - (stockCurrentPrice * newStockQty)
      });

      FirebaseFirestore.instance.collection("Passbooks").add({
        "stock_qty": newStockQty,
        "stock_price": stockCurrentPrice,
        "user_id": constuserid,
        "transaction_type": buyingTerm,
        "stock_code": stockCode,
        "timestamp": DateTime.now(),
      }).then((value) {
        showSnackMessage("Purchase Successful", scaffoldKey);
      });
    } else {
      showSnackMessage("Not Enough Balance", scaffoldKey);
      print("Not Enough balance");
    }
    // check balance
  }

  makeASell(String stockCode, int newStockQty, String stockId,
      int stockCurrentPrice, GlobalKey<ScaffoldState> scaffoldKey) {
    print("Making a Selling");
    int initalStocks = 0;

    if (stocksHoldingLiveList.containsKey(stockCode)) {
      if (stocksHoldingLiveList[stockCode]! >= newStockQty) {
        if (stocksHoldingLiveList[stockCode] == newStockQty) {
          // delete query
          FirebaseFirestore.instance
              .collection("Booked_stocks")
              .where("stock_code", isEqualTo: stockCode)
              .where("user_id", isEqualTo: constuserid)
              .get()
              .then((value) => {
                    if (value.docs.length == 1)
                      FirebaseFirestore.instance
                          .collection("Booked_stocks")
                          .doc(value.docs[0].id)
                          .delete()
                  });
        } else {
          FirebaseFirestore.instance
              .collection("Booked_stocks")
              .where("stock_code", isEqualTo: stockCode)
              .where("user_id", isEqualTo: constuserid)
              .get()
              .then((value) => {
                    if (value.docs.length == 1)
                      FirebaseFirestore.instance
                          .collection("Booked_stocks")
                          .doc(value.docs[0].id)
                          .update({"stock_qty": initalStocks - newStockQty})
                  });
        }
        initalStocks = stocksHoldingLiveList[stockCode]!;
        print("initil stock is " + initalStocks.toString());
        FirebaseFirestore.instance.collection('Users').doc(constuserid).update({
          "current_balance": currentBalance + (stockCurrentPrice * newStockQty)
        });

        FirebaseFirestore.instance.collection("Passbooks").add({
          "stock_qty": newStockQty,
          "stock_price": stockCurrentPrice,
          "user_id": constuserid,
          "transaction_type": sellingTerm,
          "stock_code": stockCode,
          "timestamp": DateTime.now(),
        }).then((value) {
          showSnackMessage("Selling Successful", scaffoldKey);
        });
      } else {
        showSnackMessage("Not Enough Stocks", scaffoldKey);
      }
    } else {
      showSnackMessage("Not Enough Stocks", scaffoldKey);
    }

    // check balance
  }
}
