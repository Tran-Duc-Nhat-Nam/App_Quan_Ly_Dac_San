import 'package:app_dac_san/features/nguoi_dung/view/trang_nguoi_dung.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

import '../../../core/gui_helper.dart';
import '../data/nguoi_dung.dart';

class BangNguoiDung extends StatelessWidget {
  const BangNguoiDung({
    super.key,
    required this.widget,
    required this.dsNguoiDung,
    required this.dsChon,
    required this.dataTableSource,
  });

  final TrangNguoiDung widget;
  final List<NguoiDung> dsNguoiDung;
  final List<bool> dsChon;
  final NguoiDungDataTableSource dataTableSource;

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
                    int slot = dsNguoiDung
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
                title: Text("Không có người dùng trùng khớp"),
              ),
              itemBuilder: (context, item) {
                return ListTile(
                  title: Text(item.ten),
                );
              },
              onSelected: (value) {
                int slot = dsNguoiDung
                    .indexWhere((element) => element.ten == value.ten);
                widget.pageController.goToRow(slot);
                dsChon[slot] = true;
              },
              suggestionsCallback: (search) =>
                  dsNguoiDung
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
        DataColumn2(
          label: Text('Email'),
        ),
        DataColumn2(
          label: Text('Họ tên'),
        ),
        DataColumn2(
          label: Text('Giới tính'),
        ),
        DataColumn2(
          label: Text('Ngày sinh'),
        ),
        DataColumn2(
          label: Text('SĐT'),
        ),
        DataColumn2(
          label: Text('Địa chỉ'),
        ),
      ],
      source: dataTableSource,
    );
  }
}

class NguoiDungDataTableSource extends DataTableSource {
  List<NguoiDung> dsNguoiDung = [];
  List<bool> dsChon = [];
  void Function(List<bool>) notifyParent;

  NguoiDungDataTableSource({
    required this.dsNguoiDung,
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
        DataCell(Text(dsNguoiDung[index].id.toString())),
        DataCell(Text(dsNguoiDung[index].email)),
        DataCell(Text(dsNguoiDung[index].ten)),
        DataCell(dsNguoiDung[index].isNam
            ? const Icon(Icons.male, color: Colors.blue)
            : const Icon(Icons.female, color: Colors.pink)),
        DataCell(Text(DateFormat("dd/MM/yyy")
            .format(dsNguoiDung[index].ngaySinh.toLocal()))),
        DataCell(Text(dsNguoiDung[index].soDienThoai)),
        DataCell(Text(dsNguoiDung[index].diaChi.toString())),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dsNguoiDung.length;

  @override
  int get selectedRowCount => 0;
}
