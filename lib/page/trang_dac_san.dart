import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class TrangDacSan extends StatefulWidget {
  const TrangDacSan({super.key});

  @override
  _TrangDacSanState createState() => _TrangDacSanState();
}

class _TrangDacSanState extends State<TrangDacSan> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 600),
              child: PaginatedDataTable2(
                rowsPerPage: 10,
                columns: const [
                  DataColumn2(
                    label: Text('ID'),
                    size: ColumnSize.L,
                  ),
                  DataColumn(
                    label: Text('Tên'),
                  ),
                  DataColumn(
                    label: Text('Mô tả'),
                  ),
                  DataColumn(
                    label: Text('Cách chế biến'),
                  ),
                  DataColumn(
                    label: Text('Lượt xem'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Điểm đánh giá'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Lượt đánh giá'),
                    numeric: true,
                  ),
                ],
                source: DacSanDataTableSource(),
              ),
            ),
          ),
          Container(
            height: 250,
            child: Form(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          label: const Text("Tên"),
                          hintText: "Nhập tên đặc sản",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          )),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          label: const Text("Mô tả"),
                          hintText: "Nhập thông tin mô tả đặc sản",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          )),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          label: const Text("Cách chế biến"),
                          hintText: "Nhập cách thức chế biến đặc sản (nếu có)",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DacSanDataTableSource extends DataTableSource {
  @override
  DataRow? getRow(int index) {
    // TODO: implement getRow
    return DataRow2(
      cells: [
        DataCell(Text("Item $index")),
        DataCell(Text("Item $index")),
        DataCell(Text("Item $index")),
        DataCell(Text("Item $index")),
        DataCell(Text(index.toString())),
        DataCell(Text(index.toString())),
        DataCell(Text(index.toString())),
      ],
    );
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => 100;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
