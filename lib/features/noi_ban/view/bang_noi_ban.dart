import 'package:app_dac_san/features/noi_ban/view/trang_noi_ban.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../core/gui_helper.dart';
import '../data/noi_ban.dart';

class BangNoiBan extends StatelessWidget {
  const BangNoiBan({
    super.key,
    required this.dsNoiBan,
    required this.dsChon,
    required this.widget,
    required this.duLieuNoiBan,
  });

  final List<NoiBan> dsNoiBan;
  final List<bool> dsChon;
  final TrangNoiBan widget;
  final NoiBanDataTableSource duLieuNoiBan;

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable2(
      controller: widget.noiBanController,
      rowsPerPage: 10,
      header: Row(
        children: [
          const Text("Đặc sản"),
          const SizedBox(width: 25),
          Flexible(
            flex: 1,
            child: TypeAheadField(
              controller: widget.textNoiBanController,
              builder: (context, controller, focusNode) {
                return TextField(
                  onSubmitted: (value) {
                    int slot =
                        dsNoiBan.indexWhere((element) => element.ten == value);
                    if (slot != -1) {
                      widget.noiBanController.goToRow(slot);
                      dsChon[slot] = true;
                    }
                  },
                  controller: widget.textNoiBanController,
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
                    dsNoiBan.indexWhere((element) => element.ten == value.ten);
                widget.noiBanController.goToRow(slot);
                dsChon[slot] = true;
              },
              suggestionsCallback: (search) => dsNoiBan
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
          label: Text('Địa chỉ'),
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
      source: duLieuNoiBan,
    );
  }
}

class NoiBanDataTableSource extends DataTableSource {
  List<NoiBan> dsNoiBan = [];
  List<bool> dsChon = [];
  BuildContext context;
  void Function(BuildContext, int) notifyParent;

  NoiBanDataTableSource({
    required this.dsNoiBan,
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
        DataCell(Text(dsNoiBan[index].id.toString())),
        DataCell(Text(dsNoiBan[index].ten)),
        DataCell(Text(dsNoiBan[index].moTa ?? "Chưa có thông tin")),
        DataCell(Text(dsNoiBan[index].diaChi.toString())),
        DataCell(Text(dsNoiBan[index].luotXem.toString())),
        DataCell(Text(dsNoiBan[index].diemDanhGia.toString())),
        DataCell(Text(dsNoiBan[index].luotDanhGia.toString())),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dsNoiBan.length;

  @override
  int get selectedRowCount => 0;
}
