import 'package:app_dac_san/features/tinh_thanh/view/trang_tinh_thanh.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../core/gui_helper.dart';
import '../data/tinh_thanh.dart';

class BangTinhThanh extends StatelessWidget {
  const BangTinhThanh({
    super.key,
    required this.widget,
    required this.dsTinhThanh,
    required this.dsChon,
    required this.dataTableSource,
  });

  final TrangTinhThanh widget;
  final List<TinhThanh> dsTinhThanh;
  final List<bool> dsChon;
  final TinhThanhDataTableSource dataTableSource;

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable2(
      controller: widget.pageController,
      rowsPerPage: 10,
      header: Row(
        children: [
          const Text("Tỉnh thành"),
          const SizedBox(width: 25),
          Flexible(
            flex: 1,
            child: TypeAheadField(
              controller: widget.textController,
              builder: (context, controller, focusNode) {
                return TextField(
                  onSubmitted: (value) {
                    int slot = dsTinhThanh
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
              emptyBuilder: (context) =>
              const ListTile(
                title: Text("Không có tỉnh thành trùng khớp"),
              ),
              itemBuilder: (context, item) {
                return ListTile(
                  title: Text(item.ten),
                );
              },
              onSelected: (value) {
                int slot = dsTinhThanh
                    .indexWhere((element) => element.ten == value.ten);
                widget.pageController.goToRow(slot);
                dsChon[slot] = true;
              },
              suggestionsCallback: (search) =>
                  dsTinhThanh
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

class TinhThanhDataTableSource extends DataTableSource {
  List<TinhThanh> dsTinhThanh = [];
  BuildContext context;
  void Function(BuildContext, int) notifyParent;

  TinhThanhDataTableSource({
    required this.dsTinhThanh,
    required this.context,
    required this.notifyParent,
  });

  @override
  DataRow? getRow(int index) {
    // TODO: implement getRow
    return DataRow2(
      onTap: () {
        notifyParent(context, dsTinhThanh[index].id);
      },
      cells: [
        DataCell(Text(dsTinhThanh[index].id.toString())),
        DataCell(Text(dsTinhThanh[index].ten)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dsTinhThanh.length;

  @override
  int get selectedRowCount => 0;
}
