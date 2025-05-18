import 'dart:ui';
import 'package:ecommerce/features/admin/responsive.dart';
import 'package:flutter/material.dart';

class PaginatedTable extends StatefulWidget{
  const PaginatedTable({
    super.key, 
    required this.lists,
    this.removeFunction,
    this.viewFunction,
    required this.columns,
    this.header = 'Table', 
    required this.columnKeys
  });

  final List<dynamic> lists;
  final Function(dynamic)? removeFunction;
  final Function(dynamic)? viewFunction;
  final List<DataColumn> columns;
  final String header;
  final List<String> columnKeys;

  @override
  State<PaginatedTable> createState() => _PaginatedTableState();
}

class _PaginatedTableState extends State<PaginatedTable> {
  late final DataTableSource _data;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    // print('PREVIEEEEE: ${widget.lists.join(',')}');
    _data = MyData(
      widget.lists, widget.removeFunction, 
      widget.viewFunction,
      widget.columnKeys
    );
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
  MyData(this.lists ,this.removeFunction, this.viewFunction, this.columnKeys);
  final List<dynamic> lists;
  final Function(Map<String, dynamic>)? removeFunction;
  final Function(Map<String, dynamic>)? viewFunction;
  // final VoidCallback viewFunction;
  final List<String> columnKeys;
  

  @override
  DataRow? getRow(int index) {

    final item = lists[index];

    List<DataCell> cells = [];

    // Duyệt qua các khóa để lấy giá trị
    for (var key in columnKeys) {
      var value = item[key];
      cells.add(DataCell(Text(value?.toString() ?? ''))); // Thêm DataCell
    }

    // Thêm DataCell cho các hành động
    if (viewFunction != null || removeFunction != null){
      cells.add(
        DataCell(
          Row(
            children: [
              if (viewFunction != null)
                IconButton(
                  onPressed: () => viewFunction!(item),
                  icon: Icon(Icons.remove_red_eye)
                ),
              if (removeFunction != null)
                IconButton(
                  onPressed: () => removeFunction!(item), // Hành động xóa
                  icon: Icon(Icons.delete),
                ),
            ],
          ),
        ),
      );
    }

    // Trả về DataRow với danh sách cells đã tạo
    return DataRow(cells: cells);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => lists.length;

  @override
  
  int get selectedRowCount => 0;
  
}