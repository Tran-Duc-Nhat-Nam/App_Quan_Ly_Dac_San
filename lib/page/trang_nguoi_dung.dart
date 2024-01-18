import 'package:app_dac_san/model/phuong_xa.dart';
import 'package:app_dac_san/model/quan_huyen.dart';
import 'package:app_dac_san/model/tinh_thanh.dart';
import 'package:async_builder/async_builder.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:date_field/date_field.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../gui_helper.dart';
import '../model/dia_chi.dart';
import '../model/nguoi_dung.dart';

class TrangNguoiDung extends StatefulWidget {
  TrangNguoiDung({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController tenController = TextEditingController();
  final TextEditingController soDienThoaiController = TextEditingController();
  @override
  State<TrangNguoiDung> createState() => _TrangNguoiDungState();
}

class _TrangNguoiDungState extends State<TrangNguoiDung> {
  List<NguoiDung> dsNguoiDung = [];
  List<TinhThanh> dsTinhThanh = [];
  List<QuanHuyen> dsQuanHuyen = [];
  List<PhuongXa> dsPhuongXa = [];
  List<bool> selectedRowsIndex = [];
  TinhThanh? tinhThanh;
  QuanHuyen? quanHuyen;
  PhuongXa? phuongXa;
  DateTime ngaySinh = DateTime.now();
  bool isNam = true;
  late NguoiDungDataTableSource dataTableSource;
  late Future myFuture;
  void notifyParent(int index) {
    setState(() {
      widget.tenController.text = dsNguoiDung[index].ten;
      widget.soDienThoaiController.text = dsNguoiDung[index].soDienThoai;
    });
  }

  void createTable() {
    dataTableSource = NguoiDungDataTableSource(
      dsNguoiDung: dsNguoiDung,
      selectedRowIndexs: selectedRowsIndex,
      notifyParent: notifyParent,
    );
  }

  @override
  void initState() {
    myFuture = Future.delayed(const Duration(seconds: 1), () async {
      dsNguoiDung = await NguoiDung.doc();
      dsTinhThanh = await TinhThanh.doc();
      selectedRowsIndex = dsNguoiDung.map((e) => false).toList();
      createTable();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: AsyncBuilder(
        future: myFuture,
        waiting: (context) => loadingCircle(),
        builder: (context, value) => Column(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 600),
                child: PaginatedDataTable2(
                  rowsPerPage: 10,
                  columns: const [
                    DataColumn2(
                      label: Text('ID'),
                      size: ColumnSize.S,
                    ),
                    DataColumn2(
                      label: Text('Email'),
                      size: ColumnSize.L,
                    ),
                    DataColumn2(
                      label: Text('Tên'),
                      size: ColumnSize.L,
                    ),
                    DataColumn2(
                      label: Text('Giới tính'),
                      size: ColumnSize.S,
                    ),
                    DataColumn2(
                      label: Text('Ngày sinh'),
                      size: ColumnSize.M,
                    ),
                    DataColumn2(
                      label: Text('Địa chỉ'),
                      size: ColumnSize.L,
                      numeric: true,
                    ),
                    DataColumn2(
                      label: Text('Số điện thoại'),
                      size: ColumnSize.M,
                      numeric: true,
                    ),
                  ],
                  source: dataTableSource,
                ),
              ),
            ),
            Form(
              key: widget.formKey,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: widget.tenController,
                        validator: (value) => value == null || value.isEmpty
                            ? "Vui lòng nhập tên người dùng"
                            : null,
                        decoration: roundInputDecoration(
                            "Tên người dùng", "Nhập tên người dùng"),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: widget.soDienThoaiController,
                        decoration: roundInputDecoration(
                            "Mô tả người dùng", "Nhập thông tin mô tả"),
                      ),
                      const SizedBox(height: 15),
                      DateTimeFormField(
                        decoration:
                            roundInputDecoration("Ngày sinh người dùng", ""),
                        dateFormat: DateFormat("dd/MM/yyyy"),
                        initialPickerDateTime: DateTime.now(),
                        onChanged: (value) {
                          setState(() {
                            if (value != null) {
                              ngaySinh = value;
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      DropdownSearch<TinhThanh>(
                        validator: (value) =>
                            value == null ? "Vui lòng chọn tỉnh thành" : null,
                        popupProps: roundPopupProps("Danh sách tỉnh thành")
                            as PopupProps<TinhThanh>,
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration:
                              roundInputDecoration("Tỉnh thành", ""),
                        ),
                        compareFn: (item1, item2) => item1 == item2,
                        onChanged: (value) =>
                            value != null ? tinhThanh = value : null,
                        items: dsTinhThanh,
                        itemAsString: (value) => value.ten,
                      ),
                      const SizedBox(height: 15),
                      Flexible(
                        fit: FlexFit.tight,
                        child: DropdownSearch<QuanHuyen>(
                          validator: (value) =>
                              value == null ? "Vui lòng chọn quận huyện" : null,
                          popupProps: roundPopupProps("Danh sách quận huyện")
                              as PopupProps<QuanHuyen>,
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration:
                                roundInputDecoration("Quận huyện", ""),
                          ),
                          compareFn: (item1, item2) => item1 == item2,
                          onBeforePopupOpening: (selectedItem) async =>
                              Future(() => tinhThanh != null),
                          onChanged: (value) =>
                              value != null ? quanHuyen = value : null,
                          asyncItems: (text) => tinhThanh != null
                              ? QuanHuyen.doc(tinhThanh!.id)
                              : Future(() => []),
                          itemAsString: (value) => value.ten,
                        ),
                      ),
                      const SizedBox(height: 15),
                      DropdownSearch<PhuongXa>(
                        validator: (value) =>
                            value == null ? "Vui lòng chọn phường xã" : null,
                        popupProps: roundPopupProps("Danh sách phường xã")
                            as PopupProps<PhuongXa>,
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration:
                              roundInputDecoration("Phường xã", ""),
                        ),
                        compareFn: (item1, item2) => item1 == item2,
                        onBeforePopupOpening: (selectedItem) async =>
                            Future(() => quanHuyen != null),
                        onChanged: (value) =>
                            value != null ? phuongXa = value : null,
                        asyncItems: (text) => quanHuyen != null
                            ? PhuongXa.doc(quanHuyen!.id)
                            : Future(() => []),
                        itemAsString: (value) => value.ten,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: FilledButton(
                              style: roundButtonStyle(),
                              onPressed: () => them(context),
                              child: const Text("Thêm"),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Flexible(
                            fit: FlexFit.tight,
                            child: FilledButton(
                              style: roundButtonStyle(),
                              onPressed: () => capNhat(context),
                              child: const Text("Cập nhật"),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Flexible(
                            fit: FlexFit.tight,
                            child: FilledButton(
                              style: roundButtonStyle(),
                              onPressed: () => xoa(context),
                              child: const Text("Xóa"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        error: (context, error, stackTrace) =>
            Center(child: Text('Error: $error')),
      ),
    );
  }

  void them(BuildContext context) {
    if (widget.formKey.currentState!.validate()) {
      NguoiDung.them(
        widget.tenController.text,
        widget.emailController.text,
        isNam,
        widget.soDienThoaiController.text,
        DiaChi(
          id: 0,
          soNha: "soNha",
          tenDuong: "tenDuong",
          phuongXa: phuongXa!,
        ),
        ngaySinh,
      ).then((value) {
        if (value != null) {
          setState(() {
            dsNguoiDung.add(value);
            selectedRowsIndex.add(false);
            widget.tenController.clear();
            widget.soDienThoaiController.clear();
            createTable();
          });
        } else {
          showNotify(context, "Thêm người dùng thất bại");
        }
      });
    }
  }

  void capNhat(BuildContext context) {
    if (widget.formKey.currentState!.validate()) {
      if (selectedRowsIndex.where((element) => element).length == 1) {
        int i = selectedRowsIndex.indexOf(true);
        NguoiDung nguoiDung = NguoiDung(
          id: dsNguoiDung[i].id,
          ten: widget.tenController.text,
          email: widget.emailController.text,
          isNam: isNam,
          soDienThoai: widget.soDienThoaiController.text,
          diaChi: DiaChi(
            id: dsNguoiDung[i].diaChi.id,
            soNha: dsNguoiDung[i].diaChi.soNha,
            tenDuong: dsNguoiDung[i].diaChi.tenDuong,
            phuongXa: dsNguoiDung[i].diaChi.phuongXa,
          ),
          ngaySinh: ngaySinh,
        );
        NguoiDung.capNhat(nguoiDung).then((value) {
          if (value) {
            setState(() {
              dsNguoiDung[i] = nguoiDung;
              createTable();
            });
          } else {
            showNotify(context, "Cập nhật người dùng thất bại");
          }
        });
      } else {
        showNotify(context, "Vui lòng chỉ chọn một dòng để cập nhật");
      }
    }
  }

  void xoa(BuildContext context) {
    if (widget.formKey.currentState!.validate()) {
      for (int i = 0; i < selectedRowsIndex.length; i++) {
        if (selectedRowsIndex[i]) {
          NguoiDung.xoa(dsNguoiDung[i].id).then((value) {
            if (value) {
              setState(() {
                dsNguoiDung.remove(dsNguoiDung[i]);
                selectedRowsIndex[i] = false;
                createTable();
              });
            } else {
              showNotify(context, "Xóa người dùng thất bại");
            }
          });
        }
      }
    }
  }
}

class NguoiDungDataTableSource extends DataTableSource {
  List<NguoiDung> dsNguoiDung = [];
  List<bool> selectedRowIndexs = [];
  void Function(int) notifyParent;
  NguoiDungDataTableSource({
    required this.dsNguoiDung,
    required this.selectedRowIndexs,
    required this.notifyParent,
  });
  @override
  DataRow? getRow(int index) {
    return DataRow2(
      onSelectChanged: (value) {
        selectedRowIndexs[index] = value!;
        notifyListeners();
        notifyParent(index);
      },
      selected: selectedRowIndexs[index],
      cells: [
        DataCell(Text(dsNguoiDung[index].id.toString())),
        DataCell(Text(dsNguoiDung[index].email)),
        DataCell(Text(dsNguoiDung[index].ten)),
        DataCell(Text(dsNguoiDung[index].isNam ? "Nam" : "Nữ")),
        DataCell(Text(dsNguoiDung[index].ngaySinh.toString())),
        DataCell(Text(dsNguoiDung[index].diaChi.toString())),
        DataCell(Text(dsNguoiDung[index].soDienThoai)),
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
