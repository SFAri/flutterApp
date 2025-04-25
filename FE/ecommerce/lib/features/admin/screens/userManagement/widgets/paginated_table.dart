import 'package:flutter/material.dart';

class PaginatedTable extends StatefulWidget{
  const PaginatedTable({
    super.key, 
    required this.lists,
    required this.removeFunction,
    required this.viewFunction,
    required this.columns,
    this.header = 'Table'
  });

  final List<Map<String, dynamic>> lists;
  final VoidCallback removeFunction;
  final VoidCallback viewFunction;
  final List<DataColumn> columns;
  final String header;

  @override
  State<PaginatedTable> createState() => _PaginatedTableState();
}

class _PaginatedTableState extends State<PaginatedTable> {
  late final DataTableSource _data;

  @override
  void initState() {
    super.initState();
    _data = MyData(widget.lists, widget.removeFunction, widget.viewFunction);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        
        child: Container(
          // height: 1000,
          width: 1000,
          child: PaginatedDataTable(
            rowsPerPage: 10,
            source: _data,
            columns: widget.columns, 
            header: Center(child: Text(widget.header)),
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
  final VoidCallback viewFunction;

  @override
  DataRow? getRow(int index) {
    // Lấy dữ liệu cho dòng hiện tại
    final item = lists[index];

    // Tạo danh sách DataCell tự động
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
              onPressed: () => viewFunction(), // Hành động xem
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