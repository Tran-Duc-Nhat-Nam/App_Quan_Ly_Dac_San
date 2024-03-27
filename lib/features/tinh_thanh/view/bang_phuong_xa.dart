import 'package:app_dac_san/features/tinh_thanh/view/trang_tinh_thanh.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../core/gui_helper.dart';
import '../data/phuong_xa.dart';

class BangPhuongXa extends StatelessWidget {
  const BangPhuongXa({
    super.key,
    required this.widget,
    required this.dsPhuongXa,
    required this.dsChon,
    required this.dataTableSource,
  });

  final TrangTinhThanh widget;
  final List<PhuongXa> dsPhuongXa;
  final List<bool> dsChon;
  final PhuongXaDataTableSource dataTableSource;

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable2(
      controller: widget.pageController,
      rowsPerPage: 10,
      header: Row(
        children: [
          const Text("Phường xã"),
          const SizedBox(width: 25),
          Flexible(
            flex: 1,
            child: TypeAheadField(
              controller: widget.textController,
              builder: (context, controller, focusNode) {
                return TextField(
                  onSubmitted: (value) {
                    int slot = dsPhuongXa
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
                title: Text("Không có phường xã trùng khớp"),
              ),
              itemBuilder: (context, item) {
                return ListTile(
                  title: Text(item.ten),
                );
              },
              onSelected: (value) {
                int slot = dsPhuongXa
                    .indexWhere((element) => element.ten == value.ten);
                widget.pageController.goToRow(slot);
                dsChon[slot] = true;
              },
              suggestionsCallback: (search) => dsPhuongXa
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

class PhuongXaDataTableSource extends DataTableSource {
  List<PhuongXa> dsPhuongXa = [];

  PhuongXaDataTableSource({
    required this.dsPhuongXa,
  });

  @override
  DataRow? getRow(int index) {
    return DataRow2(
      cells: [
        DataCell(Text(dsPhuongXa[index].id.toString())),
        DataCell(Text(dsPhuongXa[index].ten)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dsPhuongXa.length;

  @override
  int get selectedRowCount => 0;
}
