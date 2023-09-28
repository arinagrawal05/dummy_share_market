// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:intl/intl.dart';

// class HAH extends StatefulWidget {
//   const HAH({Key? key, required this.title}) : super(key: key);
//   final String title;

//   @override
//   _HAHState createState() => _HAHState();
// }

// class _HAHState extends State<HAH> {
//   late List<SalesData> _chartData;
//   late TooltipBehavior _tooltipBehavior;

//   @override
//   void initState() {
//     _chartData = getChartData();
//     _tooltipBehavior = TooltipBehavior(enable: true);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//             body: Container(
//       height: 400,
//       child: SfCartesianChart(
//         title: ChartTitle(text: 'NESN Stock Analysis'),
//         legend: Legend(isVisible: true),
//         tooltipBehavior: _tooltipBehavior,
//         series: <ChartSeries>[
//           LineSeries<SalesData, double>(
//               name: 'Stocks',
//               dataSource: _chartData,
//               xValueMapper: (SalesData sales, _) => sales.year,
//               yValueMapper: (SalesData sales, _) => sales.sales,
//               dataLabelSettings: DataLabelSettings(isVisible: true),
//               enableTooltip: true)
//         ],
//         primaryXAxis: NumericAxis(
//           edgeLabelPlacement: EdgeLabelPlacement.shift,
//         ),
//         primaryYAxis: NumericAxis(
//             labelFormat: '{value}M',
//             numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0)),
//       ),
//     )));
//   }

//   List<SalesData> getChartData() {
//     final List<SalesData> chartData = [
//       SalesData(2017, 25),
//       SalesData(2018, 12),
//       // SalesData(2019, 24),
//       // SalesData(2020, 18),
//       // SalesData(2021, 29),
//       // SalesData(2022, 21)
//     ];
//     return chartData;
//   }
// }

// class SalesData {
//   SalesData(this.year, this.sales);
//   final double year;
//   final double sales;
// }
