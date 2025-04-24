import 'package:ecommerce/features/admin/screens/dashboard/widgets/block_simple.dart';
import 'package:ecommerce/features/admin/screens/dashboard/widgets/header.dart';
import 'package:ecommerce/features/admin/screens/dashboard/widgets/indicator.dart';
import 'package:ecommerce/utils/formatters/formatter.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<String> list = <String>['This Year', 'This month', 'This week', 'Custom'];
  late String dropdownValue;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  // For graph line:
  final bool isShowingMainData = true;

  // For bar graph:
  int touchedIndex = -1;

  void updateStartDate (DateTime newValue) {
    setState(() {
      startDate = newValue;
    });
  }

  void updateEndDate (DateTime newValue) {
    setState(() {
      endDate = newValue;
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2021, 7, 25),
      firstDate: DateTime(2021),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          updateStartDate(pickedDate);
        } else {
          updateEndDate(pickedDate);
        }
      });
  }
  }

  @override
  void initState() {
    dropdownValue = list[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(10),
        child: Column(
          spacing: 20,
          children: [
            // Header:
            Header(),
            Divider(),

            // Main board
            // 1. Filter row:
            Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 160,
                  child: DropdownButtonFormField<String>(
                    value: dropdownValue,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                       
                    ),
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 16,
                    
                    style: const TextStyle(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(10),
                    // padding: EdgeInsets.all(5),
                    onChanged: (value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    items:
                        list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(value: value, child: Text(value));
                        }).toList(),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      side: BorderSide(color: Colors.white)
                    ),
                    onPressed: ()=> _selectDate(context, true), 
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(CFormatter.formatDate(startDate)),
                        Icon(Icons.date_range)
                      ],
                    )
                  ),
                ),
                Text('-'),
                SizedBox(
                  width: 150,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      side: BorderSide(color: Colors.white)
                    ),
                    onPressed: ()=> _selectDate(context, false), 
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(CFormatter.formatDate(endDate)),
                        Icon(Icons.date_range)
                      ],
                    )
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    side: BorderSide(color: Colors.white)
                  ),
                  onPressed: (){}, 
                  child: Text('Apply filter')
                )
              ],
            ),

            // 2. Simple dashboard wrap
            Wrap(
              direction: Axis.horizontal,
              runSpacing: 10,
              spacing: 10,
              children: [
                CBlockSimple(title: 'Total users',description: 250),
                CBlockSimple(title: 'Total orders',description: 10),
                CBlockSimple(title: 'Total revenues',description: 880000, isMoney: true,),
                CBlockSimple(title: 'Overall profit',description: 250000, isMoney: true, isProfit: true,)
              ],
            ),

            // 3. Advanced dashboard: 1 pie graph, 1 line graph + bar graph
            // ----- Line graph:
            Wrap(
              direction: Axis.horizontal,
              spacing: 10,
              runSpacing: 10,
              children: [

                // Line graph:
                SizedBox(
                  // color: Colors.blueGrey[900],
                  height: 450,
                  width: 500,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 400,
                        child: LineChart(
                          sampleData1,
                          duration: const Duration(milliseconds: 250),
                        ),
                      ),
                      buildLegend(),
                      Text('Revenue chart', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),


                // Pie chart:
                Container(
                  margin: EdgeInsets.all(10),
                  width: 400,
                  height: 400,
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 1.3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(
                              height: 18,
                            ),
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: PieChart(
                                  PieChartData(
                                    pieTouchData: PieTouchData(
                                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                        setState(() {
                                          if (!event.isInterestedForInteractions ||
                                              pieTouchResponse == null ||
                                              pieTouchResponse.touchedSection == null) {
                                            touchedIndex = -1;
                                            return;
                                          }
                                          touchedIndex = pieTouchResponse
                                              .touchedSection!.touchedSectionIndex;
                                        });
                                      },
                                    ),
                                    borderData: FlBorderData(
                                      show: false,
                                    ),
                                    sectionsSpace: 0,
                                    centerSpaceRadius: 40,
                                    sections: showingSections(),
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Indicator(
                                  color: Colors.blueAccent,
                                  text: 'First',
                                  isSquare: true,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Indicator(
                                  color: Colors.yellowAccent,
                                  text: 'Second',
                                  isSquare: true,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Indicator(
                                  color: Colors.purpleAccent,
                                  text: 'Third',
                                  isSquare: true,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Indicator(
                                  color: Colors.green,
                                  text: 'Fourth',
                                  isSquare: true,
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 28,
                            ),
                          ],
                        ),
                      ),
                      Text('Products', style: TextStyle(fontSize: 20),)
                    ],
                  )
                ),

                
              ]
            ),

            // Table data of products sold:
            Padding(
              padding: EdgeInsets.all(15),
              child: Table(
                border: TableBorder.all(color: Colors.white30),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  const TableRow(
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                    ),
                    children: [
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Title 1'),
                        ),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Title 2'),
                        ),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Title 3'),
                        ),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Title 4'),
                        ),
                      ),
                    ]
                  ),
                  // Data display here:
                  ...List.generate(
                    20, 
                    (index) => const TableRow(
                      children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Cell1'),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Cell2'),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Cell3'),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Cell4'),
                          ),
                        ),
                      ]
                    )
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Hàm tạo chú thích:
  Widget buildLegend() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 20,
        height: 20,
        color: Colors.purpleAccent,
      ),
      const SizedBox(width: 5),
      const Text('Total profit', style: TextStyle(color: Colors.white)),
      const SizedBox(width: 20),
      Container(
        width: 20,
        height: 20,
        color: Colors.green,
      ),
      const SizedBox(width: 5),
      const Text('Total Revenue', style: TextStyle(color: Colors.white)),
    ],
  );
}

  // My line chart:
  LineChartData get sampleData1 => LineChartData(
    gridData: gridData,
    titlesData: titlesData,
    borderData: borderData,
    lineBarsData: lineBarsData,
    minX: 0,
    maxX: 14,
    minY: 0,
    maxY: 4,
  );

  List<LineChartBarData> get lineBarsData => [
    lineChartBarData1,
    lineChartBarData2
  ];

  FlTitlesData get titlesData => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles,
    ),
    rightTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitle()
    )
  );

  Widget leftTitleWidget(double value, TitleMeta meta){
    const style = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1m';
        break;
      case 2:
        text = '2m';
        break;
      case 3:
        text = '3m';
        break;
      case 4:
        text = '4m';
        break;
      case 5:
        text = '5m';
        break;
      default:
        return Container();
    }
    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitle() => SideTitles(
    getTitlesWidget: leftTitleWidget,
    showTitles: true,
    interval: 1,
    reservedSize: 40
  );

  Widget bottomTitleWidgets (double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
    );
    Widget text;
    switch (value.toInt()) {
      case 2: 
        text = const Text('2020', style: style);
        break;
      case 7: 
        text = const Text('2021', style: style);
        break;
      case 12: 
        text = const Text('2022', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      meta: meta,
      space: 10,
      child: text
    );
  }

  SideTitles get bottomTitles => SideTitles(
    showTitles: true, 
    reservedSize: 32,
    interval: 1,
    getTitlesWidget: bottomTitleWidgets
  );

  FlGridData get gridData => FlGridData(
    show: true,
  );

  FlBorderData get borderData => FlBorderData(
    show: true,
    border: Border(
      bottom: BorderSide(color: Colors.grey, width:  4),
      left: const BorderSide(color: Colors.grey),
      right: const BorderSide(color: Colors.transparent),
      top: const BorderSide(color: Colors.transparent),
    )
  );

  LineChartBarData get lineChartBarData1 => LineChartBarData(
    isCurved: true,
    color: Colors.purpleAccent,
    barWidth: 6,
    isStrokeCapRound: false,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: const [
      FlSpot(1, 1),
      FlSpot(3, 1.5),
      FlSpot(5, 1.6),
      FlSpot(7, 3.4),
      FlSpot(10, 2),
      FlSpot(12, 2.5),
      FlSpot(13, 1.6),
    ]
  );

  LineChartBarData get lineChartBarData2 => LineChartBarData(
    isCurved: true,
    color: Colors.green,
    barWidth: 6,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: const [
      FlSpot(1, 2),
      FlSpot(3, 1),
      FlSpot(5, 3),
      FlSpot(7, 3.4),
      FlSpot(10, 2.3),
      FlSpot(12, 2.9),
      FlSpot(13, 3),
    ]
  );

  // ------------------ For bar graph:
  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.yellowAccent,
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.purpleAccent,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.greenAccent,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}