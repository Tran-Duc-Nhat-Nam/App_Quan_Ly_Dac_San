import 'package:data_table_2/data_table_2.dart';
import 'package:date_field/date_field.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/gui_helper.dart';
import '../../tinh_thanh/bloc/tinh_thanh_bloc.dart' as tt_bloc;
import '../../tinh_thanh/data/dia_chi.dart';
import '../../tinh_thanh/data/phuong_xa.dart';
import '../../tinh_thanh/data/quan_huyen.dart';
import '../../tinh_thanh/data/tinh_thanh.dart';
import '../bloc/nguoi_dung_bloc.dart';
import '../data/nguoi_dung.dart';
import 'bang_nguoi_dung.dart';

class TrangNguoiDung extends StatefulWidget {
  TrangNguoiDung({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController tenController = TextEditingController();
  final TextEditingController soDienThoaiController = TextEditingController();
  final TextEditingController soNhaController = TextEditingController();
  final TextEditingController tenDuongController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  final PaginatorController pageController = PaginatorController();

  @override
  State<TrangNguoiDung> createState() => _TrangNguoiDungState();
}

class _TrangNguoiDungState extends State<TrangNguoiDung> {
  List<bool> dsChon = [];

  // Hàm cập nhật bảng người dùng để truyền vào DacSanDataTableSource
  void notifyParent(List<bool> list) {
    dsChon = list;
  }

  late Future<List<QuanHuyen>> futureDocQuanHuyen;
  late Future<List<PhuongXa>> futureDocPhuongXa;
  bool isNam = true;
  TinhThanh? tinhThanh;
  QuanHuyen? quanHuyen;
  PhuongXa? phuongXa;
  DateTime ngaySinh = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => NguoiDungBloc()..add(LoadDataEvent())),
        BlocProvider(
            create: (context) =>
                tt_bloc.TinhThanhBloc()..add(tt_bloc.LoadTinhThanhEvent())),
      ],
      child: Flexible(
        flex: 1,
        child: BlocBuilder<NguoiDungBloc, NguoiDungState>(
          // Widget hiển thị sau khi đọc dữ liệu từ API thành công
          builder: (context, state) {
            if (state is NguoiDungInitial) {
              return loadingCircle();
            } else if (state is NguoiDungLoaded) {
              TextEditingController tenController = TextEditingController();
              dsChon = state.dsChon;
              if (dsChon.where((element) => element).toList().length == 1) {
                tenController.text = state
                    .dsNguoiDung[dsChon.indexWhere((element) => element)].ten;
              }

              if (state.errorMessage != null) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  showNotify(context, state.errorMessage!);
                });
              }

              return Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 600),
                      child: AbsorbPointer(
                        absorbing: state.isUpdate || state.isInsert,
                        child: BangNguoiDung(
                            widget: widget,
                            dsNguoiDung: state.dsNguoiDung,
                            dsChon: dsChon,
                            dataTableSource: NguoiDungDataTableSource(
                              dsNguoiDung: state.dsNguoiDung,
                              dsChon: dsChon,
                              notifyParent: notifyParent,
                            )),
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
                              visible: state.isInsert || state.isUpdate,
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
                                        "Tên người dùng",
                                        "Nhập tên người dùng"),
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
                                          onChanged: (value) => setState(() {
                                            isNam = value!;
                                          }),
                                        ),
                                      ),
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: RadioListTile(
                                          title: const Text("Nữ"),
                                          value: false,
                                          groupValue: isNam,
                                          onChanged: (value) => setState(() {
                                            isNam = value!;
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      BlocBuilder<tt_bloc.TinhThanhBloc,
                                          tt_bloc.TinhThanhState>(
                                        builder: (context, state) {
                                          if (state
                                              is tt_bloc.TinhThanhInitial) {
                                            return loadingCircle(size: 25);
                                          } else if (state
                                              is tt_bloc.TinhThanhLoaded) {
                                            return Flexible(
                                              fit: FlexFit.tight,
                                              child: DropdownSearch<TinhThanh>(
                                                validator: (value) => value ==
                                                        null
                                                    ? "Vui lòng chọn tỉnh thành"
                                                    : null,
                                                popupProps:
                                                    const PopupProps.menu(
                                                  title: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    child: Center(
                                                      child: Text(
                                                        "Danh sách tỉnh thành",
                                                        style: TextStyle(
                                                            fontSize: 16),
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
                                                compareFn: (item1, item2) =>
                                                    item1 == item2,
                                                onChanged: (value) {
                                                  if (value != null) {
                                                    tinhThanh = value;
                                                    futureDocQuanHuyen =
                                                        QuanHuyen.doc(
                                                            tinhThanh!.id);
                                                  }
                                                },
                                                items: state.dsTinhThanh,
                                                itemAsString: (value) =>
                                                    value.ten,
                                                selectedItem: tinhThanh,
                                              ),
                                            );
                                          } else {
                                            return const Text("Error");
                                          }
                                        },
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
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: Center(
                                                child: Text(
                                                  "Danh sách quận huyện",
                                                  style:
                                                      TextStyle(fontSize: 16),
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
                                          compareFn: (item1, item2) =>
                                              item1 == item2,
                                          onBeforePopupOpening:
                                              (selectedItem) async => Future(
                                                  () => tinhThanh != null),
                                          onChanged: (value) {
                                            if (value != null) {
                                              quanHuyen = value;
                                              futureDocPhuongXa =
                                                  PhuongXa.doc(quanHuyen!.id);
                                            }
                                          },
                                          asyncItems: (text) =>
                                              futureDocQuanHuyen,
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
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: Center(
                                                child: Text(
                                                  "Danh sách phường xã",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ),
                                            ),
                                            showSelectedItems: true,
                                          ),
                                          dropdownDecoratorProps:
                                              DropDownDecoratorProps(
                                            dropdownSearchDecoration:
                                                roundInputDecoration(
                                                    "Phường xã", ""),
                                          ),
                                          compareFn: (item1, item2) =>
                                              item1 == item2,
                                          onBeforePopupOpening:
                                              (selectedItem) async => Future(
                                                  () => quanHuyen != null),
                                          onChanged: (value) => value != null
                                              ? phuongXa = value
                                              : null,
                                          asyncItems: (text) =>
                                              futureDocPhuongXa,
                                          itemAsString: (value) => value.ten,
                                          selectedItem: phuongXa,
                                        ),
                                      ), //
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  TextFormField(
                                    controller: widget.soNhaController,
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? "Vui lòng nhập số nhà"
                                            : null,
                                    decoration: roundInputDecoration(
                                        "Số nhà", "Nhập số nhà"),
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
                                    onPressed: !state.isUpdate
                                        ? () {
                                            if (state.isInsert &&
                                                widget.formKey.currentState!
                                                    .validate()) {
                                              // Gọi hàm API thêm người dùng
                                              context
                                                  .read<NguoiDungBloc>()
                                                  .add(InsertEvent(NguoiDung(
                                                    id: -1,
                                                    ten: widget
                                                        .tenController.text,
                                                    email: widget
                                                        .emailController.text,
                                                    isNam: isNam,
                                                    ngaySinh: ngaySinh,
                                                    soDienThoai: widget
                                                        .soDienThoaiController
                                                        .text,
                                                    diaChi: DiaChi(
                                                        id: -1,
                                                        soNha: widget
                                                            .soNhaController
                                                            .text,
                                                        tenDuong: widget
                                                            .tenDuongController
                                                            .text,
                                                        phuongXa: phuongXa!),
                                                  )));
                                            } else if (!state.isInsert) {
                                              // Gán giá trị cho biến người dùng tạm
                                              context
                                                  .read<NguoiDungBloc>()
                                                  .add(StartInsertEvent());
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
                                    onPressed: !state.isInsert
                                        ? () {
                                            if (dsChon
                                                    .where((element) => element)
                                                    .length !=
                                                1) {
                                              showNotify(context,
                                                  "Vui lòng chỉ chọn một dòng để cập nhật");
                                              return;
                                            }
                                            if (state.isUpdate) {
                                              // Kiểm tra các dữ liệu đầu vào hợp lệ
                                              if (widget.formKey.currentState!
                                                  .validate()) {
                                                context
                                                    .read<NguoiDungBloc>()
                                                    .add(UpdateEnvent(NguoiDung(
                                                      id: state
                                                          .dsNguoiDung[dsChon
                                                              .indexOf(true)]
                                                          .id,
                                                      ten: widget
                                                          .tenController.text,
                                                      email: widget
                                                          .emailController.text,
                                                      isNam: isNam,
                                                      ngaySinh: ngaySinh,
                                                      soDienThoai: widget
                                                          .soDienThoaiController
                                                          .text,
                                                      diaChi: DiaChi(
                                                          id: state
                                                              .dsNguoiDung[
                                                                  dsChon
                                                                      .indexOf(
                                                                          true)]
                                                              .diaChi
                                                              .id,
                                                          soNha: widget
                                                              .soNhaController
                                                              .text,
                                                          tenDuong: widget
                                                              .tenDuongController
                                                              .text,
                                                          phuongXa: phuongXa!),
                                                    )));
                                              }
                                            } else {
                                              setState(() {
                                                // Gán dữ liệu các thuộc tính của người dùng vào các trường dữ liệu đẩu vào
                                                context
                                                    .read<NguoiDungBloc>()
                                                    .add(StartUpdateEvent(state
                                                            .dsNguoiDung[
                                                        dsChon.indexOf(true)]));
                                              });
                                            }
                                          }
                                        : null,
                                    child: const Text("Cập nhật"),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: FilledButton(
                                    style: roundButtonStyle(),
                                    onPressed:
                                        !state.isUpdate && !state.isInsert
                                            ? () {
                                                context
                                                    .read<NguoiDungBloc>()
                                                    .add(DeleteEvent(dsChon));
                                              }
                                            : null,
                                    child: const Text("Xóa"),
                                  ),
                                ),
                                Visibility(
                                  visible: state.isInsert || state.isUpdate,
                                  child: Flexible(
                                    fit: FlexFit.tight,
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 10),
                                        Flexible(
                                          fit: FlexFit.tight,
                                          child: FilledButton(
                                            style: roundButtonStyle(),
                                            onPressed: () => context
                                                .read<NguoiDungBloc>()
                                                .add(StopEditEvent()),
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
              );
            } else {
              return const Placeholder();
            }
          },
        ),
      ),
    );
  }
}
