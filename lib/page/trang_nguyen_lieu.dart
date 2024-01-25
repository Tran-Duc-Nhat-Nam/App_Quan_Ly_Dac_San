import 'package:app_dac_san/class/nguyen_lieu.dart';
import 'package:async_builder/async_builder.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../gui_helper.dart';

class TrangNguyenLieu extends StatefulWidget {
  TrangNguyenLieu({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController tenController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  final PaginatorController pageController = PaginatorController();
  @override
  State<TrangNguyenLieu> createState() => _TrangNguyenLieuState();
}

class _TrangNguyenLieuState extends State<TrangNguyenLieu> {
  // Các danh sách lấy từ API
  List<NguyenLieu> dsNguyenLieu = [];
  List<bool> dsChon = [];

  // Đặc sản hiển thị tạm thời khi thêm và cập nhật
  NguyenLieu? nguyenLieuTam;

  // Các biến để lưu tình trạng thêm hoặc cập nhật của trang
  bool isReadonly = true;
  bool isInsert = false;
  bool isUpdate = false;

  late Future myFuture;

  // Các biến chứa DataTableSource cho các bảng
  late NguyenLieuDataTableSource dataTableSource;

  // Hàm cập nhật bảng nguyên liệu để truyền vào DacSanDataTableSource
  // Cập nhật danh sách thành phần (trống nếu số nguyên liệu được chọn khác 1)
  void notifyParent(int index) {
    setState(() {
      widget.tenController.text = dsNguyenLieu[index].ten;
    });
  }

  void taoBang() {
    dataTableSource = NguyenLieuDataTableSource(
      dsNguyenLieu: dsNguyenLieu,
      dsChon: dsChon,
      notifyParent: notifyParent,
    );
  }

  @override
  void initState() {
    myFuture = Future.delayed(const Duration(seconds: 1), () async {
      // Doc danh sách từ API
      dsNguyenLieu = await NguyenLieu.doc();
      // Tạo bảng lưu tình trạng chọn nguyên liệu theo danh sách nguyên liệu
      dsChon = dsNguyenLieu.map((e) => false).toList();
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
                        const Flexible(
                            fit: FlexFit.loose, child: Text("Nguyên liệu")),
                        const SizedBox(width: 25),
                        Flexible(
                          fit: FlexFit.tight,
                          child: TypeAheadField(
                            controller: widget.textController,
                            builder: (context, controller, focusNode) {
                              return TextField(
                                onSubmitted: (value) {
                                  int slot = dsNguyenLieu.indexWhere(
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
                              title: Text("Không có nguyên liệu trùng khớp"),
                            ),
                            itemBuilder: (context, item) {
                              return ListTile(
                                title: Text(item.ten),
                              );
                            },
                            onSelected: (value) {
                              int slot = dsNguyenLieu.indexWhere(
                                  (element) => element.ten == value.ten);
                              widget.pageController.goToRow(slot);
                              dsChon[slot] = true;
                            },
                            suggestionsCallback: (search) => dsNguyenLieu
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
                          validator: (value) => textFieldValidator(
                              value, "Vui lòng nhập tên nguyên liệu"),
                          decoration: roundInputDecoration(
                              "Tên nguyên liệu", "Nhập tên nguyên liệu"),
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
      // Gọi hàm API thêm nguyên liệu
      NguyenLieu.them(widget.tenController.text).then(
        (value) {
          if (value != null) {
            // Cập nhật danh sách và bảng nguyên liệu nếu thành công
            setState(() {
              dsNguyenLieu.add(value);
              dsChon.add(false);
              widget.tenController.clear();
            });
            huy();
          } else {
            showNotify(context, "Thêm nguyên liệu thất bại");
          }
        },
      );
    } else if (!isInsert) {
      // Gán giá trị cho biến nguyên liệu tạm
      nguyenLieuTam = NguyenLieu(
        id: -1,
        ten: widget.tenController.text,
      );
      dsNguyenLieu.add(nguyenLieuTam!);
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
          NguyenLieu nguyenLieu = NguyenLieu(
              id: dsNguyenLieu[i].id, ten: widget.tenController.text);
          // Gọi hàm API Cập nhật đặc sàn
          NguyenLieu.capNhat(nguyenLieu).then((value) {
            if (value) {
              // Cập nhật danh sách và bảng đặc sán nếu thành công
              setState(() {
                dsNguyenLieu[i] = nguyenLieu;
                taoBang();
                widget.tenController.clear();
              });
            } else {
              showNotify(context, "Cập nhật nguyên liệu thất bại");
            }
          });
          setState(() {
            isReadonly = !isReadonly;
            isUpdate = !isUpdate;
          });
        }
      } else {
        setState(() {
          // Gán dữ liệu các thuộc tính của nguyên liệu vào các trường dữ liệu đẩu vào
          nguyenLieuTam = dsNguyenLieu[dsChon.indexOf(true)];
          widget.tenController.text = nguyenLieuTam!.ten;

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
        NguyenLieu.xoa(dsNguyenLieu[i].id).then((value) {
          if (value) {
            setState(() {
              dsNguyenLieu.remove(dsNguyenLieu[i]);
              dsChon[i] = false;
              taoBang();
            });
          } else {
            showNotify(context, "Xóa nguyên liệu thất bại");
          }
        });
      }
    }
  }

  Future<void> huy() async {
    if (isInsert) {
      int v = dsNguyenLieu.indexOf(nguyenLieuTam!);
      dsNguyenLieu.remove(dsNguyenLieu[v]);
      dsChon.remove(dsChon[v]);
    } else if (isUpdate) {
      int v = dsNguyenLieu.indexOf(nguyenLieuTam!);
      dsNguyenLieu[v] = await NguyenLieu.docTheoID(nguyenLieuTam!.id);
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

class NguyenLieuDataTableSource extends DataTableSource {
  List<NguyenLieu> dsNguyenLieu = [];
  List<bool> dsChon = [];
  void Function(int) notifyParent;
  NguyenLieuDataTableSource({
    required this.dsNguyenLieu,
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
        DataCell(Text(dsNguyenLieu[index].id.toString())),
        DataCell(Text(dsNguyenLieu[index].ten)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dsNguyenLieu.length;

  @override
  int get selectedRowCount => 0;
}
