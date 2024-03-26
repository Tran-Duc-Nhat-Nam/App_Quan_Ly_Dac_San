import 'dart:developer';

import 'package:app_dac_san/features/dac_san/data/dac_san.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/gui_helper.dart';
import '../../tinh_thanh/bloc/tinh_thanh_bloc.dart' as tt_bloc;
import '../../tinh_thanh/data/dia_chi.dart';
import '../../tinh_thanh/data/phuong_xa.dart';
import '../../tinh_thanh/data/quan_huyen.dart';
import '../../tinh_thanh/data/tinh_thanh.dart';
import '../bloc/noi_ban_bloc.dart';
import '../data/noi_ban.dart';
import 'bang_dac_san.dart';
import 'bang_noi_ban.dart';

class TrangNoiBan extends StatefulWidget {
  TrangNoiBan({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController tenController = TextEditingController();
  final TextEditingController moTaController = TextEditingController();
  final TextEditingController soNhaController = TextEditingController();
  final TextEditingController tenDuongController = TextEditingController();
  final TextEditingController textNoiBanController = TextEditingController();
  final PaginatorController noiBanController = PaginatorController();

  @override
  State<TrangNoiBan> createState() => _TrangNoiBanState();
}

class _TrangNoiBanState extends State<TrangNoiBan> {
  List<bool> dsChonDacSan = [];

  // Các biến tạm để lưu thông tin khi thêm và cập nhật
  DacSan? dacSan;

  late Future<List<QuanHuyen>> futureDocQuanHuyen;
  late Future<List<PhuongXa>> futureDocPhuongXa;
  TinhThanh? tinhThanh;
  QuanHuyen? quanHuyen;
  PhuongXa? phuongXa;

  // Hàm cập nhật bảng đặc sản để truyền vào NoiBanDataTableSource
  void notifyParentDS(BuildContext context, int index) {
    context.read<NoiBanBloc>().add(LoadDacSanEvent(index));
  }

  void notifyParentTP(List<bool> list) {
    dsChonDacSan = list;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NoiBanBloc()..add(LoadNoiBanEvent()),
        ),
        BlocProvider(
          create: (context) =>
              tt_bloc.TinhThanhBloc()..add(tt_bloc.LoadTinhThanhEvent()),
        ),
      ],
      child: BlocBuilder<NoiBanBloc, NoiBanState>(
        // Widget hiển thị sau khi đọc dữ liệu từ API thành công
        builder: (context, state) {
          if (state is NoiBanInitial) {
            return loadingCircle();
          } else if (state is NoiBanLoaded) {
            log(state.noiBanTam.dsDacSan.length.toString());

            if (state.errorMessage != null) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                showNotify(context, state.errorMessage!);
              });
            }

            if (state.isInsert) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                widget.noiBanController.goToRow(state.dsChonNoiBan.length - 1);
              });
            }

            if (state.isUpdate) {
              widget.tenController.text = state.noiBanTam.ten;
              widget.moTaController.text = state.noiBanTam.moTa ?? "";
              widget.soNhaController.text = state.noiBanTam.diaChi.soNha;
              widget.tenDuongController.text = state.noiBanTam.diaChi.tenDuong;
              tinhThanh = state.noiBanTam.diaChi.phuongXa.quanHuyen.tinhThanh;
              quanHuyen = state.noiBanTam.diaChi.phuongXa.quanHuyen;
              phuongXa = state.noiBanTam.diaChi.phuongXa;
            }

            return Column(
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 600,
                    child: Row(
                      children: [
                        Flexible(
                          flex: 3,
                          child: AbsorbPointer(
                            absorbing: state.isUpdate || state.isInsert,
                            child: BangNoiBan(
                                widget: widget,
                                dsNoiBan: BlocProvider.of<NoiBanBloc>(context)
                                    .dsNoiBan,
                                dsChon: state.dsChonNoiBan,
                                duLieuNoiBan: NoiBanDataTableSource(
                                  dsNoiBan: BlocProvider.of<NoiBanBloc>(context)
                                      .dsNoiBan,
                                  dsChon: state.dsChonNoiBan,
                                  context: context,
                                  notifyParent: notifyParentDS,
                                )),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: BangDacSan(
                              dsChonNoiBan: state.dsChonNoiBan,
                              bangDacSan: DacSanDataTableSource(
                                dsChon: state.dsChonDacSan,
                                dsDacSan: state.dsDacSan,
                                notifyParent: notifyParentTP,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height - 600),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Form(
                        key: widget.formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Visibility(
                                visible: state.isInsert || state.isUpdate,
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
                                          "Mô tả nơi bán",
                                          "Nhập thông tin mô tả"),
                                    ),
                                    // Trường mô tả nơi bán
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
                                                child:
                                                    DropdownSearch<TinhThanh>(
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
                                    // Khu vực chứa cá trường chọn tỉnh thành, quận huyện, phường xã
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
                                            validator: (value) => state
                                                    .noiBanTam.dsDacSan.isEmpty
                                                ? "Vui lòng thêm ít nhất 1 đặc sản"
                                                : null,
                                            popupProps: const PopupProps.menu(
                                              title: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                child: Center(
                                                  child: Text(
                                                    "Danh sách đặc sản",
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                              showSelectedItems: true,
                                              showSearchBox: true,
                                            ),
                                            dropdownDecoratorProps:
                                                DropDownDecoratorProps(
                                              dropdownSearchDecoration:
                                                  roundInputDecoration(
                                                      "Đặc sản", ""),
                                            ),
                                            compareFn: (item1, item2) =>
                                                item1 == item2,
                                            onChanged: (value) => value != null
                                                ? dacSan = value
                                                : null,
                                            selectedItem: dacSan,
                                            asyncItems: (text) => Future(() =>
                                                BlocProvider.of<NoiBanBloc>(
                                                        context)
                                                    .dsDacSan
                                                    .where((element) => element
                                                        .ten
                                                        .contains(text))
                                                    .toList()),
                                            itemAsString: (value) => value.ten,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Flexible(
                                          fit: FlexFit.tight,
                                          child: FilledButton(
                                            style: roundButtonStyle(),
                                            onPressed: () {
                                              if (dacSan != null) {
                                                context.read<NoiBanBloc>().add(
                                                    AddDacSanEvent(dacSan!));
                                              } else {
                                                showNotify(context,
                                                    "Vui lòng chọn đặc sản");
                                              }
                                            },
                                            child: const Text("Thêm"),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Flexible(
                                          fit: FlexFit.tight,
                                          child: FilledButton(
                                            style: roundButtonStyle(),
                                            onPressed: () {
                                              if (dacSan != null) {
                                                context.read<NoiBanBloc>().add(
                                                    RemoveDacSanEvent(dacSan!));
                                              } else {
                                                showNotify(context,
                                                    "Vui lòng chọn đặc sản");
                                              }
                                            },
                                            child: const Text("Xóa"),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Khu vực chọn đặc sản của nơi bán
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
                                                // Gọi hàm API thêm đặc sản
                                                context
                                                    .read<NoiBanBloc>()
                                                    .add(InsertEvent(
                                                      widget.tenController.text,
                                                      DiaChi(
                                                          id: -1,
                                                          soNha: widget
                                                              .soNhaController
                                                              .text,
                                                          tenDuong: widget
                                                              .tenDuongController
                                                              .text,
                                                          phuongXa: phuongXa!),
                                                      moTa: widget
                                                          .moTaController.text,
                                                    ));
                                              } else if (!state.isInsert) {
                                                // Gán giá trị cho biến đặc sản tạm
                                                context
                                                    .read<NoiBanBloc>()
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
                                              if (state.dsChonNoiBan
                                                      .where(
                                                          (element) => element)
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
                                                  NoiBan temp = BlocProvider
                                                              .of<NoiBanBloc>(
                                                                  context)
                                                          .dsNoiBan[
                                                      state.dsChonDacSan
                                                          .indexOf(true)];
                                                  context.read<NoiBanBloc>().add(
                                                      UpdateEnvent(NoiBan(
                                                          id: temp.id,
                                                          ten:
                                                              widget
                                                                  .tenController
                                                                  .text,
                                                          diaChi: DiaChi(
                                                              id:
                                                                  temp.diaChi
                                                                      .id,
                                                              soNha: widget
                                                                  .soNhaController
                                                                  .text,
                                                              tenDuong: widget
                                                                  .tenDuongController
                                                                  .text,
                                                              phuongXa:
                                                                  phuongXa!),
                                                          dsDacSan: state
                                                              .noiBanTam
                                                              .dsDacSan)));
                                                }
                                              } else {
                                                context.read<NoiBanBloc>().add(
                                                    StartUpdateEvent(BlocProvider
                                                                .of<NoiBanBloc>(
                                                                    context)
                                                            .dsNoiBan[
                                                        state.dsChonNoiBan
                                                            .indexOf(true)]));
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
                                                      .read<NoiBanBloc>()
                                                      .add(DeleteEvent(
                                                          state.dsChonNoiBan));
                                                }
                                              : null,
                                      child: const Text("Xóa"),
                                    ),
                                  ),
                                  Visibility(
                                    visible: state.isUpdate || state.isInsert,
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
                                                  .read<NoiBanBloc>()
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
                  ),
                ),
              ],
            );
          } else {
            return const Placeholder();
          }
        },
      ),
    );
  }
}
