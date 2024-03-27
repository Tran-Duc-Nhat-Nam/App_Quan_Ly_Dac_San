import 'package:app_dac_san/features/vung_mien/view/trang_vung_mien.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../core/gui_helper.dart';
import '../data/vung_mien.dart';

class BangTinhThanh extends StatelessWidget {
  const BangTinhThanh({
    super.key,
    required this.widget,
    required this.dsVungMien,
    required this.dsChon,
    required this.dataTableSource,
  });

  final TrangVungMien widget;
  final List<VungMien> dsVungMien;
  final List<bool> dsChon;
  final VungMienDataTableSource dataTableSource;

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
                    int slot = dsVungMien
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
                title: Text("Không có vùng miền trùng khớp"),
              ),
              itemBuilder: (context, item) {
                return ListTile(
                  title: Text(item.ten),
                );
              },
              onSelected: (value) {
                int slot = dsVungMien
                    .indexWhere((element) => element.ten == value.ten);
                widget.pageController.goToRow(slot);
                dsChon[slot] = true;
              },
              suggestionsCallback: (search) => dsVungMien
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

class VungMienDataTableSource extends DataTableSource {
  List<VungMien> dsVungMien = [];
  List<bool> dsChon = [];
  void Function(List<bool>) notifyParent;

  VungMienDataTableSource({
    required this.dsVungMien,
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
        DataCell(Text(dsVungMien[index].id.toString())),
        DataCell(Text(dsVungMien[index].ten)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dsVungMien.length;

  @override
  int get selectedRowCount => 0;
}
