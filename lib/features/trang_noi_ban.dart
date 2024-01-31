import 'package:app_dac_san/class/dac_san.dart';
import 'package:app_dac_san/class/dia_chi.dart';
import 'package:app_dac_san/class/noi_ban.dart';
import 'package:app_dac_san/features/tinh_thanh/data/tinh_thanh.dart';
import 'package:async_builder/async_builder.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../class/phuong_xa.dart';
import '../class/quan_huyen.dart';
import '../core/gui_helper.dart';

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
  List<DacSan> dsDacSanNoiBan = [];
  List<DacSan> dsDacSan = [];
  List<TinhThanh> dsTinhThanh = [];
  List<QuanHuyen> dsQuanHuyen = [];
  List<PhuongXa> dsPhuongXa = [];
  List<bool> dsChonNoiBan = [];
  List<bool> dsChonDacSanNoiBan = [];

  // Các biến tạm thời
  TinhThanh? tinhThanh;
  QuanHuyen? quanHuyen;
  PhuongXa? phuongXa;
  NoiBan? noiBanTam;
  DacSan? dacSanNoiBan;
  DacSan? dacSan;

  // Các biến để lưu tình trạng thêm hoặc cập nhật của trang
  bool isReadonly = true;
  bool isInsert = false;
  bool isUpdate = false;

  // Các biến Future lưu tiến trình đọc API
  late Future futureDocAPI;
  late Future<List<QuanHuyen>> futureDocQuanHuyen;
  late Future<List<PhuongXa>> futureDocPhuongXa;

  // Datasource
  late NoiBanDataTableSource duLieuBangNoiBan;
  late DacSanDataTableSource duLieuBangDacSan;

  // Cập nhật khi có dòng trong bảng nơi bán được chọn
  void notifyParentNB(int index) async {
    // Nếu tổng số dòng được chọn lớn bằng 1 thì hiển thị bảng đặc sản của nơi bán được chọn
    if (dsChonNoiBan.where((element) => element).length == 1) {
      // Nếu nơi bán được chọn là nơi bán vừa được cập nhật
      if (dsChonNoiBan[index]) {
        dsDacSanNoiBan = await dsNoiBan[index].docDacSan();
      } else {
        dsDacSanNoiBan = await dsNoiBan[dsChonNoiBan.indexOf(true)].docDacSan();
      }
    } else {
      dsDacSanNoiBan = [];
    }
    setState(() {
      dsChonDacSanNoiBan = dsDacSanNoiBan.map((e) => false).toList();
      taoBangDacSan();
    });
  }

  void notifyParentDS(int index) {
    setState(() {
      dacSanNoiBan = dsDacSanNoiBan[index];
    });
  }

  void taoBangNoiBan() {
    duLieuBangNoiBan = NoiBanDataTableSource(
      dsNoiBan: dsNoiBan,
      dsChon: dsChonNoiBan,
      notifyParent: notifyParentNB,
    );
    taoBangDacSan();
  }

  void taoBangDacSan() {
    duLieuBangDacSan = DacSanDataTableSource(
      dsDacSan: dsDacSanNoiBan,
      dsChon: dsChonDacSanNoiBan,
      notifyParent: notifyParentDS,
    );
  }

  @override
  void initState() {
    futureDocAPI = Future.delayed(const Duration(seconds: 1), () async {
      dsNoiBan = await NoiBan.doc();
      dsDacSan = await DacSan.doc();
      dsTinhThanh = await TinhThanh.doc();
      dsChonNoiBan = dsNoiBan.map((e) => false).toList();
      taoBangNoiBan();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: AsyncBuilder(
        future: futureDocAPI,
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
                      child: BangNoiBan(
                          isUpdate: isUpdate,
                          isInsert: isInsert,
                          widget: widget,
                          dsDacSanNoiBan: dsDacSanNoiBan,
                          dsChonNoiBan: dsChonNoiBan,
                          bangNoiBan: duLieuBangNoiBan),
                    ),
                    Flexible(
                      flex: 1,
                      child: BangDacSan(
                          dsChonDacSanNoiBan: dsChonDacSanNoiBan,
                          bangDacSan: duLieuBangDacSan),
                    ),
                  ],
                ),
              ),
            ), // Khu vực chứa bảng dữ liệu
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
                            // Trường tên nơi bán
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: widget.moTaController,
                              decoration: roundInputDecoration(
                                  "Mô tả nơi bán", "Nhập thông tin mô tả"),
                            ),
                            // Trường mô tả nơi bán
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
                                    onChanged: (value) {
                                      if (value != null) {
                                        tinhThanh = value;
                                        futureDocQuanHuyen =
                                            QuanHuyen.doc(tinhThanh!.id);
                                      }
                                    },
                                    items: dsTinhThanh,
                                    itemAsString: (value) => value.ten,
                                    selectedItem: tinhThanh,
                                  ),
                                ), // Trường tỉnh thành
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
                                    onChanged: (value) {
                                      if (value != null) {
                                        quanHuyen = value;
                                        futureDocPhuongXa =
                                            PhuongXa.doc(quanHuyen!.id);
                                      }
                                    },
                                    asyncItems: (text) => futureDocQuanHuyen,
                                    itemAsString: (value) => value.ten,
                                    selectedItem: quanHuyen,
                                  ),
                                ), // Trường quận huyện
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
                                    asyncItems: (text) => futureDocPhuongXa,
                                    itemAsString: (value) => value.ten,
                                    selectedItem: phuongXa,
                                  ),
                                ), // Trường phường xã
                              ],
                            ),
                            // Khu vực chứa cá trường chọn tỉnh thành, quận huyện, phường xã
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
                            // Trường số nhà
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
                            // Trường tên đường
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: DropdownSearch<DacSan>(
                                    validator: (value) => dsDacSanNoiBan.isEmpty
                                        ? "Vui lòng thêm ít nhất 1 đặc sản"
                                        : null,
                                    popupProps: const PopupProps.menu(
                                      title: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Center(
                                          child: Text(
                                            "Danh sách đặc sản",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      showSelectedItems: true,
                                      showSearchBox: true,
                                    ),
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                      dropdownSearchDecoration:
                                          roundInputDecoration("Đặc sản", ""),
                                    ),
                                    compareFn: (item1, item2) => item1 == item2,
                                    onChanged: (value) => value != null
                                        ? dacSanNoiBan = value
                                        : null,
                                    selectedItem: dacSanNoiBan,
                                    asyncItems: (text) => Future(() => dsDacSan
                                        .where((element) =>
                                            element.ten.contains(text))
                                        .toList()),
                                    itemAsString: (value) => value.ten,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: FilledButton(
                                    style: roundButtonStyle(),
                                    onPressed: !isReadonly
                                        ? () {
                                            if (dacSanNoiBan != null) {
                                              setState(() {
                                                dsDacSanNoiBan
                                                    .add(dacSanNoiBan!);
                                                dsChonDacSanNoiBan.add(false);
                                                taoBangDacSan();
                                              });
                                            } else {
                                              showNotify(context,
                                                  "Vui lòng chọn đặc sản");
                                            }
                                          }
                                        : null,
                                    child: const Text("Thêm"),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: FilledButton(
                                    style: roundButtonStyle(),
                                    onPressed: !isReadonly
                                        ? () {
                                            if (dacSanNoiBan != null) {
                                              setState(() {
                                                dsDacSanNoiBan
                                                    .remove(dacSanNoiBan!);
                                                taoBangDacSan();
                                              });
                                            } else {
                                              showNotify(context,
                                                  "Vui lòng chọn đặc sản");
                                            }
                                          }
                                        : null,
                                    child: const Text("Xóa"),
                                  ),
                                ),
                              ],
                            ),
                            // Khu vực chọn đặc sản của nơi bán
                          ],
                        ),
                      ), // Khu vực chứa các trường dữ liệu đầu vào
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
                      ), // Khu vực chứa các nút
                    ],
                  ),
                ),
              ),
            ), // Khu vực chứa các trường dữ liệu đầu vào và các nút
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
              dsDacSan: dsDacSanNoiBan.map((e) => e.id).toList()))
          .then((value) {
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
      // Hủy chọn toàn bộ bảng nơi bán
      dsChonNoiBan.setAll(0, dsChonNoiBan.map((e) => false));
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
          dsDacSan: []);
      // Cập nhật tình trạng thêm của trang
      setState(() {
        dsNoiBan.add(noiBanTam!);
        dsChonNoiBan.add(true);
        dsDacSanNoiBan = [];
        dsChonDacSanNoiBan = [];
        isReadonly = !isReadonly;
        isInsert = !isInsert;
        taoBangNoiBan();
      });
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
            dsDacSan: [],
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
      // Nếu đang thêm thì xóa dòng mới tạm thêm
      int v = dsNoiBan.indexOf(noiBanTam!);
      dsNoiBan.remove(dsNoiBan[v]);
      dsChonNoiBan.remove(dsChonNoiBan[v]);
    } else if (isUpdate) {
      // Nếu đăng cập nhật thì đọc lại thông tin dòng đang cập nhật
      int v = dsNoiBan.indexOf(noiBanTam!);
      dsNoiBan[v] = await NoiBan.docTheoID(noiBanTam!.id);
      dsChonNoiBan[v] = false;
    }
    // Xóa thông tin đầu vào trong các trường
    setState(() {
      isReadonly = true;
      isInsert = false;
      isUpdate = false;
      dsDacSanNoiBan = [];
      dsChonDacSanNoiBan = [];
      widget.tenController.clear();
      widget.moTaController.clear();
      tinhThanh = null;
      quanHuyen = null;
      phuongXa = null;
      taoBangNoiBan();
    });
  }
}

