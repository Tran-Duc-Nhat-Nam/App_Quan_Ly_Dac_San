import 'package:app_dac_san/features/dac_san/view/trang_dac_san.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../core/gui_helper.dart';
import '../data/dac_san.dart';

class BangDacSan extends StatelessWidget {
  const BangDacSan({
    super.key,
    required this.dsDacSan,
    required this.dsChon,
    required this.widget,
    required this.duLieuDacSan,
  });

  final List<DacSan> dsDacSan;
  final List<bool> dsChon;
  final TrangDacSan widget;
  final DacSanDataTableSource duLieuDacSan;

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable2(
      controller: widget.dacSanController,
      rowsPerPage: 10,
      header: Row(
        children: [
          const Text("Đặc sản"),
          const SizedBox(width: 25),
          Flexible(
            flex: 1,
            child: TypeAheadField(
              controller: widget.textDacSanController,
              builder: (context, controller, focusNode) {
                return TextField(
                  onSubmitted: (value) {
                    int slot =
                        dsDacSan.indexWhere((element) => element.ten == value);
                    if (slot != -1) {
                      widget.dacSanController.goToRow(slot);
                      dsChon[slot] = true;
                    }
                  },
                  controller: widget.textDacSanController,
                  focusNode: focusNode,
                  autofocus: false,
                );
              },
              loadingBuilder: (context) => loadingCircle(size: 50),
              emptyBuilder: (context) => const ListTile(
                title: Text("Không có đặc sản trùng khớp"),
              ),
              itemBuilder: (context, item) {
                return ListTile(
                  title: Text(item.ten),
                );
              },
              onSelected: (value) {
                int slot =
                    dsDacSan.indexWhere((element) => element.ten == value.ten);
                widget.dacSanController.goToRow(slot);
                dsChon[slot] = true;
              },
              suggestionsCallback: (search) => dsDacSan
                  .where((element) => element.ten.contains(search))
                  .toList(),
            ),
          )
        ],
      ),
      columns: const [
        DataColumn2(
          label: Text('ID'),
          size: ColumnSize.S,
        ),
        DataColumn2(
          label: Text('Tên'),
          size: ColumnSize.M,
        ),
        DataColumn2(
          label: Text('Mô tả'),
          size: ColumnSize.L,
        ),
        DataColumn2(
          label: Text('Cách chế biến'),
          size: ColumnSize.L,
        ),
        DataColumn2(
          label: Text('Vùng miền'),
          size: ColumnSize.L,
        ),
        DataColumn2(
          label: Text('Mùa'),
          size: ColumnSize.L,
        ),
        DataColumn2(
          label: Text('Lượt xem'),
          size: ColumnSize.S,
          numeric: true,
        ),
        DataColumn2(
          label: Text('Điểm đánh giá'),
          size: ColumnSize.S,
          numeric: true,
        ),
        DataColumn2(
          label: Text('Lượt đánh giá'),
          size: ColumnSize.S,
          numeric: true,
        ),
      ],
      source: duLieuDacSan,
    );
  }
}

class DacSanDataTableSource extends DataTableSource {
  List<DacSan> dsDacSan = [];
  List<bool> dsChon = [];
  BuildContext context;
  void Function(BuildContext, int) notifyParent;

  DacSanDataTableSource({
    required this.dsDacSan,
    required this.dsChon,
    required this.context,
    required this.notifyParent,
  });

  @override
  DataRow? getRow(int index) {
    return DataRow2(
      onSelectChanged: (value) {
        dsChon[index] = value!;
        notifyListeners();
        notifyParent(context, index);
      },
      selected: dsChon[index],
      cells: [
        DataCell(Text(dsDacSan[index].id.toString())),
        DataCell(Text(dsDacSan[index].ten)),
        DataCell(Text(dsDacSan[index].moTa ?? "Chưa có thông tin")),
        DataCell(Text(dsDacSan[index].cachCheBien ?? "Chưa có thông tin")),
        DataCell(Text(
            dsDacSan[index].vungMien.map((e) => e.ten).toList().join(", "))),
        DataCell(Text(
            dsDacSan[index].muaDacSan.map((e) => e.ten).toList().join(", "))),
        DataCell(Text(dsDacSan[index].luotXem.toString())),
        DataCell(Text(dsDacSan[index].diemDanhGia.toString())),
        DataCell(Text(dsDacSan[index].luotDanhGia.toString())),
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
