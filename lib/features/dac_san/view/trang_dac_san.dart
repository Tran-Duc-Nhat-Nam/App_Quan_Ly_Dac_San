import 'dart:developer';

import 'package:app_dac_san/features/dac_san/view/bang_dac_san.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/gui_helper.dart';
import '../../../core/widget/drop_down_title.dart';
import '../../mua_dac_san/data/mua_dac_san.dart';
import '../../nguyen_lieu/data/nguyen_lieu.dart';
import '../../vung_mien/data/vung_mien.dart';
import '../bloc/dac_san_bloc.dart';
import '../data/dac_san.dart';
import '../data/hinh_anh.dart';
import '../data/thanh_phan.dart';
import 'bang_thanh_phan.dart';

class TrangDacSan extends StatefulWidget {
  TrangDacSan({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController tenController = TextEditingController();
  final TextEditingController moTaController = TextEditingController();
  final TextEditingController soLuongController = TextEditingController();
  final TextEditingController donViTinhController = TextEditingController();
  final TextEditingController cachCheBienController = TextEditingController();
  final TextEditingController tenHinhAnhController = TextEditingController();
  final TextEditingController moTaHinhAnhController = TextEditingController();
  final TextEditingController urlHinhAnhController = TextEditingController();
  final TextEditingController textDacSanController = TextEditingController();

  final PaginatorController dacSanController = PaginatorController();

  @override
  State<TrangDacSan> createState() => _TrangDacSanState();
}

class _TrangDacSanState extends State<TrangDacSan> {
  List<bool> dsChonThanhPhan = [];

  // Các biến tạm để lưu thông tin khi thêm và cập nhật
  VungMien? vungMien;
  MuaDacSan? muaDacSan;
  NguyenLieu? nguyenLieu;
  HinhAnh? hinhDaiDien;

  // Hàm cập nhật bảng đặc sản để truyền vào DacSanDataTableSource
  void notifyParentDS(BuildContext context, int index) {
    context.read<DacSanBloc>().add(LoadThanhPhanEvent(index));
  }

  void notifyParentTP(List<bool> list) {
    dsChonThanhPhan = list;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DacSanBloc()..add(LoadDacSanEvent()),
      child: BlocBuilder<DacSanBloc, DacSanState>(
        // Widget hiển thị sau khi đọc dữ liệu từ API thành công
        builder: (context, state) {
          if (state is DacSanInitial) {
            return loadingCircle();
          } else if (state is DacSanLoaded) {
            log(state.dacSanTam.vungMien.length.toString());

            if (state.errorMessage != null) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                showNotify(context, state.errorMessage!);
              });
            }

            if (state.isInsert) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                widget.dacSanController.goToRow(state.dsChonDacSan.length - 1);
              });
            }

