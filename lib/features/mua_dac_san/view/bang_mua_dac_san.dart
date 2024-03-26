import 'package:app_dac_san/features/mua_dac_san/view/trang_mua_dac_san.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../core/gui_helper.dart';
import '../data/mua_dac_san.dart';

class BangMuaDacSan extends StatelessWidget {
  const BangMuaDacSan({
    super.key,
    required this.widget,
    required this.dsMuaDacSan,
    required this.dsChon,
    required this.dataTableSource,
  });

  final TrangMuaDacSan widget;
  final List<MuaDacSan> dsMuaDacSan;
  final List<bool> dsChon;
  final MuaDacSanDataTableSource dataTableSource;

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable2(
      controller: widget.pageController,
      rowsPerPage: 10,
      header: Row(
        children: [
          Text("Vùng miền"),
          const SizedBox(width: 25),
          Flexible(
            flex: 1,
            child: TypeAheadField(
              controller: widget.textController,
              builder: (context, controller, focusNode) {
                return TextField(
                  onSubmitted: (value) {
                    int slot = dsMuaDacSan
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
                title: Text("Không có mùa trùng khớp"),
              ),
              itemBuilder: (context, item) {
                return ListTile(
                  title: Text(item.ten),
                );
              },
              onSelected: (value) {
                int slot = dsMuaDacSan
                    .indexWhere((element) => element.ten == value.ten);
                widget.pageController.goToRow(slot);
                dsChon[slot] = true;
              },
              suggestionsCallback: (search) => dsMuaDacSan
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

class MuaDacSanDataTableSource extends DataTableSource {
  List<MuaDacSan> dsMuaDacSan = [];
  List<bool> dsChon = [];
  void Function(List<bool>) notifyParent;

  MuaDacSanDataTableSource({
    required this.dsMuaDacSan,
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
        DataCell(Text(dsMuaDacSan[index].id.toString())),
        DataCell(Text(dsMuaDacSan[index].ten)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dsMuaDacSan.length;

  @override
  int get selectedRowCount => 0;
}
