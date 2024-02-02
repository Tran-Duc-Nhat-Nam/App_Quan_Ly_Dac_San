import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../data/thanh_phan.dart';

class BangThanhPhan extends StatelessWidget {
  const BangThanhPhan({
    super.key,
    required this.dsChonDacSan,
    required this.bangThanhPhan,
  });

  final List<bool> dsChonDacSan;
  final ThanhPhanDataTableSource bangThanhPhan;

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable2(
      empty: Center(
        child: Text(dsChonDacSan.where((element) => element).length > 1
            ? "Vui lòng chỉ chọn một dòng dữ liệu"
            : "Không có dữ liệu thành phần của đặc sản này"),
      ),
      rowsPerPage: 10,
      columns: const [
        DataColumn2(
          label: Text('Tên'),
          size: ColumnSize.M,
        ),
        DataColumn2(
          label: Text('Số lượng'),
          size: ColumnSize.S,
        ),
        DataColumn2(
          label: Text('Đơn vị tính'),
          size: ColumnSize.S,
        ),
      ],
      source: bangThanhPhan,
    );
  }
}

class ThanhPhanDataTableSource extends DataTableSource {
  List<ThanhPhan> dsThanhPhan = [];
  List<bool> dsChon = [];
  void Function(List<bool>) notifyParent;

  ThanhPhanDataTableSource({
    required this.dsThanhPhan,
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
        DataCell(Text(dsThanhPhan[index].nguyenLieu.ten)),
        DataCell(Text(dsThanhPhan[index].soLuong.toString())),
        DataCell(Text(dsThanhPhan[index].donViTinh)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dsThanhPhan.length;

  @override
  int get selectedRowCount => 0;
}
