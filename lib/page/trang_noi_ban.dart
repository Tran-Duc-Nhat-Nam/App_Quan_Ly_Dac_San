import 'package:app_dac_san/model/dia_chi.dart';
import 'package:app_dac_san/model/noi_ban.dart';
import 'package:app_dac_san/model/tinh_thanh.dart';
import 'package:async_builder/async_builder.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../model/phuong_xa.dart';
import '../model/quan_huyen.dart';

class TrangNoiBan extends StatefulWidget {
  TrangNoiBan({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController tenController = TextEditingController();
  final TextEditingController moTaController = TextEditingController();
  final TextEditingController soNhaController = TextEditingController();
  final TextEditingController tenDuongController = TextEditingController();
  @override
  State<TrangNoiBan> createState() => _TrangNoiBanState();
}

class _TrangNoiBanState extends State<TrangNoiBan> {
  List<NoiBan> dsNoiBan = [];
  List<TinhThanh> dsTinhThanh = [];
  List<QuanHuyen> dsQuanHuyen = [];
  List<PhuongXa> dsPhuongXa = [];
  List<bool> selectedRowsIndex = [];
  TinhThanh? tinhThanh;
  QuanHuyen? quanHuyen;
  PhuongXa? phuongXa;
  late NoiBanDataTableSource dataTableSource;
  late Future myFuture;

  void showNotify(BuildContext context, String content) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(content)));
  }

  void notifyParent(int index) {
    setState(() {
      widget.tenController.text = dsNoiBan[index].ten;
      widget.moTaController.text = dsNoiBan[index].moTa ?? "Chưa có thông tin";
    });
  }

  void createTable() {
    dataTableSource = NoiBanDataTableSource(
      dsNoiBan: dsNoiBan,
      selectedRowIndexs: selectedRowsIndex,
      notifyParent: notifyParent,
    );
  }

  @override
  void initState() {
    myFuture = Future.delayed(const Duration(seconds: 1), () async {
      dsNoiBan = await NoiBan.doc();
      dsTinhThanh = await TinhThanh.doc();
      selectedRowsIndex = dsNoiBan.map((e) => false).toList();
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
                            return "Vui lòng nhập tên nơi bán";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsetsDirectional.only(
                              start: 25,
                              top: 15,
                              bottom: 15,
                            ),
                            label: const Text("Tên nơi bán"),
                            hintText: "Nhập tên nơi bán",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            )),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: widget.moTaController,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsetsDirectional.only(
                              start: 25,
                              top: 15,
                              bottom: 15,
                            ),
                            label: const Text("Mô tả nơi bán"),
                            hintText: "Nhập thông tin mô tả",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            )),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: DropdownSearch<TinhThanh>(
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
                                  contentPadding:
                                      const EdgeInsetsDirectional.only(
                                    start: 25,
                                    top: 15,
                                    bottom: 15,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                              compareFn: (item1, item2) {
                                return item1 == item2;
                              },
                              onChanged: (value) async {
                                if (value != null) {
                                  tinhThanh = value;
                                }
                              },
                              items: dsTinhThanh,
                              itemAsString: (value) {
                                return value.ten;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            fit: FlexFit.tight,
                            child: DropdownSearch<QuanHuyen>(
                              validator: (value) {
                                if (value == null) {
                                  return "Vui lòng chọn quận huyện";
                                }
                                return null;
                              },
                              popupProps: const PopupProps.menu(
                                title: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Center(
                                    child: Text(
                                      "Danh sách quận huyện",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                showSelectedItems: true,
                              ),
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  label: const Text("Quận huyện"),
                                  contentPadding:
                                      const EdgeInsetsDirectional.only(
                                    start: 25,
                                    top: 15,
                                    bottom: 15,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                              compareFn: (item1, item2) {
                                return item1 == item2;
                              },
                              onBeforePopupOpening: (selectedItem) async {
                                return Future(() => tinhThanh != null);
                              },
                              onChanged: (value) {
                                if (value != null) {
                                  quanHuyen = value;
                                }
                              },
                              asyncItems: (text) {
                                if (tinhThanh != null) {
                                  return QuanHuyen.doc(tinhThanh!.id);
                                }
                                return Future(() => []);
                              },
                              itemAsString: (value) {
                                return value.ten;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            fit: FlexFit.tight,
                            child: DropdownSearch<PhuongXa>(
                              validator: (value) {
                                if (value == null) {
                                  return "Vui lòng chọn phường xã";
                                }
                                return null;
                              },
                              popupProps: const PopupProps.menu(
                                title: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Center(
                                    child: Text(
                                      "Danh sách phường xã",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                showSelectedItems: true,
                              ),
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  label: const Text("Phường xã"),
                                  contentPadding:
                                      const EdgeInsetsDirectional.only(
                                    start: 25,
                                    top: 15,
                                    bottom: 15,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                              compareFn: (item1, item2) {
                                return item1 == item2;
                              },
                              onBeforePopupOpening: (selectedItem) async {
                                return Future(() => quanHuyen != null);
                              },
                              onChanged: (value) {
                                if (value != null) {
                                  phuongXa = value;
                                }
                              },
                              asyncItems: (text) {
                                if (quanHuyen != null) {
                                  return PhuongXa.doc(quanHuyen!.id);
                                }
                                return Future(() => []);
                              },
                              itemAsString: (value) {
                                return value.ten;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: widget.soNhaController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng nhập số nhà";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsetsDirectional.only(
                              start: 25,
                              top: 15,
                              bottom: 15,
                            ),
                            label: const Text("Số nhà"),
                            hintText: "Nhập số nhà",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            )),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: widget.tenDuongController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng nhập tên đường";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsetsDirectional.only(
                              start: 25,
                              top: 15,
                              bottom: 15,
                            ),
                            label: const Text("Tên đường"),
                            hintText: "Nhập tên đường",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            )),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: FilledButton(
                              style: const ButtonStyle(
                                  padding: MaterialStatePropertyAll(
                                EdgeInsetsDirectional.only(
                                  start: 25,
                                  top: 25,
                                  bottom: 25,
                                ),
                              )),
                              onPressed: () => them(context),
                              child: const Text("Thêm"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            fit: FlexFit.tight,
                            child: FilledButton(
                              style: const ButtonStyle(
                                  padding: MaterialStatePropertyAll(
                                EdgeInsetsDirectional.only(
                                  start: 25,
                                  top: 25,
                                  bottom: 25,
                                ),
                              )),
                              onPressed: () => capNhat(context),
                              child: const Text("Cập nhật"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            fit: FlexFit.tight,
                            child: FilledButton(
                              style: const ButtonStyle(
                                  padding: MaterialStatePropertyAll(
                                EdgeInsetsDirectional.only(
                                  start: 25,
                                  top: 25,
                                  bottom: 25,
                                ),
                              )),
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
      NoiBan.them(
        widget.tenController.text,
        widget.moTaController.text,
        DiaChi(
          id: 0,
          soNha: widget.soNhaController.text,
          tenDuong: widget.tenDuongController.text,
          phuongXa: phuongXa!,
        ),
      ).then(
        (value) {
          if (value != null) {
            setState(() {
              dsNoiBan.add(value);
              selectedRowsIndex.add(false);
              createTable();
            });
          } else {
            showNotify(context, "Thêm nơi bán thất bại");
          }
        },
      );
    }
  }

  void capNhat(BuildContext context) {
    if (widget.formKey.currentState!.validate()) {
      if (selectedRowsIndex.where((element) => element).length == 1) {
        int i = selectedRowsIndex.indexOf(true);
        NoiBan noiBan = NoiBan(
          id: dsNoiBan[i].id,
          ten: widget.tenController.text,
          moTa: widget.moTaController.text,
          diaChi: DiaChi(
            id: dsNoiBan[i].diaChi.id,
            soNha: dsNoiBan[i].diaChi.soNha,
            tenDuong: dsNoiBan[i].diaChi.tenDuong,
            phuongXa: phuongXa!,
          ),
        );
        NoiBan.capNhat(noiBan).then(
          (value) {
            if (value) {
              setState(() {
                dsNoiBan[i] = noiBan;
                createTable();
              });
            } else {
              showNotify(context, "Cập nhật nơi bán thất bại");
            }
          },
        );
      } else {
        showNotify(context, "Vui lòng chỉ chọn một dòng để cập nhật");
      }
    }
  }

  void xoa(BuildContext context) {
    if (widget.formKey.currentState!.validate()) {
      for (int i = 0; i < selectedRowsIndex.length; i++) {
        if (selectedRowsIndex[i]) {
          NoiBan.xoa(dsNoiBan[i].id).then((value) {
            if (value) {
              setState(() {
                dsNoiBan.remove(dsNoiBan[i]);
                selectedRowsIndex[i] = false;
                createTable();
              });
            } else {
              showNotify(context, "Xóa nơi bán thất bại");
            }
          });
        }
      }
    }
  }
}

class NoiBanDataTableSource extends DataTableSource {
  List<NoiBan> dsNoiBan = [];
  List<bool> selectedRowIndexs = [];
  void Function(int) notifyParent;
  NoiBanDataTableSource({
    required this.dsNoiBan,
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