class BangDacSan extends StatelessWidget {
  const BangDacSan({
    super.key,
    required this.dsChonDacSanNoiBan,
    required this.bangDacSan,
  });

  final List<bool> dsChonDacSanNoiBan;
  final DacSanDataTableSource bangDacSan;

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable2(
      empty: Center(
        child: Text(dsChonDacSanNoiBan.where((element) => element).length > 1
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
    );
  }
}

class BangNoiBan extends StatelessWidget {
  const BangNoiBan({
    super.key,
    required this.isUpdate,
    required this.isInsert,
    required this.widget,
    required this.dsDacSanNoiBan,
    required this.dsChonNoiBan,
    required this.bangNoiBan,
  });

  final bool isUpdate;
  final bool isInsert;
  final TrangNoiBan widget;
  final List<DacSan> dsDacSanNoiBan;
  final List<bool> dsChonNoiBan;
  final NoiBanDataTableSource bangNoiBan;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
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
                      int slot = dsDacSanNoiBan
                          .indexWhere((element) => element.ten == value);
                      if (slot != -1) {
                        widget.noiBanController.goToRow(slot);
                        dsChonNoiBan[slot] = true;
                      }
                    },
                    controller: widget.textController,
                    focusNode: focusNode,
                    autofocus: false,
                    decoration: roundSearchBarInputDecoration(),
                  );
                },
                loadingBuilder: (context) => loadingCircle(size: 50),
                emptyBuilder: (context) => const ListTile(
                  title: Text("Không có nơi bán trùng khớp"),
                ),
                itemBuilder: (context, item) {
                  return ListTile(
                    title: Text(item.ten),
                  );
                },
                onSelected: (value) {
                  int slot = dsDacSanNoiBan
                      .indexWhere((element) => element.ten == value.ten);
                  widget.noiBanController.goToRow(slot);
                  dsChonNoiBan[slot] = true;
                },
                suggestionsCallback: (search) => dsDacSanNoiBan
                    .where((element) => element.ten.contains(search))
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
    );
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
      // Thông báo cho widget cha sự kiện một dòng thay đổi trang thái được chọn
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
