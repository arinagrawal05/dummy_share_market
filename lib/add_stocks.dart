import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:share_market_app/components.dart';
import 'package:share_market_app/functions.dart';
import 'package:share_market_app/passbook.dart';
import 'package:share_market_app/provider/market_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

class AddStocks extends StatefulWidget {
  String stockCode, stockName, stockId;
  int stockPrice, stockLastPrice;
  List pastRates;

  AddStocks(
      {required this.stockCode,
      required this.stockPrice,
      required this.stockName,
      required this.stockId,
      required this.stockLastPrice,
      required this.pastRates});

  @override
  _AddStocksState createState() => _AddStocksState();
}

class _AddStocksState extends State<AddStocks> {
  String setStocked = "";
  late List<SalesData> _chartData;
  // late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _chartData = getChartData();
    // _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _qtyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MarketDataProvider>(context, listen: true);
    return SafeArea(
        child: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: subheading(
                widget.stockName.toString(),
              ),
              centerTitle: true,
              actions: [
                GestureDetector(
                  onTap: () {
                    navigateslide(PassbookScreen(), context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.dollarSign,
                          size: 19,
                        ),
                        headings(provider.currentBalance.toString(), 22),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
                child: Column(
              children: [
                analysisChart(
                    widget.stockPrice < widget.stockLastPrice ? true : false),
                headings(widget.stockPrice.toString(), 22),

                subheading(
                    provider.stocksHoldingLiveList
                                .containsKey(widget.stockCode) ==
                            false
                        ? "0 Stocks Owned"
                        : provider.stocksHoldingLiveList[widget.stockCode]
                                .toString() +
                            " Stocks Owned",
                    fontsize: 18),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        setStocked = value;
                      });
                    },
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 6),
                        border: InputBorder.none,
                        hintStyle: GoogleFonts.poppins(),
                        hintText: 'Quantity'),
                    keyboardType: TextInputType.number,
                    controller: _qtyController,
                  ),
                ),
                _qtyController.text != ""
                    ? headings(
                        (int.parse(setStocked) * widget.stockPrice).toString(),
                        22)
                    : Container(),
                // Spacer(),
                const SizedBox(
                  height: 110,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      button("Buy", () {
                        print("object" + (_qtyController.text).toString());
                        if (_qtyController.text == "") {
                          showSnackMessage(
                              "Quantity Can't be empty", scaffoldKey);
                        } else {
                          provider.makeAPurchase(
                              widget.stockCode,
                              int.parse(_qtyController.text),
                              widget.stockId,
                              widget.stockPrice,
                              scaffoldKey);
                        }
                      }),
                      button("Sell", () {
                        if (_qtyController.text == "") {
                          showSnackMessage(
                              "Quantity Can't be empty", scaffoldKey);
                        } else {
                          provider.makeASell(
                              widget.stockCode,
                              int.parse(_qtyController.text),
                              widget.stockId,
                              widget.stockPrice,
                              scaffoldKey);
                        }
                      })
                    ],
                  ),
                ),
              ],
            ))));
  }

  Widget button(String title, ontap) {
    return InkWell(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Theme.of(context).canvasColor,
        ),
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 42),
        // height: 100,
        // width: 100,
        child: Row(
          children: [
            subheading(title + "  ", fontsize: 22),
            const Icon(Ionicons.trending_up)
          ],
        ),
      ),
    );
  }

  List<SalesData> getChartData() {
    final List<SalesData> chartData = [];
    for (int i = 0; i < widget.pastRates.length; i++) {
      chartData.add(SalesData(
          (DateTime.now().minute - i).toDouble(),
          // widget.pastRates[widget.pastRates.length - i].toDouble()));
          widget.pastRates[i].toDouble()));

      // SalesData(DateTime.now().minute - 2).toDouble(),widget.pastRates[i]),
      // SalesData((DateTime.now().minute - 2).toDouble(),
      //     widget.stockLastPrice.toDouble()),
      // SalesData(
      //     DateTime.now().minute.toDouble(), widget.stockPrice.toDouble()),
    }
    // SalesData(2019, 24),
    // SalesData(2020, 18),
    // SalesData(2021, 29),
    // SalesData(2022, 21)
    return chartData;
  }

  Widget analysisChart(bool isLoss) {
    TooltipBehavior tooltipBehavior = TooltipBehavior();
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 385,
      child: SfCartesianChart(
        title: ChartTitle(text: widget.stockCode + ' Stock Analysis'),
        legend: Legend(isVisible: true),
        tooltipBehavior: tooltipBehavior,
        series: <ChartSeries>[
          LineSeries<SalesData, double>(
              name: 'Stocks',
              dataSource: _chartData,
              xValueMapper: (SalesData sales, _) => sales.year,
              yValueMapper: (SalesData sales, _) => sales.sales,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              enableTooltip: true,
              color: isLoss ? Colors.red : Colors.green)
        ],

        // plotAreaBackgroundColor: Colors.cyan,
        primaryXAxis: NumericAxis(
          isInversed: true,
          labelFormat: '{value}',
          interval: 1,
          edgeLabelPlacement: EdgeLabelPlacement.shift,
        ),
        primaryYAxis: NumericAxis(
          labelFormat: '{value}',
          //  numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0)
        ),
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final double year;
  final double sales;
}