            if (state.isUpdate) {
              widget.tenController.text = state.dacSanTam.ten;
              widget.moTaController.text = state.dacSanTam.moTa ?? "";
              widget.cachCheBienController.text =
                  state.dacSanTam.cachCheBien ?? "";
            }

            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
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
                              child: BangDacSan(
                                  widget: widget,
                                  dsDacSan: BlocProvider.of<DacSanBloc>(context)
                                      .dsDacSan,
                                  dsChon: state.dsChonDacSan,
                                  duLieuDacSan: DacSanDataTableSource(
                                    dsDacSan:
                                        BlocProvider.of<DacSanBloc>(context)
                                            .dsDacSan,
                                    dsChon: state.dsChonDacSan,
                                    context: context,
                                    notifyParent: notifyParentDS,
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: BangThanhPhan(
                                dsChonDacSan: state.dsChonDacSan,
                                bangThanhPhan: ThanhPhanDataTableSource(
                                  dsChon: state.dsChonThanhPhan,
                                  dsThanhPhan: state.dsThanhPhan,
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
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Column(
                              children: [
                                Visibility(
                                  visible: state.isInsert || state.isUpdate,
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 15),
                                      TextFormField(
                                        controller: widget.tenController,
                                        validator: (value) =>
                                            value == null || value.isEmpty
                                                ? "Vui lòng nhập tên đặc sản"
                                                : null,
                                        decoration: roundInputDecoration(
                                            "Tên đặc sản", "Nhập tên đặc sản"),
                                      ),
                                      const SizedBox(height: 15),
                                      SizedBox(
                                        height: 200,
                                        child: TextFormField(
                                          maxLines: 1000,
                                          textInputAction:
                                              TextInputAction.newline,
                                          keyboardType: TextInputType.multiline,
                                          controller: widget.moTaController,
                                          decoration: roundInputDecoration(
                                              "Mô tả đặc sản",
                                              "Nhập thông tin mô tả"),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      SizedBox(
                                        height: 200,
                                        child: TextFormField(
                                          maxLines: 1000,
                                          textInputAction:
                                              TextInputAction.newline,
                                          keyboardType: TextInputType.multiline,
                                          controller:
                                              widget.cachCheBienController,
                                          decoration: roundInputDecoration(
                                            "Cách chế biến đặc sản",
                                            "Nhập thông tin chế biến",
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: DropdownSearch<VungMien>(
                                              validator: (value) {
                                                if (state.dacSanTam.vungMien
                                                    .isEmpty) {
                                                  return "Vui lòng thêm ít nhất 1 vùng miền";
                                                }
                                                return null;
                                              },
                                              popupProps: const PopupProps.menu(
                                                title: DropDownTitle(
                                                    text:
                                                        "Danh sách vùng miền"),
                                                showSelectedItems: true,
                                              ),
                                              dropdownDecoratorProps:
                                                  DropDownDecoratorProps(
                                                dropdownSearchDecoration:
                                                    roundInputDecoration(
                                                        "Vùng miền", ""),
                                              ),
                                              compareFn: (item1, item2) {
                                                return item1 == item2;
                                              },
                                              onChanged: (value) =>
                                                  vungMien = value,
                                              items:
                                                  BlocProvider.of<DacSanBloc>(
                                                          context)
                                                      .dsVungMien,
                                              itemAsString: (value) {
                                                return value.ten;
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Flexible(
                                            fit: FlexFit.tight,
                                            child: FilledButton(
                                              style: roundButtonStyle(),
                                              onPressed: () {
                                                if (vungMien != null) {
                                                  context
                                                      .read<DacSanBloc>()
                                                      .add(AddVungMienEvent(
                                                          vungMien!));
                                                } else {
                                                  showNotify(context,
                                                      "Vui lòng chọn vùng miền");
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
                                                if (vungMien != null) {
                                                  context
                                                      .read<DacSanBloc>()
                                                      .add(RemoveVungMienEvent(
                                                          vungMien!));
                                                } else {
                                                  showNotify(context,
                                                      "Vui lòng chọn vùng miền");
                                                }
                                              },
                                              child: const Text("Xóa"),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: DropdownSearch<MuaDacSan>(
                                              validator: (value) => state
                                                      .dacSanTam
                                                      .muaDacSan
                                                      .isEmpty
                                                  ? "Vui lòng thêm ít nhất 1 mùa"
                                                  : null,
                                              popupProps: const PopupProps.menu(
                                                title: DropDownTitle(
                                                    text: "Danh sách mùa"),
                                                showSelectedItems: true,
                                              ),
                                              dropdownDecoratorProps:
                                                  DropDownDecoratorProps(
                                                dropdownSearchDecoration:
                                                    roundInputDecoration(
                                                        "Mùa", ""),
                                              ),
                                              compareFn: (item1, item2) =>
                                                  item1 == item2,
                                              onChanged: (value) =>
                                                  muaDacSan = value,
                                              items:
                                                  BlocProvider.of<DacSanBloc>(
                                                          context)
                                                      .dsMuaDacSan,
                                              itemAsString: (value) =>
                                                  value.ten,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Flexible(
                                            fit: FlexFit.tight,
                                            child: FilledButton(
                                              style: roundButtonStyle(),
                                              onPressed: () {
                                                if (muaDacSan != null) {
                                                  context
                                                      .read<DacSanBloc>()
                                                      .add(AddMuaDacSanEvent(
                                                          muaDacSan!));
                                                } else {
                                                  showNotify(context,
                                                      "Vui lòng chọn mùa");
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
                                                if (muaDacSan != null) {
                                                  context
                                                      .read<DacSanBloc>()
                                                      .add(RemoveMuaDacSanEvent(
                                                          muaDacSan!));
                                                } else {
                                                  showNotify(context,
                                                      "Vui lòng chọn mùa");
                                                }
                                              },
                                              child: const Text("Xóa"),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  flex: 2,
                                                  child: DropdownSearch<
                                                      NguyenLieu>(
                                                    validator: (value) => state
                                                            .dsThanhPhan.isEmpty
                                                        ? "Vui lòng thêm ít nhất 1 nguyên liệu"
                                                        : null,
                                                    popupProps:
                                                        const PopupProps.menu(
                                                      title: DropDownTitle(
                                                          text:
                                                              "Danh sách nguyên liệu"),
                                                      showSelectedItems: true,
                                                      showSearchBox: true,
                                                    ),
                                                    dropdownDecoratorProps:
                                                        DropDownDecoratorProps(
                                                      dropdownSearchDecoration:
                                                          roundInputDecoration(
                                                              "Nguyên liệu",
                                                              ""),
                                                    ),
                                                    compareFn: (item1, item2) =>
                                                        item1 == item2,
                                                    onChanged: (value) =>
                                                        nguyenLieu = value,
                                                    selectedItem: nguyenLieu,
                                                    asyncItems: (text) => Future(
                                                        () => BlocProvider.of<
                                                                    DacSanBloc>(
                                                                context)
                                                            .dsNguyenLieu
                                                            .where((element) =>
                                                                element.ten
                                                                    .contains(
                                                                        text))
                                                            .toList()),
                                                    itemAsString: (value) =>
                                                        value.ten,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Flexible(
                                                  flex: 2,
                                                  child: TextFormField(
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    controller: widget
                                                        .soLuongController,
                                                    decoration:
                                                        roundInputDecoration(
                                                            "Số lượng",
                                                            "Nhập số lượng"),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Flexible(
                                                  flex: 2,
                                                  child: TextFormField(
                                                    controller: widget
                                                        .donViTinhController,
                                                    decoration:
                                                        roundInputDecoration(
                                                            "Đơn vị tính",
                                                            "Nhập đơn vị tính"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                const SizedBox(width: 10),
                                                Flexible(
                                                  fit: FlexFit.tight,
                                                  child: FilledButton(
                                                    style: roundButtonStyle(),
                                                    onPressed: () {
                                                      try {
                                                        ThanhPhan thanhPhan =
                                                            ThanhPhan(
                                                          nguyenLieu:
                                                              nguyenLieu!,
                                                          soLuong: double.parse(
                                                              widget
                                                                  .soLuongController
                                                                  .text),
                                                          donViTinh: widget
                                                              .donViTinhController
                                                              .text,
                                                        );
                                                        context
                                                            .read<DacSanBloc>()
                                                            .add(
                                                                AddThanhPhanEvent(
                                                                    thanhPhan));
                                                      } catch (e) {
                                                        showNotify(context,
                                                            "Dữ liệu không hợp lệ");
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
                                                      try {
                                                        context
                                                            .read<DacSanBloc>()
                                                            .add(
                                                                RemoveThanhPhanEvent(
                                                                    ThanhPhan(
                                                              nguyenLieu:
                                                                  nguyenLieu!,
                                                              soLuong: double
                                                                  .parse(widget
                                                                      .soLuongController
                                                                      .text),
                                                              donViTinh: widget
                                                                  .donViTinhController
                                                                  .text,
                                                            )));
                                                      } catch (e) {
                                                        showNotify(context,
                                                            "Thành phần chưa tồn tại trong thông tin đặc sản");
                                                      }
                                                    },
                                                    child: const Text("Xóa"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: TextFormField(
                                              controller:
                                                  widget.tenHinhAnhController,
                                              decoration: roundInputDecoration(
                                                  "Tên hình ảnh",
                                                  "Nhập tên hình ảnh"),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Flexible(
                                            flex: 1,
                                            child: TextFormField(
                                              controller:
                                                  widget.moTaHinhAnhController,
                                              decoration: roundInputDecoration(
                                                  "Mô tả hình ảnh",
                                                  "Nhập thông tin mô tả"),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Flexible(
                                            flex: 1,
                                            child: TextFormField(
                                              controller:
                                                  widget.urlHinhAnhController,
                                              decoration: roundInputDecoration(
                                                  "URL",
                                                  "Nhập đường dẫn hình ảnh"),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Flexible(
                                            fit: FlexFit.tight,
                                            child: FilledButton(
                                              style: roundButtonStyle(),
                                              onPressed: () {
                                                try {
                                                  context
                                                      .read<DacSanBloc>()
                                                      .add(AddHinhAnhEvent(
                                                          HinhAnh(
                                                        id: -1,
                                                        ten: widget
                                                            .tenHinhAnhController
                                                            .text,
                                                        moTa: widget
                                                            .moTaHinhAnhController
                                                            .text,
                                                        urlHinhAnh: widget
                                                            .urlHinhAnhController
                                                            .text,
                                                      )));
                                                } catch (e) {
                                                  showNotify(context,
                                                      "Dữ liệu không hợp lệ");
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
                                                try {
                                                  setState(() {
                                                    context.read<DacSanBloc>().add(
                                                        RemoveHinhAnhEvent(state
                                                            .dacSanTam.hinhAnh
                                                            .firstWhere((element) =>
                                                                element.ten ==
                                                                widget
                                                                    .tenHinhAnhController
                                                                    .text)));
                                                  });
                                                } catch (e) {
                                                  showNotify(context,
                                                      "Hình ảnh chưa tồn tại trong thông tin đặc sản");
                                                }
                                              },
                                              child: const Text("Xóa"),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Flexible(
                                            fit: FlexFit.tight,
                                            child: FilledButton(
                                              style: roundButtonStyle(),
                                              onPressed: () {
                                                try {
                                                  context
                                                      .read<DacSanBloc>()
                                                      .add(AddHinhDaiDienEvent(
                                                          HinhAnh(
                                                        id: -1,
                                                        ten: widget
                                                            .tenHinhAnhController
                                                            .text,
                                                        moTa: widget
                                                            .moTaHinhAnhController
                                                            .text,
                                                        urlHinhAnh: widget
                                                            .urlHinhAnhController
                                                            .text,
                                                      )));
                                                } catch (e) {
                                                  showNotify(context,
                                                      "Dữ liệu không hợp lệ");
                                                }
                                              },
                                              child: const Text(
                                                  "Cập nhật hình đại diện"),
                                            ),
                                          ),
                                        ],
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
                                        onPressed: !state.isUpdate
                                            ? () {
                                                if (state.isInsert &&
                                                    widget.formKey.currentState!
                                                        .validate()) {
                                                  // Gọi hàm API thêm đặc sản
                                                  context
                                                      .read<DacSanBloc>()
                                                      .add(InsertEvent(
                                                          widget.tenController
                                                              .text,
                                                          moTa: widget
                                                              .moTaController
                                                              .text,
                                                          cachCheBien: widget
                                                              .cachCheBienController
                                                              .text));
                                                } else if (!state.isInsert) {
                                                  // Gán giá trị cho biến đặc sản tạm
                                                  context
                                                      .read<DacSanBloc>()
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
                                                if (state.dsChonDacSan
                                                        .where((element) =>
                                                            element)
                                                        .length !=
                                                    1) {
                                                  showNotify(context,
                                                      "Vui lòng chỉ chọn một dòng để cập nhật");
                                                  return;
                                                }
                                                if (state.isUpdate) {
                                                  // Kiểm tra các dữ liệu đầu vào hợp lệ
                                                  if (widget
                                                      .formKey.currentState!
                                                      .validate()) {
                                                    context
                                                        .read<DacSanBloc>()
                                                        .add(UpdateEnvent(DacSan(
                                                            id: BlocProvider.of<
                                                                        DacSanBloc>(
                                                                    context)
                                                                .dsDacSan[state
                                                                    .dsChonDacSan
                                                                    .indexOf(
                                                                        true)]
                                                                .id,
                                                            ten: widget
                                                                .tenController
                                                                .text,
                                                            hinhDaiDien:
                                                                hinhDaiDien!)));
                                                  }
                                                } else {
                                                  context
                                                      .read<DacSanBloc>()
                                                      .add(StartUpdateEvent(
                                                          BlocProvider.of<DacSanBloc>(
                                                                      context)
                                                                  .dsDacSan[
                                                              state.dsChonDacSan
                                                                  .indexOf(
                                                                      true)]));
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
                                        onPressed: !state.isUpdate &&
                                                !state.isInsert
                                            ? () {
                                                context.read<DacSanBloc>().add(
                                                    DeleteEvent(
                                                        state.dsChonDacSan));
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
                                                    .read<DacSanBloc>()
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
              ),
            );
          } else {
            return const Placeholder();
          }
        },
      ),
    );
  }
}
