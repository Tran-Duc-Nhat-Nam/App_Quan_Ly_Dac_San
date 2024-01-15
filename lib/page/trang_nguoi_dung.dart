import 'package:app_dac_san/model/tinh_thanh.dart';
import 'package:async_builder/async_builder.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:date_field/date_field.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
  List<bool> selectedRowsIndex = [];
  late TinhThanh tinhThanh;
  DateTime ngaySinh = DateTime.now();
  bool isNam = true;
  late NguoiDungDataTableSource dataTableSource;
  late Future myFuture;

  void showNotify(BuildContext context, String content) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(content)));
  }

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
        waiting: (context) => Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingAnimationWidget.discreteCircle(
                  color: Colors.cyan, size: 100),
            ],
          ),
        ),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng nhập tên người dùng";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            label: const Text("Tên người dùng"),
                            hintText: "Nhập tên người dùng",
                            contentPadding: const EdgeInsetsDirectional.only(
                              start: 25,
                              top: 15,
                              bottom: 15,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35),
                            )),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: widget.soDienThoaiController,
                        decoration: InputDecoration(
                            label: const Text("Mô tả người dùng"),
                            hintText: "Nhập thông tin mô tả",
                            contentPadding: const EdgeInsetsDirectional.only(
                              start: 25,
                              top: 15,
                              bottom: 15,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35),
                            )),
                      ),
                      const SizedBox(height: 15),
                      DateTimeFormField(
                        decoration: InputDecoration(
                          label: const Text("Ngày sinh người dùng"),
                          contentPadding: const EdgeInsetsDirectional.only(
                            start: 25,
                            top: 15,
                            bottom: 15,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                        ),
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
                        validator: (value) {
                          if (value == null) {
                            return "Vui lòng chọn tỉnh thành";
                          }
                          return null;
                        },
                        popupProps: const PopupProps.menu(
                          title: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: Text(
                                "Danh sách tỉnh thành",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          showSelectedItems: true,
                        ),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            label: const Text("Tỉnh thành"),
                            contentPadding: const EdgeInsetsDirectional.only(
                              start: 25,
                              top: 15,
                              bottom: 15,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35),
                            ),
                          ),
                        ),
                        compareFn: (item1, item2) {
                          return item1 == item2;
                        },
                        onChanged: (value) {
                          if (value != null) {
                            tinhThanh = value;
                          }
                        },
                        items: dsTinhThanh,
                        itemAsString: (value) {
                          return value.ten;
                        },
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: FilledButton(
                              onPressed: () => them(context),
                              child: const Text("Thêm"),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Flexible(
                            fit: FlexFit.tight,
                            child: FilledButton(
                              onPressed: () => capNhat(context),
                              child: const Text("Cập nhật"),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Flexible(
                            fit: FlexFit.tight,
                            child: FilledButton(
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
          phuongXa: "phuongXa",
          quanHuyen: "quanHuyen",
          tinhThanh: tinhThanh,
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
            quanHuyen: dsNguoiDung[i].diaChi.quanHuyen,
            tinhThanh: tinhThanh,
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
