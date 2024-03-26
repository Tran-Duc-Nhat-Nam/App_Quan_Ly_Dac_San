import 'package:app_dac_san/features/tinh_thanh/view/trang_tinh_thanh.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../core/gui_helper.dart';
import '../data/quan_huyen.dart';

class BangQuanHuyen extends StatelessWidget {
  const BangQuanHuyen({
    super.key,
    required this.widget,
    required this.dsQuanHuyen,
    required this.dsChon,
    required this.dataTableSource,
  });

  final TrangTinhThanh widget;
  final List<QuanHuyen> dsQuanHuyen;
  final List<bool> dsChon;
  final QuanHuyenDataTableSource dataTableSource;

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable2(
      controller: widget.pageController,
      rowsPerPage: 10,
      header: Row(
        children: [
          Text("Quận huyện"),
          const SizedBox(width: 25),
          Flexible(
            flex: 1,
            child: TypeAheadField(
              controller: widget.textController,
              builder: (context, controller, focusNode) {
                return TextField(
                  onSubmitted: (value) {
                    int slot = dsQuanHuyen
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
                title: Text("Không có quận huyện trùng khớp"),
              ),
              itemBuilder: (context, item) {
                return ListTile(
                  title: Text(item.ten),
                );
              },
              onSelected: (value) {
                int slot = dsQuanHuyen
                    .indexWhere((element) => element.ten == value.ten);
                widget.pageController.goToRow(slot);
                dsChon[slot] = true;
              },
              suggestionsCallback: (search) => dsQuanHuyen
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

class QuanHuyenDataTableSource extends DataTableSource {
  List<QuanHuyen> dsQuanHuyen = [];
  BuildContext context;
  void Function(BuildContext, int) notifyParent;

  QuanHuyenDataTableSource({
    required this.dsQuanHuyen,
    required this.context,
    required this.notifyParent,
  });

  @override
  DataRow? getRow(int index) {
    return DataRow2(
      onTap: () {
        notifyParent(context, dsQuanHuyen[index].id);
      },
      cells: [
        DataCell(Text(dsQuanHuyen[index].id.toString())),
        DataCell(Text(dsQuanHuyen[index].ten)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dsQuanHuyen.length;

  @override
  int get selectedRowCount => 0;
}
