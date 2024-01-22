import 'package:app_dac_san/class/phuong_xa.dart';
import 'package:app_dac_san/class/quan_huyen.dart';
import 'package:app_dac_san/class/tinh_thanh.dart';
import 'package:async_builder/async_builder.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:date_field/date_field.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../class/dia_chi.dart';
import '../class/nguoi_dung.dart';
import '../gui_helper.dart';

class TrangNguoiDung extends StatefulWidget {
  TrangNguoiDung({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController tenController = TextEditingController();
  final TextEditingController soDienThoaiController = TextEditingController();
  final TextEditingController soNhaController = TextEditingController();
  final TextEditingController tenDuongController = TextEditingController();
  @override
  State<TrangNguoiDung> createState() => _TrangNguoiDungState();
}

class _TrangNguoiDungState extends State<TrangNguoiDung> {
  // Các danh sách lấy từ API
  List<NguoiDung> dsNguoiDung = [];
  List<TinhThanh> dsTinhThanh = [];
  List<QuanHuyen> dsQuanHuyen = [];
  List<PhuongXa> dsPhuongXa = [];

  List<bool> dsChon = [];

  // Các biến tạm thời
  NguoiDung? nguoiDungTam;
  TinhThanh? tinhThanh;
  QuanHuyen? quanHuyen;
  PhuongXa? phuongXa;
  DateTime ngaySinh = DateTime.now();
  bool isNam = true;

  // Các biến để lưu tình trạng thêm hoặc cập nhật của trang
  bool isReadonly = true;
  bool isInsert = false;
  bool isUpdate = false;

  late NguoiDungDataTableSource dataTableSource;
  late Future myFuture;

  void notifyParent(int index) {
    setState(() {});
  }

  void taoBang() {
    dataTableSource = NguoiDungDataTableSource(
      dsNguoiDung: dsNguoiDung,
      dsChon: dsChon,
      notifyParent: notifyParent,
    );
  }

  @override
  void initState() {
    myFuture = Future.delayed(const Duration(seconds: 1), () async {
      dsNguoiDung = await NguoiDung.doc();
      dsTinhThanh = await TinhThanh.doc();
      dsChon = dsNguoiDung.map((e) => false).toList();
      taoBang();
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
                child: AbsorbPointer(
                  absorbing: isUpdate || isInsert,
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
                              controller: widget.emailController,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? "Vui lòng nhập email"
                                      : null,
                              decoration: roundInputDecoration(
                                  "Địa chỉ email", "Nhập địa chỉ email"),
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: widget.tenController,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? "Vui lòng nhập tên người dùng"
                                      : null,
                              decoration: roundInputDecoration(
                                  "Tên người dùng", "Nhập tên người dùng"),
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: widget.soDienThoaiController,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? "Vui lòng nhập số điện thoại"
                                      : null,
                              decoration: roundInputDecoration(
                                  "Số điện thoại", "Nhập số điện thoại"),
                            ),
                            const SizedBox(height: 15),
                            DateTimeFormField(
                              mode: DateTimeFieldPickerMode.date,
                              decoration: roundInputDecoration(
                                  "Ngày sinh người dùng", ""),
                              dateFormat: DateFormat("dd/MM/yyyy"),
                              initialPickerDateTime: DateTime.now(),
                              onChanged: (value) =>
                                  value != null ? ngaySinh = value : null,
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: RadioListTile(
                                    title: const Text("Nam"),
                                    value: true,
                                    groupValue: isNam,
                                    onChanged: (value) => isNam = value!,
                                  ),
                                ),
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: RadioListTile(
                                    title: const Text("Nữ"),
                                    value: false,
                                    groupValue: isNam,
                                    onChanged: (value) => isNam = value!,
                                  ),
                                ),
                              ],
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
                            const SizedBox(height: 15),
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

  // Hàm để thêm 1 dòng dữ liệu
  void them(BuildContext context) {
    // Kiếm tra tình trạng cập nhật và các dữ liệu đầu vào hợp lệ
    if (isInsert &&
        widget.formKey.currentState!.validate() &&
        phuongXa != null) {
      print(ngaySinh.toUtc().toIso8601String());
      // Gọi hàm API thêm đặc sàn
      NguoiDung.them(NguoiDung(
        id: 0,
        ten: widget.tenController.text,
        email: widget.emailController.text,
        isNam: isNam,
        ngaySinh: ngaySinh,
        soDienThoai: widget.soDienThoaiController.text,
        diaChi: DiaChi(
            id: 0,
            soNha: widget.soNhaController.text,
            tenDuong: widget.tenDuongController.text,
            phuongXa: phuongXa!),
      )).then((value) {
        if (value != null) {
          // Cập nhật danh sách và bảng đặc sán nếu thành công
          setState(() {
            dsNguoiDung.add(value);
            dsChon.add(false);
          });
          huy();
        } else {
          showNotify(context, "Thêm nơi bán thất bại");
        }
      });
    } else if (!isInsert) {
      dsChon.setAll(0, dsChon.map((e) => false));
      taoBang();
      // Gán giá trị cho biến tạm
      phuongXa = PhuongXa(
          id: 00,
          ten: "Phường xã",
          quanHuyen:
              QuanHuyen(id: 0, ten: "", tinhThanh: TinhThanh(id: 0, ten: "")));
      nguoiDungTam = NguoiDung(
        id: -1,
        ten: "",
        email: "",
        isNam: true,
        ngaySinh: DateTime.now(),
        soDienThoai: '',
        diaChi: DiaChi(id: 0, soNha: "", tenDuong: "", phuongXa: phuongXa!),
      );
      dsNguoiDung.add(nguoiDungTam!);
      dsChon.add(true);
      // Cập nhật tình trạng thêm của trang
      setState(() {
        isReadonly = !isReadonly;
        isInsert = !isInsert;
      });
      taoBang();
    }
  }

  // Hàm để cập nhật 1 dòng dữ liệu
  void capNhat(BuildContext context) {
    // Kiểm tra nếu số dòng đã chọn bằng 1
    if (dsChon.where((element) => element).length == 1) {
      // Kiếm tra tình trạng cập nhật
      if (isUpdate) {
        // Kiểm tra các dữ liệu đầu vào hợp lệ
        if (widget.formKey.currentState!.validate() && phuongXa != null) {
          int i = dsChon.indexOf(true);
          NguoiDung nguoiDung = NguoiDung(
            id: dsNguoiDung[i].id,
            ten: widget.tenController.text,
            email: widget.emailController.text,
            isNam: isNam,
            ngaySinh: ngaySinh,
            soDienThoai: widget.soDienThoaiController.text,
            diaChi: DiaChi(
                id: dsNguoiDung[i].diaChi.id,
                soNha: widget.soNhaController.text,
                tenDuong: widget.tenDuongController.text,
                phuongXa: phuongXa!),
          );

          // Gọi hàm API Cập nhật đặc sàn
          NguoiDung.capNhat(nguoiDung).then((value) {
            // Cập nhật danh sách và bảng đặc sán nếu thành công
            if (value) {
              setState(() {
                dsNguoiDung[i] = nguoiDung;
                taoBang();
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
          NguoiDung temp = dsNguoiDung[dsChon.indexOf(true)];
          widget.tenController.text = temp.ten;
          widget.emailController.text = temp.email;
          isNam = temp.isNam;
          ngaySinh = temp.ngaySinh;
          widget.soDienThoaiController.text = temp.soDienThoai;
          widget.soNhaController.text = temp.diaChi.soNha;
          widget.tenDuongController.text = temp.diaChi.tenDuong;
          phuongXa = temp.diaChi.phuongXa;
          quanHuyen = temp.diaChi.phuongXa.quanHuyen;
          tinhThanh = temp.diaChi.phuongXa.quanHuyen.tinhThanh;

          // Gán giá trị cho biến nơi bán tạm
          nguoiDungTam = temp;

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
    for (int i = 0; i < dsChon.length; i++) {
      if (dsChon[i]) {
        // Gọi hàm API xóa đặc sàn
        NguoiDung.xoa(dsNguoiDung[i].id).then((value) {
          if (value) {
            // Cập nhật danh sách và bảng đặc sán nếu thành công
            setState(() {
              dsNguoiDung.remove(dsNguoiDung[i]);
              dsChon[i] = false;
              taoBang();
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
      int v = dsNguoiDung.indexOf(nguoiDungTam!);
      dsNguoiDung.remove(dsNguoiDung[v]);
      dsChon.remove(dsChon[v]);
    } else if (isUpdate) {
      int v = dsNguoiDung.indexOf(nguoiDungTam!);
      dsNguoiDung[v] = await NguoiDung.docTheoID(nguoiDungTam!.id);
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

class NguoiDungDataTableSource extends DataTableSource {
  List<NguoiDung> dsNguoiDung = [];
  List<bool> dsChon = [];
  void Function(int) notifyParent;
  NguoiDungDataTableSource({
    required this.dsNguoiDung,
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
