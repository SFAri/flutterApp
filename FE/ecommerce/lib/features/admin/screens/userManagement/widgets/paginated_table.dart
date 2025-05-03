import 'dart:ui';

import 'package:ecommerce/features/admin/main.dart';
import 'package:ecommerce/features/admin/responsive.dart';
import 'package:ecommerce/features/admin/screens/couponManagement/detailCoupon/detail_coupon.dart';
import 'package:ecommerce/utils/device/device_utility.dart';
import 'package:flutter/material.dart';

class PaginatedTable extends StatefulWidget{
  const PaginatedTable({
    super.key, 
    required this.lists,
    required this.removeFunction,
    this.viewFunction,
    required this.columns,
    this.header = 'Table'
  });

  final List<Map<String, dynamic>> lists;
  final VoidCallback removeFunction;
  final Function(Map<String, dynamic>)? viewFunction;
  final List<DataColumn> columns;
  final String header;

  @override
  State<PaginatedTable> createState() => _PaginatedTableState();
}

class _PaginatedTableState extends State<PaginatedTable> {
  late final DataTableSource _data;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    _data = MyData(widget.lists, widget.removeFunction, widget.viewFunction ?? (item) {
      // Hàm mặc định, có thể để trống hoặc hiển thị thông báo
      print("Xem chi tiết cho: $item");
    });
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          width: Responsive.isDesktop(context) ? 1000 : Responsive.isTablet(context) ? 900 : 350,
          child: widget.lists.isEmpty
              ? Center(child: Text("No data to display"))
              : Scrollbar(
                  controller: scrollController,
                  scrollbarOrientation: ScrollbarOrientation.bottom,
                  thumbVisibility: true,
                  // trackVisibility: true,
                  interactive: true,

                  child: PaginatedDataTable(
                      controller: scrollController,
                      rowsPerPage: 10,
                      source: _data,
                      columns:  widget.columns, 
                      header:  Center(child: Text(widget.header)),
                    ),
              ),
        ),
      ),
    );
  }
}

class MyData extends DataTableSource {
  MyData(this.lists ,this.removeFunction, this.viewFunction);
  final List<Map<String, dynamic>> lists;
  final VoidCallback removeFunction;
  final Function(Map<String, dynamic>) viewFunction;
  // final VoidCallback viewFunction;

  @override
  DataRow? getRow(int index) {
    // Lấy dữ liệu cho dòng hiện tại
    final item = lists[index];

    // Tạo danh sách DataCell tự động
    List<DataCell> cells = [];

    item.forEach((key, value) {
      // Kiểm tra nếu giá trị không phải là danh sách
      if (value is! List) {
        cells.add(DataCell(Text(value.toString()))); // Tạo DataCell cho mỗi giá trị
      }
    });

    // Thêm DataCell cho các hành động
    cells.add(
      DataCell(
        Row(
          children: [
            IconButton(
              onPressed: () => viewFunction(item),
              icon: Icon(Icons.remove_red_eye),
            ),
            IconButton(
              onPressed: () => removeFunction(), // Hành động xóa
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );

    // Trả về DataRow với danh sách cells đã tạo
    return DataRow(cells: cells);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => lists.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
  
}