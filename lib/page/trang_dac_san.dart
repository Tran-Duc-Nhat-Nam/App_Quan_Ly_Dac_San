import 'package:app_dac_san/model/tinh_thanh.dart';
import 'package:async_builder/async_builder.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../model/dac_san.dart';

class TrangDacSan extends StatefulWidget {
  TrangDacSan({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController tenController = TextEditingController();
  final TextEditingController moTaController = TextEditingController();
  final TextEditingController cachCheBienController = TextEditingController();
  @override
  State<TrangDacSan> createState() => _TrangDacSanState();
}

class _TrangDacSanState extends State<TrangDacSan> {
  List<DacSan> dsDacSan = [];
  List<TinhThanh> dsTinhThanh = [];
  List<bool> selectedRowsIndex = [];
  late TinhThanh tinhThanh;
  late DacSanDataTableSource dataTableSource;
  late Future myFuture;

  void showNotify(BuildContext context, String content) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(content)));
  }

  void notifyParent(int index) {
    setState(() {
      widget.tenController.text = dsDacSan[index].ten;
      widget.moTaController.text = dsDacSan[index].moTa ?? "Chưa có thông tin";
    });
  }

  void createTable() {
    dataTableSource = DacSanDataTableSource(
      dsDacSan: dsDacSan,
      selectedRowIndexs: selectedRowsIndex,
      notifyParent: notifyParent,
    );
  }

  @override
  void initState() {
    myFuture = Future.delayed(const Duration(seconds: 1), () async {
      dsDacSan = await DacSan.doc();
      dsTinhThanh = await TinhThanh.doc();
      selectedRowsIndex = dsDacSan.map((e) => false).toList();
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
                            return "Vui lòng nhập tên đặc sản";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            label: const Text("Tên đặc sản"),
                            hintText: "Nhập tên đặc sản",
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
                        controller: widget.moTaController,
                        decoration: InputDecoration(
                            label: const Text("Mô tả đặc sản"),
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
                      TextFormField(
                        controller: widget.cachCheBienController,
                        decoration: InputDecoration(
                            label: const Text("Cách chế biến đặc sản"),
                            hintText: "Nhập thông tin chế biến",
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
      DacSan.them(
        widget.tenController.text,
        widget.moTaController.text,
        widget.cachCheBienController.text,
      ).then((value) {
        if (value != null) {
          setState(() {
            dsDacSan.add(value);
            selectedRowsIndex.add(false);
            widget.tenController.clear();
            widget.moTaController.clear();
            widget.cachCheBienController.clear();
            createTable();
          });
        } else {
          showNotify(context, "Thêm đặc sản thất bại");
        }
      });
    }
  }

  void capNhat(BuildContext context) {
    if (widget.formKey.currentState!.validate()) {
      if (selectedRowsIndex.where((element) => element).length == 1) {
        int i = selectedRowsIndex.indexOf(true);
        DacSan dacSan = DacSan(
          id: dsDacSan[i].id,
          ten: widget.tenController.text,
          moTa: widget.moTaController.text,
          cachCheBien: widget.cachCheBienController.text,
        );
        DacSan.capNhat(dacSan).then((value) {
          if (value) {
            setState(() {
              dsDacSan[i] = dacSan;
              createTable();
            });
          } else {
            showNotify(context, "Cập nhật đặc sản thất bại");
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
          DacSan.xoa(dsDacSan[i].id).then((value) {
            if (value) {
              setState(() {
                dsDacSan.remove(dsDacSan[i]);
                selectedRowsIndex[i] = false;
                createTable();
              });
            } else {
              showNotify(context, "Xóa đặc sản thất bại");
            }
          });
        }
      }
    }
  }
}

class DacSanDataTableSource extends DataTableSource {
  List<DacSan> dsDacSan = [];
  List<bool> selectedRowIndexs = [];
  void Function(int) notifyParent;
  DacSanDataTableSource({
    required this.dsDacSan,
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
        DataCell(Text(dsDacSan[index].id.toString())),
        DataCell(Text(dsDacSan[index].ten)),
        DataCell(Text(dsDacSan[index].moTa ?? "Chưa có thông tin")),
        DataCell(Text(dsDacSan[index].cachCheBien ?? "Chưa có thông tin")),
        DataCell(Text(dsDacSan[index].luotXem.toString())),
        DataCell(Text(dsDacSan[index].diemDanhGia.toString())),
        DataCell(Text(dsDacSan[index].luotDanhGia.toString())),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dsDacSan.length;

  @override
  int get selectedRowCount => 0;
}
