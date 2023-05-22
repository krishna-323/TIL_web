import 'package:flutter/material.dart';
import 'package:new_project/utils/bar_chart_screen/lib/flutter.dart' as charts;
class SimpleBarChart extends StatefulWidget {
  final bool vertical;

  SimpleBarChart({required this.vertical});

  @override
  State<SimpleBarChart> createState() => _SimpleBarChartState();
}

class _SimpleBarChartState extends State<SimpleBarChart> {

  final List<OrdinalSales> data = [

  ];
  final uk_data = [

    OrdinalSales('2015', 30),
    OrdinalSales('2016', 58),
    OrdinalSales('2017', 40),
    OrdinalSales('2019', 50),
    OrdinalSales('2018', 80),
    OrdinalSales('2020', 90),
    OrdinalSales('2022', 20),
    OrdinalSales('2014', 35),

  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    data.add(OrdinalSales('2014', 35));
    data.add(OrdinalSales('2015', 25));
    data.add(OrdinalSales('2016', 100));
    data.add(OrdinalSales('2017', 75),);
    data.add(OrdinalSales('2018', 50),);
    data.add(OrdinalSales('2019', 30),);
    data.add(OrdinalSales('2020', 75),);
  }
  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    if (selectedDatum.isNotEmpty) {
      setState(() {
        print(selectedDatum.first.datum.sales);
        // We create the tooltip on the first use
        // var tooltip = SuperTooltip(
        //   popupDirection: TooltipDirection.left,
        //   content:  Material(
        //       child: Text(
        //         selectedDatum.first.datum.sales.toString(),
        //         softWrap: true,
        //       )),
        // );
        //
        // tooltip.show(context);

        // Tooltip(
        //   message: selectedDatum.first.datum.sales.toString(),
        //   triggerMode: TooltipTriggerMode.tap,
        //   child: Text(selectedDatum.first.datum.sales.toString(),
        //       style: TextStyle(
        //         fontWeight: FontWeight.w500,
        //         //fontSize: 1.7.t.toDouble(),
        //         color: Colors.black.withOpacity(0.6),
        //       )),
        // );
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(28.0),
      child: charts.BarChart(

        [
          charts.Series<OrdinalSales, String>(
            id: 'Sales',
            colorFn: (_, __) =>charts.ColorUtil.fromDartColor(const Color(0xff747AF2)),
            domainFn: (OrdinalSales sales, _) => sales.year,
            measureFn: (OrdinalSales sales, _) => sales.sales,
            data: data,

          ),
          charts.Series<OrdinalSales, String>(
            id: 'Sales1',
            colorFn: (_, __) => charts.ColorUtil.fromDartColor(const Color(0xffEF376E)),
            domainFn: (OrdinalSales sales, _) => sales.year,
            measureFn: (OrdinalSales sales, _) => sales.sales,
            data: uk_data,

          ),
        ],
        animate: true,
        vertical: widget.vertical,
        selectionModels: [
          charts.SelectionModelConfig(
            type: charts.SelectionModelType.info,
            changedListener: _onSelectionChanged,
          ),
        ],
      ),
    );
  }
}


class SimpleLineChart extends StatefulWidget {


  const SimpleLineChart();

  @override
  State<SimpleLineChart> createState() => _SimpleLineChartState();
}

class _SimpleLineChartState extends State<SimpleLineChart> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    seriesList.add(Data(DateTime(2020), int.parse("0")));
    seriesList.add(Data(DateTime(2021), int.parse("50")));
    seriesList.add(Data(DateTime(2022), int.parse("30")));
    seriesList.add(Data(DateTime(2023,), int.parse("20")));
    seriesList.add(Data(DateTime(2024,), int.parse("90")));
    //seriesList.add(Data(DateTime(2024, 05), int.parse("30")));
    seriesList2.add(Data(DateTime(2020), int.parse("0")));
    seriesList2.add(Data(DateTime(2021), int.parse("20")));
    seriesList2.add(Data(DateTime(2022), int.parse("50")));
    seriesList2.add(Data(DateTime(2023,), int.parse("30")));
    seriesList2.add(Data(DateTime(2024,), int.parse("70")));
  }
  // _onSelectionChanged(charts.SelectionModel model) {
  //   final selectedDatum = model.selectedDatum;
  //
  //   if (selectedDatum.isNotEmpty) {
  //     setState(() {
  //       print(selectedDatum.first.datum.sales);
  //       // We create the tooltip on the first use
  //       // var tooltip = SuperTooltip(
  //       //   popupDirection: TooltipDirection.left,
  //       //   content:  Material(
  //       //       child: Text(
  //       //         selectedDatum.first.datum.sales.toString(),
  //       //         softWrap: true,
  //       //       )),
  //       // );
  //       //
  //       // tooltip.show(context);
  //
  //       // Tooltip(
  //       //   message: selectedDatum.first.datum.sales.toString(),
  //       //   triggerMode: TooltipTriggerMode.tap,
  //       //   child: Text(selectedDatum.first.datum.sales.toString(),
  //       //       style: TextStyle(
  //       //         fontWeight: FontWeight.w500,
  //       //         //fontSize: 1.7.t.toDouble(),
  //       //         color: Colors.black.withOpacity(0.6),
  //       //       )),
  //       // );
  //     });
  //   }
  // }

  List<Data> seriesList = [];
  List<Data> seriesList2 = [];

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(28.0),
      child: charts.TimeSeriesChart(


        [
          charts.Series<Data, DateTime>(
            id: 'time',
            colorFn: (_, __) => charts.ColorUtil.fromDartColor(const Color(0xffFFCC00)),
            domainFn: (Data sales, _) => sales.time,
            measureFn: (Data sales, _) => sales.sales,
            data: seriesList,
          ),

          charts.Series<Data, DateTime>(
            id: 'time',
            domainFn: (Data sales, _) => sales.time,
            measureFn: (Data sales, _) => sales.sales,
            data: seriesList2,
          ),
        ],
        domainAxis: const charts.DateTimeAxisSpec(
          // tickProviderSpec: charts.StaticDateTimeTickProviderSpec(
          //   <charts.TickSpec<DateTime>>[
          //     charts.TickSpec<DateTime>(DateTime(2020, 3)),
          //     charts.TickSpec<DateTime>(DateTime(2020, 3)),
          //     charts.TickSpec<DateTime>(DateTime(2020, 3)),
          //     charts.TickSpec<DateTime>(DateTime(2020, 3)),
          //     charts.TickSpec<DateTime>(DateTime(2020, 3, 21)),
          //     charts.TickSpec<DateTime>(DateTime(2020, 3, 26)),
          //     charts.TickSpec<DateTime>(DateTime(2020, 4, 1)),
          //   ],
          // ),
          tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
            day: charts.TimeFormatterSpec(
              format: 'dd MMM',
              transitionFormat: 'dd MMM',
            ),
          ),
        ),
        animate: false,
        behaviors: [
          charts.SlidingViewport(),
          charts.PanAndZoomBehavior(),
        ],
        dateTimeFactory: const charts.LocalDateTimeFactory(),
        defaultRenderer: charts.LineRendererConfig(
          includePoints: true,
        ),
      ),
    );
  }
}

class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

class LineChartModel{
  final int year;
  final int sales;

  LineChartModel(this.year, this.sales);
}

class Data {
  final DateTime time;
  final int sales;

  Data(this.time, this.sales);
}