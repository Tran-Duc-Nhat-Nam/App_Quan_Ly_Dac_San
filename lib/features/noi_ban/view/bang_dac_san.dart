import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../../dac_san/data/dac_san.dart';

class BangDacSan extends StatelessWidget {
  const BangDacSan({
    super.key,
    required this.dsChonNoiBan,
    required this.bangDacSan,
  });

  final List<bool> dsChonNoiBan;
  final DacSanDataTableSource bangDacSan;

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable2(
      empty: Center(
        child: Text(dsChonNoiBan.where((element) => element).length > 1
            ? "Vui lòng chỉ chọn một dòng dữ liệu"
            : "Không có dữ liệu thành phần của đặc sản này"),
      ),
      rowsPerPage: 10,
      columns: const [
        DataColumn2(
          label: Text('Tên'),
          size: ColumnSize.M,
        ),
      ],
      source: bangDacSan,
    );
  }
}

class DacSanDataTableSource extends DataTableSource {
  List<DacSan> dsDacSan = [];
  List<bool> dsChon = [];
  void Function(List<bool>) notifyParent;

  DacSanDataTableSource({
    required this.dsDacSan,
    required this.dsChon,
    required this.notifyParent,
  });

  @override
  DataRow? getRow(int index) {
    return DataRow2(
      onSelectChanged: (value) {
        dsChon[index] = value!;
        notifyListeners();
        notifyParent(dsChon);
      },
      selected: dsChon[index],
      cells: [
        DataCell(Text(dsDacSan[index].ten)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dsDacSan.length;

  @override
  int get selectedRowCount => 0;
}
