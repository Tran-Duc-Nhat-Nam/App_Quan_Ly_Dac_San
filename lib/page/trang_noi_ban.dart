import 'package:app_dac_san/class/dac_san.dart';
import 'package:app_dac_san/class/dia_chi.dart';
import 'package:app_dac_san/class/noi_ban.dart';
import 'package:app_dac_san/class/tinh_thanh.dart';
import 'package:async_builder/async_builder.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../class/phuong_xa.dart';
import '../class/quan_huyen.dart';
import '../gui_helper.dart';

class TrangNoiBan extends StatefulWidget {
  TrangNoiBan({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController tenController = TextEditingController();
  final TextEditingController moTaController = TextEditingController();
  final TextEditingController soNhaController = TextEditingController();
  final TextEditingController tenDuongController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  final PaginatorController noiBanController = PaginatorController();
  @override
  State<TrangNoiBan> createState() => _TrangNoiBanState();
}

class _TrangNoiBanState extends State<TrangNoiBan> {
  // Các danh sách lấy từ API
  List<NoiBan> dsNoiBan = [];
  List<DacSan> dsDacSan = [];
  List<TinhThanh> dsTinhThanh = [];
  List<QuanHuyen> dsQuanHuyen = [];
  List<PhuongXa> dsPhuongXa = [];

  List<bool> dsChonNoiBan = [];
  List<bool> dsChonDacSan = [];

  // Các biến tạm thời
  TinhThanh? tinhThanh;
  QuanHuyen? quanHuyen;
  PhuongXa? phuongXa;
  NoiBan? noiBanTam;
  DacSan? dacSan;

  // Các biến để lưu tình trạng thêm hoặc cập nhật của trang
  bool isReadonly = true;
  bool isInsert = false;
  bool isUpdate = false;

  late Future myFuture;

  late NoiBanDataTableSource bangNoiBan;
  late DacSanDataTableSource bangDacSan;

  void notifyParentNB(int index) async {
    if (dsChonNoiBan[index]) {
      // Nếu dòng này được chọn thì cập nhật thông tin thành phần theo dòng này
      if (dsChonNoiBan.where((element) => element).length > 1) {
        dsDacSan = [];
      } else {
        dsDacSan = await dsNoiBan[index].docDacSan();
      }
      dsChonDacSan = dsDacSan.map((e) => false).toList();
    } else {
      // Nếu dòng này không được chọn thì cập nhật thông tin thành phần theo dòng được chọn khác
      if (dsChonNoiBan.where((element) => element).length == 1) {
        dsDacSan = await dsNoiBan[dsChonNoiBan.indexOf(true)].docDacSan();
      } else {
        dsDacSan = [];
      }
      dsChonDacSan = dsDacSan.map((e) => false).toList();
    }
    setState(() {
      taoBangDacSan();
    });
  }

  void notifyParentDS(int index) {
    setState(() {
      dacSan = dsDacSan[index];
    });
  }

  void taoBangNoiBan() {
    bangNoiBan = NoiBanDataTableSource(
      dsNoiBan: dsNoiBan,
      dsChon: dsChonNoiBan,
      notifyParent: notifyParentNB,
    );
  }

  void taoBangDacSan() {
    bangDacSan = DacSanDataTableSource(
      dsDacSan: dsDacSan,
      dsChon: dsChonDacSan,
      notifyParent: notifyParentDS,
    );
  }

  @override
  void initState() {
    myFuture = Future.delayed(const Duration(seconds: 1), () async {
      dsNoiBan = await NoiBan.doc();
      dsTinhThanh = await TinhThanh.doc();
      dsChonNoiBan = dsNoiBan.map((e) => false).toList();
      taoBangNoiBan();
      taoBangDacSan();
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
                child: Row(
                  children: [
                    Flexible(
                      flex: 4,
                      child: AbsorbPointer(
                        absorbing: isUpdate || isInsert,
                        child: PaginatedDataTable2(
                          controller: widget.noiBanController,
                          rowsPerPage: 10,
                          header: Row(
                            children: [
                              const Flexible(flex: 1, child: Text("Nơi bán")),
                              const SizedBox(width: 25),
                              Flexible(
                                flex: 1,
                                child: TypeAheadField(
                                  controller: widget.textController,
                                  builder: (context, controller, focusNode) {
                                    return TextField(
                                      onSubmitted: (value) {
                                        int slot = dsDacSan.indexWhere(
                                            (element) => element.ten == value);
                                        if (slot != -1) {
                                          widget.noiBanController.goToRow(slot);
                                          dsChonNoiBan[slot] = true;
                                        }
                                      },
                                      controller: widget.textController,
                                      focusNode: focusNode,
                                      autofocus: false,
                                      decoration:
                                          roundSearchBarInputDecoration(),
                                    );
                                  },
                                  loadingBuilder: (context) =>
                                      loadingCircle(size: 50),
                                  emptyBuilder: (context) => const ListTile(
                                    title: Text("Không có nơi bán trùng khớp"),
                                  ),
                                  itemBuilder: (context, item) {
                                    return ListTile(
                                      title: Text(item.ten),
                                    );
                                  },
                                  onSelected: (value) {
                                    int slot = dsDacSan.indexWhere(
                                        (element) => element.ten == value.ten);
                                    widget.noiBanController.goToRow(slot);
                                    dsChonNoiBan[slot] = true;
                                  },
                                  suggestionsCallback: (search) => dsDacSan
                                      .where((element) =>
                                          element.ten.contains(search))
                                      .toList(),
                                ),
                              )
                            ],
                          ),
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
                          source: bangNoiBan,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: PaginatedDataTable2(
                        empty: Center(
                          child: Text(
                              dsChonDacSan.where((element) => element).length >
                                      1
                                  ? "Vui lòng chỉ chọn một dòng dữ liệu"
                                  : "Không có dữ liệu đặc sản của nơi này"),
                        ),
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
                        ],
                        source: bangDacSan,
                      ),
                    ),
                  ],
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
                        child: Column(
                          children: [
                            TextFormField(
                              controller: widget.tenController,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? "Vui lòng nhập tên nơi bán"
                                      : null,
                              decoration: roundInputDecoration(
                                  "Tên nơi bán", "Nhập tên nơi bán"),
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: widget.moTaController,
                              decoration: roundInputDecoration(
                                  "Mô tả nơi bán", "Nhập thông tin mô tả"),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: DropdownSearch<TinhThanh>(
                                    validator: (value) => value == null
                                        ? "Vui lòng chọn tỉnh thành"
                                        : null,
                                    popupProps: const PopupProps.menu(
                                      title: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Center(
                                          child: Text(
                                            "Danh sách tỉnh thành",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      showSelectedItems: true,
                                    ),
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                      dropdownSearchDecoration:
                                          roundInputDecoration(
                                              "Tỉnh thành", ""),
                                    ),
                                    compareFn: (item1, item2) => item1 == item2,
                                    onChanged: (value) => value != null
                                        ? tinhThanh = value
                                        : null,
                                    items: dsTinhThanh,
                                    itemAsString: (value) => value.ten,
                                    selectedItem: tinhThanh,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: DropdownSearch<QuanHuyen>(
                                    validator: (value) => value == null
                                        ? "Vui lòng chọn quận huyện"
                                        : null,
                                    popupProps: const PopupProps.menu(
                                      title: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Center(
                                          child: Text(
                                            "Danh sách quận huyện",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      showSelectedItems: true,
                                    ),
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                      dropdownSearchDecoration:
                                          roundInputDecoration(
                                              "Quận huyện", ""),
                                    ),
                                    compareFn: (item1, item2) => item1 == item2,
                                    onBeforePopupOpening:
                                        (selectedItem) async =>
                                            Future(() => tinhThanh != null),
                                    onChanged: (value) => value != null
                                        ? quanHuyen = value
                                        : null,
                                    asyncItems: (text) => tinhThanh != null
                                        ? QuanHuyen.doc(tinhThanh!.id)
                                        : Future(() => []),
                                    itemAsString: (value) => value.ten,
                                    selectedItem: quanHuyen,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: DropdownSearch<PhuongXa>(
                                    validator: (value) => value == null
                                        ? "Vui lòng chọn phường xã"
                                        : null,
                                    popupProps: const PopupProps.menu(
                                      title: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Center(
                                          child: Text(
                                            "Danh sách phường xã",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      showSelectedItems: true,
                                    ),
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                      dropdownSearchDecoration:
                                          roundInputDecoration("Phường xã", ""),
                                    ),
                                    compareFn: (item1, item2) => item1 == item2,
                                    onBeforePopupOpening:
                                        (selectedItem) async =>
                                            Future(() => quanHuyen != null),
                                    onChanged: (value) =>
                                        value != null ? phuongXa = value : null,
                                    asyncItems: (text) => quanHuyen != null
                                        ? PhuongXa.doc(quanHuyen!.id)
                                        : Future(() => []),
                                    itemAsString: (value) => value.ten,
                                    selectedItem: phuongXa,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: widget.soNhaController,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? "Vui lòng nhập số nhà"
                                      : null,
                              decoration:
                                  roundInputDecoration("Số nhà", "Nhập số nhà"),
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: widget.tenDuongController,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? "Vui lòng nhập tên đường"
                                      : null,
                              decoration: roundInputDecoration(
                                  "Tên đường", "Nhập tên đường"),
                            ),
                          ],
                        ),
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
                          const SizedBox(width: 10),
                          Flexible(
                            fit: FlexFit.tight,
                            child: FilledButton(
                              style: roundButtonStyle(),
                              onPressed: () => capNhat(context),
                              child: const Text("Cập nhật"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            fit: FlexFit.tight,
                            child: FilledButton(
                              style: roundButtonStyle(),
                              onPressed: () => xoa(context),
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
        error: (context, error, stackTrace) =>
            Center(child: Text('Error: $error')),
      ),
    );
  }

  // Hàm để thêm 1 dòng dữ liệu
  void them(BuildContext context) {
    // Kiếm tra tình trạng cập nhật và các dữ liệu đầu vào hợp lệ
    if (isInsert &&
        widget.formKey.currentState!.validate() &&
        phuongXa != null) {
      // Gọi hàm API thêm đặc sàn
      NoiBan.them(NoiBan(
        id: 0,
        ten: widget.tenController.text,
        moTa: widget.moTaController.text,
        diaChi: DiaChi(
            id: 0,
            soNha: widget.soNhaController.text,
            tenDuong: widget.tenDuongController.text,
            phuongXa: phuongXa!),
      )).then((value) {
        if (value != null) {
          // Cập nhật danh sách và bảng đặc sán nếu thành công
          setState(() {
            dsNoiBan.add(value);
            dsChonNoiBan.add(false);
          });
          huy();
        } else {
          showNotify(context, "Thêm nơi bán thất bại");
        }
      });
    } else if (!isInsert) {
      dsChonNoiBan.setAll(0, dsChonNoiBan.map((e) => false));
      taoBangNoiBan();
      // Gán giá trị cho biến tạm
      phuongXa = PhuongXa(
          id: 00,
          ten: "Phường xã",
          quanHuyen:
              QuanHuyen(id: 0, ten: "", tinhThanh: TinhThanh(id: 0, ten: "")));
      noiBanTam = NoiBan(
        id: -1,
        ten: "",
        moTa: "",
        diaChi: DiaChi(id: 0, soNha: "", tenDuong: "", phuongXa: phuongXa!),
      );
      dsNoiBan.add(noiBanTam!);
      dsChonNoiBan.add(true);
      // Cập nhật tình trạng thêm của trang
      setState(() {
        isReadonly = !isReadonly;
        isInsert = !isInsert;
      });
      taoBangNoiBan();
    }
  }

  // Hàm để cập nhật 1 dòng dữ liệu
  void capNhat(BuildContext context) {
    // Kiểm tra nếu số dòng đã chọn bằng 1
    if (dsChonNoiBan.where((element) => element).length == 1) {
      // Kiếm tra tình trạng cập nhật
      if (isUpdate) {
        // Kiểm tra các dữ liệu đầu vào hợp lệ
        if (widget.formKey.currentState!.validate() && phuongXa != null) {
          int i = dsChonNoiBan.indexOf(true);
          NoiBan noiBan = NoiBan(
            id: dsNoiBan[i].id,
            ten: widget.tenController.text,
            moTa: widget.moTaController.text,
            diaChi: DiaChi(
                id: dsNoiBan[i].diaChi.id,
                soNha: widget.soNhaController.text,
                tenDuong: widget.tenDuongController.text,
                phuongXa: phuongXa!),
          );

          // Gọi hàm API Cập nhật đặc sàn
          NoiBan.capNhat(noiBan).then((value) {
            // Cập nhật danh sách và bảng đặc sán nếu thành công
            if (value) {
              setState(() {
                dsNoiBan[i] = noiBan;
                taoBangNoiBan();
              });
            } else {
              showNotify(context, "Cập nhật nơi bán thất bại");
            }
          });
          setState(() {
            isReadonly = !isReadonly;
            isUpdate = !isUpdate;
          });
        }
      } else {
        setState(() {
          // Gán dữ liệu các thuộc tính của nơi bán vào các trường dữ liệu đẩu vào
          NoiBan temp = dsNoiBan[dsChonNoiBan.indexOf(true)];
          widget.tenController.text = temp.ten;
          widget.moTaController.text = temp.moTa ?? "Chưa có thông tin";
          widget.soNhaController.text = temp.diaChi.soNha;
          widget.tenDuongController.text = temp.diaChi.tenDuong;
          phuongXa = temp.diaChi.phuongXa;
          quanHuyen = temp.diaChi.phuongXa.quanHuyen;
          tinhThanh = temp.diaChi.phuongXa.quanHuyen.tinhThanh;

          // Gán giá trị cho biến nơi bán tạm
          noiBanTam = temp;

          // Cập nhật tình trạng cập nhật của trang
          isReadonly = !isReadonly;
          isUpdate = !isUpdate;
        });
      }
    } else {
      showNotify(context, "Vui lòng chỉ chọn một dòng để cập nhật");
    }
  }

  // Hàm để xóa các dòng dữ liệu
  void xoa(BuildContext context) {
    for (int i = 0; i < dsChonNoiBan.length; i++) {
      if (dsChonNoiBan[i]) {
        // Gọi hàm API xóa đặc sàn
        NoiBan.xoa(dsNoiBan[i].id).then((value) {
          if (value) {
            // Cập nhật danh sách và bảng đặc sán nếu thành công
            setState(() {
              dsNoiBan.remove(dsNoiBan[i]);
              dsChonNoiBan[i] = false;
              taoBangNoiBan();
            });
          } else {
            showNotify(context, "Xóa nơi bán thất bại");
          }
        });
      }
    }
  }

  // Hàm để húy bỏ quá trình thêm hoặc cập nhật
  Future<void> huy() async {
    if (isInsert) {
      int v = dsNoiBan.indexOf(noiBanTam!);
      dsNoiBan.remove(dsNoiBan[v]);
      dsChonNoiBan.remove(dsChonNoiBan[v]);
    } else if (isUpdate) {
      int v = dsNoiBan.indexOf(noiBanTam!);
      dsNoiBan[v] = await NoiBan.docTheoID(noiBanTam!.id);
      dsChonNoiBan[v] = false;
    }
    setState(() {
      isReadonly = true;
      isInsert = false;
      isUpdate = false;
      taoBangNoiBan();
    });
  }
}

class NoiBanDataTableSource extends DataTableSource {
  List<NoiBan> dsNoiBan = [];
  List<bool> dsChon = [];
  void Function(int) notifyParent;
  NoiBanDataTableSource({
    required this.dsNoiBan,
    required this.dsChon,
    required this.notifyParent,
  });
  @override
  DataRow? getRow(int index) {
    return DataRow2(
      onSelectChanged: (value) {
        dsChon[index] = value!;
        notifyListeners();
        notifyParent(index);
      },
      selected: dsChon[index],
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

class DacSanDataTableSource extends DataTableSource {
  List<DacSan> dsDacSan = [];
  List<bool> dsChon = [];
  void Function(int) notifyParent;
  DacSanDataTableSource({
    required this.dsDacSan,
    required this.dsChon,
    required this.notifyParent,
  });
  @override
  DataRow? getRow(int index) {
    return DataRow2(
      onSelectChanged: (value) {
        dsChon[index] = value!;
        notifyListeners();
        notifyParent(index);
      },
      selected: dsChon[index],
      cells: [
        DataCell(Text(dsDacSan[index].id.toString())),
        DataCell(Text(dsDacSan[index].ten)),
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
