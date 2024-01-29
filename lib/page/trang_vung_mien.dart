import 'package:app_dac_san/class/vung_mien.dart';
import 'package:async_builder/async_builder.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../gui_helper.dart';

class TrangVungMien extends StatefulWidget {
  TrangVungMien({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController tenController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  final PaginatorController pageController = PaginatorController();
  @override
  State<TrangVungMien> createState() => _TrangVungMienState();
}

class _TrangVungMienState extends State<TrangVungMien> {
  // Các danh sách lấy từ API
  List<VungMien> dsVungMien = [];
  List<bool> dsChon = [];

  // Đặc sản hiển thị tạm thời khi thêm và cập nhật
  VungMien? vungMienTam;

  // Các biến để lưu tình trạng thêm hoặc cập nhật của trang
  bool isReadonly = true;
  bool isInsert = false;
  bool isUpdate = false;

  late Future myFuture;

  // Các biến chứa DataTableSource cho các bảng
  late VungMienDataTableSource dataTableSource;

  // Hàm cập nhật bảng vùng miền để truyền vào DacSanDataTableSource
  // Cập nhật danh sách thành phần (trống nếu số vùng miền được chọn khác 1)
  void notifyParent(int index) {
    setState(() {
      widget.tenController.text = dsVungMien[index].ten;
    });
  }

  void taoBang() {
    dataTableSource = VungMienDataTableSource(
      dsVungMien: dsVungMien,
      dsChon: dsChon,
      notifyParent: notifyParent,
    );
  }

  @override
  void initState() {
    myFuture = Future.delayed(const Duration(seconds: 1), () async {
      // Doc danh sách từ API
      dsVungMien = await VungMien.doc();
      // Tạo bảng lưu tình trạng chọn vùng miền theo danh sách vùng miền
      dsChon = dsVungMien.map((e) => false).toList();
      taoBang();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: AsyncBuilder(
        // Quá trình đọc dữ liệu từ API
        future: myFuture,
        // Widget hiển thị trong quá trình đọc dữ liệu từ API
        waiting: (context) => loadingCircle(),
        // Widget hiển thị sau khi đọc dữ liệu từ API thành công
        builder: (context, value) => Column(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 600),
                child: AbsorbPointer(
                  absorbing: isUpdate || isInsert,
                  child: PaginatedDataTable2(
                    controller: widget.pageController,
                    rowsPerPage: 10,
                    header: Row(
                      children: [
                        const Flexible(flex: 1, child: Text("Vùng miền")),
                        const SizedBox(width: 25),
                        Flexible(
                          flex: 1,
                          child: TypeAheadField(
                            controller: widget.textController,
                            builder: (context, controller, focusNode) {
                              return TextField(
                                onSubmitted: (value) {
                                  int slot = dsVungMien.indexWhere(
                                      (element) => element.ten == value);
                                  if (slot != -1) {
                                    widget.pageController.goToRow(slot);
                                    dsChon[slot] = true;
                                  }
                                },
                                controller: widget.textController,
                                focusNode: focusNode,
                                autofocus: false,
                                decoration: roundSearchBarInputDecoration(),
                              );
                            },
                            loadingBuilder: (context) =>
                                loadingCircle(size: 50),
                            emptyBuilder: (context) => const ListTile(
                              title: Text("Không có vùng miền trùng khớp"),
                            ),
                            itemBuilder: (context, item) {
                              return ListTile(
                                title: Text(item.ten),
                              );
                            },
                            onSelected: (value) {
                              int slot = dsVungMien.indexWhere(
                                  (element) => element.ten == value.ten);
                              widget.pageController.goToRow(slot);
                              dsChon[slot] = true;
                            },
                            suggestionsCallback: (search) => dsVungMien
                                .where(
                                    (element) => element.ten.contains(search))
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
                  ),
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
                      Visibility(
                        visible: !isReadonly,
                        child: TextFormField(
                          controller: widget.tenController,
                          validator: (value) => value == null || value.isEmpty
                              ? "Vui lòng nhập tên vùng miền"
                              : null,
                          decoration: roundInputDecoration(
                              "Tên vùng miền", "Nhập tên vùng miền"),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: FilledButton(
                              style: roundButtonStyle(),
                              onPressed: isReadonly || isInsert
                                  ? () => them(context)
                                  : null,
                              child: const Text("Thêm"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            fit: FlexFit.tight,
                            child: FilledButton(
                              style: roundButtonStyle(),
                              onPressed: isReadonly || isUpdate
                                  ? () => capNhat(context)
                                  : null,
                              child: const Text("Cập nhật"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            fit: FlexFit.tight,
                            child: FilledButton(
                              style: roundButtonStyle(),
                              onPressed: isReadonly ? () => xoa(context) : null,
                              child: const Text("Xóa"),
                            ),
                          ),
                          Visibility(
                            visible: !isReadonly,
                            child: Flexible(
                              fit: FlexFit.tight,
                              child: Row(
                                children: [
                                  const SizedBox(width: 10),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    child: FilledButton(
                                      style: roundButtonStyle(),
                                      onPressed: () => huy(),
                                      child: const Text("Hủy"),
                                    ),
                                  ),
                                ],
                              ),
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
        // Widget hiển thị sau khi đọc dữ liệu từ API thất bại
        error: (context, error, stackTrace) =>
            Center(child: Text('Error: $error')),
      ),
    );
  }

  // Hàm để thêm 1 dòng dữ liệu
  void them(BuildContext context) {
    if (isInsert && widget.formKey.currentState!.validate()) {
      // Gọi hàm API thêm vùng miền
      VungMien.them(widget.tenController.text).then(
        (value) {
          if (value != null) {
            // Cập nhật danh sách và bảng vùng miền nếu thành công
            setState(() {
              dsVungMien.add(value);
              dsChon.add(false);
            });
            huy();
          } else {
            showNotify(context, "Thêm vùng miền thất bại");
          }
        },
      );
    } else if (!isInsert) {
      // Gán giá trị cho biến vùng miền tạm
      vungMienTam = VungMien(
        id: -1,
        ten: widget.tenController.text,
      );
      dsVungMien.add(vungMienTam!);
      dsChon.add(true);
      taoBang();
      // Cập nhật tình trạng thêm của trang
      setState(() {
        isReadonly = !isReadonly;
        isInsert = !isInsert;
      });
    }
  }

  // Hàm để cập nhật 1 dòng dữ liệu
  void capNhat(BuildContext context) {
    // Kiểm tra nếu số dòng đã chọn bằng 1
    if (dsChon.where((element) => element).length == 1) {
      // Kiếm tra tình trạng cập nhật
      if (isUpdate) {
        // Kiểm tra các dữ liệu đầu vào hợp lệ
        if (widget.formKey.currentState!.validate()) {
          int i = dsChon.indexOf(true);
          VungMien vungMien =
              VungMien(id: dsVungMien[i].id, ten: widget.tenController.text);
          // Gọi hàm API Cập nhật đặc sàn
          VungMien.capNhat(vungMien).then((value) {
            if (value) {
              // Cập nhật danh sách và bảng đặc sán nếu thành công
              setState(() {
                dsVungMien[i] = vungMien;
                taoBang();
              });
            } else {
              showNotify(context, "Cập nhật vùng miền thất bại");
            }
          });
          setState(() {
            isReadonly = !isReadonly;
            isUpdate = !isUpdate;
          });
        }
      } else {
        setState(() {
          // Gán dữ liệu các thuộc tính của vùng miền vào các trường dữ liệu đẩu vào
          vungMienTam = dsVungMien[dsChon.indexOf(true)];
          widget.tenController.text = vungMienTam!.ten;

          // Cập nhật tình trạng cập nhật của trang
          isReadonly = !isReadonly;
          isUpdate = !isUpdate;
        });
      }
    } else {
      showNotify(context, "Vui lòng chỉ chọn một dòng để cập nhật");
    }
  }

  void xoa(BuildContext context) {
    for (int i = 0; i < dsChon.length; i++) {
      if (dsChon[i]) {
        VungMien.xoa(dsVungMien[i].id).then((value) {
          if (value) {
            setState(() {
              dsVungMien.remove(dsVungMien[i]);
              dsChon[i] = false;
              taoBang();
            });
          } else {
            showNotify(context, "Xóa vùng miền thất bại");
          }
        });
      }
    }
  }

  Future<void> huy() async {
    if (isInsert) {
      int v = dsVungMien.indexOf(vungMienTam!);
      dsVungMien.remove(dsVungMien[v]);
      dsChon.remove(dsChon[v]);
    } else if (isUpdate) {
      int v = dsVungMien.indexOf(vungMienTam!);
      dsVungMien[v] = await VungMien.docTheoID(vungMienTam!.id);
      dsChon[v] = false;
    }
    setState(() {
      isReadonly = true;
      isInsert = false;
      isUpdate = false;
      taoBang();
    });
  }
}

class VungMienDataTableSource extends DataTableSource {
  List<VungMien> dsVungMien = [];
  List<bool> dsChon = [];
  void Function(int) notifyParent;
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
        notifyParent(index);
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
