import 'package:app_dac_san/features/nguyen_lieu/view/trang_nguyen_lieu.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../core/gui_helper.dart';
import '../data/nguyen_lieu.dart';

class BangNguyenLieu extends StatelessWidget {
  const BangNguyenLieu({
    super.key,
    required this.widget,
    required this.dsNguyenLieu,
    required this.dsChon,
    required this.dataTableSource,
  });

  final TrangNguyenLieu widget;
  final List<NguyenLieu> dsNguyenLieu;
  final List<bool> dsChon;
  final NguyenLieuDataTableSource dataTableSource;

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable2(
      controller: widget.pageController,
      rowsPerPage: 10,
      header: Row(
        children: [
          const Text("Vùng miền"),
          const SizedBox(width: 25),
          Flexible(
            flex: 1,
            child: TypeAheadField(
              controller: widget.textController,
              builder: (context, controller, focusNode) {
                return TextField(
                  onSubmitted: (value) {
                    int slot = dsNguyenLieu
                        .indexWhere((element) => element.ten == value);
                    if (slot != -1) {
                      widget.pageController.goToRow(slot);
                      dsChon[slot] = true;
                    }
                  },
                  controller: widget.textController,
                  focusNode: focusNode,
                  autofocus: false,
                );
              },
              loadingBuilder: (context) => loadingCircle(size: 50),
              emptyBuilder: (context) => const ListTile(
                title: Text("Không có nguyên liệu trùng khớp"),
              ),
              itemBuilder: (context, item) {
                return ListTile(
                  title: Text(item.ten),
                );
              },
              onSelected: (value) {
                int slot = dsNguyenLieu
                    .indexWhere((element) => element.ten == value.ten);
                widget.pageController.goToRow(slot);
                dsChon[slot] = true;
              },
              suggestionsCallback: (search) => dsNguyenLieu
                  .where((element) => element.ten.contains(search))
                  .toList(),
            ),
          )
        ],
      ),
      columns: const [
        DataColumn2(
          label: Text('ID'),
        ),
        DataColumn(
          label: Text('Tên'),
        ),
      ],
      source: dataTableSource,
    );
  }
}

class NguyenLieuDataTableSource extends DataTableSource {
  List<NguyenLieu> dsNguyenLieu = [];
  List<bool> dsChon = [];
  void Function(List<bool>) notifyParent;

  NguyenLieuDataTableSource({
    required this.dsNguyenLieu,
    required this.dsChon,
    required this.notifyParent,
  });

  @override
  DataRow? getRow(int index) {
    // TODO: implement getRow
    return DataRow2(
      onSelectChanged: (value) {
        dsChon[index] = value!;
        notifyListeners();
        notifyParent(dsChon);
      },
      selected: dsChon[index],
      cells: [
        DataCell(Text(dsNguyenLieu[index].id.toString())),
        DataCell(Text(dsNguyenLieu[index].ten)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dsNguyenLieu.length;

  @override
  int get selectedRowCount => 0;
}
