import 'package:ecommerce/features/admin/screens/dashboard/widgets/block_simple.dart';
import 'package:ecommerce/features/admin/screens/dashboard/widgets/indicator.dart';
import 'package:ecommerce/features/admin/screens/userManagement/widgets/paginated_table.dart';
import 'package:ecommerce/features/auth/controllers/order_controller_admin.dart';
import 'package:ecommerce/features/auth/controllers/product_controller.dart';
import 'package:ecommerce/features/auth/controllers/user_controller.dart';
import 'package:ecommerce/utils/formatters/formatter.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<String> list = <String>['This Year', 'This Month', 'This Week', 'Custom'];
  late String dropdownValue;
  List<dynamic> orders = [];
  List<dynamic> users = [];
  List<dynamic> products = [];
  bool isLoading = true;
  

  late DateTime startDate;
  late DateTime endDate;

  // For graph line:
  final bool isShowingMainData = true;

  // For bar graph:
  int touchedIndex = -1;
  final DataTableSource _data = MyData();
  final OrderAdminController orderAdminController = OrderAdminController();
  final UserAdminController userAdminController = UserAdminController();
  final ProductController productController = ProductController();


  Future<void> _fetchData() async {
    try {
      // final fetchedOrders = await orderAdminController.getOrders();
      // setState(() {
      //   orders = fetchedOrders['data'];
      //   // _filteredOrders = fetchedOrders;
      //   isLoading = false;
      // });
      final results = await Future.wait([
        orderAdminController.getOrders(),
        userAdminController.getUsers(),
        productController.getProducts(),
      ]);

      final fetchedOrders = results[0];
      final fetchedUsers = results[1];
      final fetchedProducts = results[2];

      setState(() {
        orders = fetchedOrders['data'];
        users = fetchedUsers['data'];
        products = fetchedProducts['data'];
        isLoading = false;
      });
    } catch (e) {
      print('Lỗi khi fetch orders: $e');
    }
    finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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

  void _updateDateRange(String selected) {
    final now = DateTime.now();
    DateTime start, end;

    switch (selected) {
      case 'This Year':
        start = DateTime(now.year, 1, 1);
        end = DateTime(now.year, 12, 31, 23, 59, 59, 999);
        break;
      case 'This Month':
        start = DateTime(now.year, now.month, 1);
        final lastDay = DateTime(now.year, now.month + 1, 0).day;
        end = DateTime(now.year, now.month, lastDay, 23, 59, 59, 999);
        break;
      case 'This Week':
        final weekday = now.weekday; // 1 = Mon, ..., 7 = Sun
        start = now.subtract(Duration(days: weekday - 1));
        end = start.add(const Duration(days: 6));
        end = DateTime(end.year, end.month, end.day, 23, 59, 59, 999);
        break;
      case 'Custom':
        return; // không chỉnh range ở đây
      default:
        return;
    }

    setState(() {
      startDate = start;
      endDate = end;
    });
  }


  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2025,5,7),
      firstDate: DateTime(2024),
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
    final now = DateTime.now();
    startDate = DateTime(now.year, 1, 1);
    endDate = DateTime(now.year, 12, 31, 23, 59, 59, 999);
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading 
    ? Center(child: CircularProgressIndicator(),)
    : Column(
      spacing: 20,
      children: [
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
                onChanged: (value) {
                  setState(() {
                    dropdownValue = value!;
                    if (value != 'Custom') {
                      _updateDateRange(value);
                    }
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
                onPressed: (dropdownValue == 'Custom') ? () => _selectDate(context, true) : null,
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
                onPressed: (dropdownValue == 'Custom') ? () => _selectDate(context, false) : null, 
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
            CBlockSimple(title: 'Total users',description: double.parse(users.length.toString())),
            CBlockSimple(title: 'Total orders',description: double.parse(orders.length.toString())),
            CBlockSimple(title: 'Total revenues',description: 88000000, isMoney: true,),
            CBlockSimple(title: 'Overall profit',description: 25000000, isMoney: true, isProfit: true,)
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
                              text: 'Laptop',
                              isSquare: true,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Indicator(
                              color: Colors.yellowAccent,
                              text: 'RAM',
                              isSquare: true,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Indicator(
                              color: Colors.purpleAccent,
                              text: 'CPU',
                              isSquare: true,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Indicator(
                              color: Colors.green,
                              text: 'Motherboard',
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
        
        Padding(
          padding: EdgeInsets.all(20),
          child: Container(
            width: 1000,
            child: PaginatedTable(
              lists: orders, 
              viewFunction: (order) {},
              columns: [
                DataColumn(label: Text('OrderId')),
                DataColumn(label: Text('User')),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Total')),
                DataColumn(label: Text('Actions')),
              ], 
              columnKeys: ['_id' , 'userId', 'createdAt', 'totalAmount']
            ),
            // child: PaginatedDataTable(
            //   rowsPerPage: 10,
            //   source: _data,
            //   columns: [
            //     DataColumn(label: Text('OrderId')),
            //     DataColumn(label: Text('User')),
            //     DataColumn(label: Text('Date')),
            //     DataColumn(label: Text('Total')),
            //     DataColumn(label: Text('Actions')),
            //   ], 
            //   header: const Center(child: Text('List Order')),
            // ),
          )
        ),
      ],
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
        text = const Text('2025 March', style: style);
        break;
      case 7: 
        text = const Text('2025 April', style: style);
        break;
      case 12: 
        text = const Text('2025 May', style: style);
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

class MyData extends DataTableSource {
  final List<Map<String, dynamic>> orders = [
  {
    'orderId': 1,
    'user': 'John Doe',
    'date': DateTime(2023, 4, 20),
    'total': 29.99,
  },
  {
    'orderId': 2,
    'user': 'Jane Smith',
    'date': DateTime(2023, 4, 21),
    'total': 49.50,
  },
  {
    'orderId': 3,
    'user': 'Mike Johnson',
    'date': DateTime(2023, 4, 22),
    'total': 15.75,
  },
  {
    'orderId': 4,
    'user': 'Emily Davis',
    'date': DateTime(2023, 4, 23),
    'total': 99.99,
  },
  {
    'orderId': 5,
    'user': 'Chris Lee',
    'date': DateTime(2023, 4, 24),
    'total': 5.00,
  },
  {
    'orderId': 6,
    'user': 'Sarah Brown',
    'date': DateTime(2023, 4, 25),
    'total': 75.20,
  },
  {
    'orderId': 7,
    'user': 'David Wilson',
    'date': DateTime(2023, 4, 26),
    'total': 34.10,
  },
  {
    'orderId': 8,
    'user': 'Jessica Taylor',
    'date': DateTime(2023, 4, 27),
    'total': 89.99,
  },
  {
    'orderId': 9,
    'user': 'Daniel Martinez',
    'date': DateTime(2023, 4, 28),
    'total': 42.00,
  },
  {
    'orderId': 10,
    'user': 'Laura Garcia',
    'date': DateTime(2023, 4, 29),
    'total': 60.00,
  },
];

  @override
  DataRow? getRow(int index) {
    return DataRow(
      cells: [
        DataCell(Text(orders[index]['orderId'].toString())),
        DataCell(Text(orders[index]['user'])),
        DataCell(Text(orders[index]['date'].toString())),
        DataCell(Text(orders[index]['total'].toString())),
        DataCell(
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: (){},
                icon: Icon(Icons.remove_red_eye)
              ),
              IconButton(
                onPressed: (){},
                icon: Icon(Icons.delete)
              )
            ]
          ),
        ),
      ]
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => orders.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
  
}