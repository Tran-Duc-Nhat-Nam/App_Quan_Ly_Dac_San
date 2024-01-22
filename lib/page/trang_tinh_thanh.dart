import 'package:async_builder/async_builder.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../class/tinh_thanh.dart';
import '../gui_helper.dart';

class TrangTinhThanh extends StatefulWidget {
  TrangTinhThanh({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController tenController = TextEditingController();
  @override
  State<TrangTinhThanh> createState() => _TrangTinhThanhState();
}

class _TrangTinhThanhState extends State<TrangTinhThanh> {
  // Các danh sách lấy từ API
  List<TinhThanh> dsTinhThanh = [];
  List<bool> dsChon = [];

  // Đặc sản hiển thị tạm thời khi thêm và cập nhật
  TinhThanh? tinhThanhTam;

  // Các biến để lưu tình trạng thêm hoặc cập nhật của trang
  bool isReadonly = true;
  bool isInsert = false;
  bool isUpdate = false;

  late Future myFuture;

  // Các biến chứa DataTableSource cho các bảng
  late TinhThanhDataTableSource dataTableSource;

  // Hàm cập nhật bảng tỉnh thành để truyền vào DacSanDataTableSource
  // Cập nhật danh sách thành phần (trống nếu số tỉnh thành được chọn khác 1)
  void notifyParent(int index) {
    setState(() {
      widget.tenController.text = dsTinhThanh[index].ten;
    });
  }

  void taoBang() {
    dataTableSource = TinhThanhDataTableSource(
      dsTinhThanh: dsTinhThanh,
      dsChon: dsChon,
      notifyParent: notifyParent,
    );
  }

  @override
  void initState() {
    myFuture = Future.delayed(const Duration(seconds: 1), () async {
      // Doc danh sách từ API
      dsTinhThanh = await TinhThanh.doc();
      // Tạo bảng lưu tình trạng chọn tỉnh thành theo danh sách tỉnh thành
      dsChon = dsTinhThanh.map((e) => false).toList();
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
                    rowsPerPage: 10,
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
                              ? "Vui lòng nhập tên tỉnh thành"
                              : null,
                          decoration: roundInputDecoration(
                              "Tên tỉnh thành", "Nhập tên tỉnh thành"),
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
      // Gọi hàm API thêm tỉnh thành
      TinhThanh.them(widget.tenController.text).then(
        (value) {
          if (value != null) {
            // Cập nhật danh sách và bảng tỉnh thành nếu thành công
            setState(() {
              dsTinhThanh.add(value);
              dsChon.add(false);
            });
            huy();
          } else {
            showNotify(context, "Thêm tỉnh thành thất bại");
          }
        },
      );
    } else if (!isInsert) {
      // Gán giá trị cho biến tỉnh thành tạm
      tinhThanhTam = TinhThanh(
        id: -1,
        ten: widget.tenController.text,
      );
      dsTinhThanh.add(tinhThanhTam!);
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
          TinhThanh tinhThanh =
              TinhThanh(id: dsTinhThanh[i].id, ten: widget.tenController.text);
          // Gọi hàm API Cập nhật đặc sàn
          TinhThanh.capNhat(tinhThanh).then((value) {
            if (value) {
              // Cập nhật danh sách và bảng đặc sán nếu thành công
              setState(() {
                dsTinhThanh[i] = tinhThanh;
                taoBang();
              });
            } else {
              showNotify(context, "Cập nhật tỉnh thành thất bại");
            }
          });
          setState(() {
            isReadonly = !isReadonly;
            isUpdate = !isUpdate;
          });
        }
      } else {
        setState(() {
          // Gán dữ liệu các thuộc tính của tỉnh thành vào các trường dữ liệu đẩu vào
          tinhThanhTam = dsTinhThanh[dsChon.indexOf(true)];
          widget.tenController.text = tinhThanhTam!.ten;

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
        TinhThanh.xoa(dsTinhThanh[i].id).then((value) {
          if (value) {
            setState(() {
              dsTinhThanh.remove(dsTinhThanh[i]);
              dsChon[i] = false;
              taoBang();
            });
          } else {
            showNotify(context, "Xóa tỉnh thành thất bại");
          }
        });
      }
    }
  }

  Future<void> huy() async {
    if (isInsert) {
      int v = dsTinhThanh.indexOf(tinhThanhTam!);
      dsTinhThanh.remove(dsTinhThanh[v]);
      dsChon.remove(dsChon[v]);
    } else if (isUpdate) {
      int v = dsTinhThanh.indexOf(tinhThanhTam!);
      dsTinhThanh[v] = await TinhThanh.docTheoID(tinhThanhTam!.id);
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
