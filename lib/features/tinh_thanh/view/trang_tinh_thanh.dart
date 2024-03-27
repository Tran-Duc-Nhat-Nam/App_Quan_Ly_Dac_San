import 'package:app_dac_san/features/tinh_thanh/data/quan_huyen.dart';
import 'package:app_dac_san/features/tinh_thanh/view/bang_phuong_xa.dart';
import 'package:app_dac_san/features/tinh_thanh/view/bang_quan_huyen.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/gui_helper.dart';
import '../bloc/phuong_xa/phuong_xa_bloc.dart' as px;
import '../bloc/quan_huyen/quan_huyen_bloc.dart' as qh;
import '../bloc/tinh_thanh_bloc.dart';
import '../data/tinh_thanh.dart';
import 'bang_tinh_thanh.dart';

class TrangTinhThanh extends StatefulWidget {
  TrangTinhThanh({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController textController = TextEditingController();
  final PaginatorController pageController = PaginatorController();

  @override
  State<TrangTinhThanh> createState() => _TrangTinhThanhState();
}

class _TrangTinhThanhState extends State<TrangTinhThanh> {
  List<bool> dsChon = [];

  // Hàm cập nhật bảng tỉnh thành để truyền vào DacSanDataTableSource
  void notifyTT(BuildContext context, int id) {
    context
        .read<qh.QuanHuyenBloc>()
        .add(qh.LoadQuanHuyenEvent(TinhThanh(id: id, ten: "")));
  }

  void notifyQH(BuildContext context, int id) {
    context.read<px.PhuongXaBloc>().add(px.LoadPhuongXaEvent(
        QuanHuyen(id: id, ten: "", tinhThanh: TinhThanh.tam())));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => TinhThanhBloc()..add(LoadTinhThanhEvent())),
        BlocProvider(create: (context) => qh.QuanHuyenBloc()),
        BlocProvider(create: (context) => px.PhuongXaBloc()),
      ],
      child: BlocBuilder<TinhThanhBloc, TinhThanhState>(
        // Widget hiển thị sau khi đọc dữ liệu từ API thành công
        builder: (context, state) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 1000),
          child: buildPage(context, state),
        ),
      ),
    );
  }

  Widget buildPage(context, state) {
    if (state is TinhThanhInitial) {
      return loadingCircle();
    } else if (state is TinhThanhLoaded) {
      TextEditingController tenController = TextEditingController();
      dsChon = state.dsChon;

      if (dsChon.where((element) => element).toList().length == 1) {
        tenController.text =
            state.dsTinhThanh[dsChon.indexWhere((element) => element)].ten;
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
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: AbsorbPointer(
                      absorbing: state.isUpdate || state.isInsert,
                      child: BangTinhThanh(
                          widget: widget,
                          dsTinhThanh: state.dsTinhThanh,
                          dsChon: dsChon,
                          dataTableSource: TinhThanhDataTableSource(
                            dsTinhThanh: state.dsTinhThanh,
                            context: context,
                            notifyParent: notifyTT,
                          )),
                    ),
                  ),
                  BlocBuilder<qh.QuanHuyenBloc, qh.QuanHuyenState>(
                    builder: (context, state) {
                      return Flexible(
                        flex: 1,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          child: buildBangQuanHuyen(context, state),
                        ),
                      );
                    },
                  ),
                  BlocBuilder<px.PhuongXaBloc, px.PhuongXaState>(
                    builder: (context, state) {
                      return Flexible(
                        flex: 1,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          child: buildBangPhuongXa(context, state),
                        ),
                      );
                    },
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
                      visible: state.isInsert || state.isUpdate,
                      child: TextFormField(
                        controller: tenController,
                        validator: (value) => textFieldValidator(
                            value, "Vui lòng nhập tên tỉnh thành"),
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
                            onPressed: !state.isUpdate
                                ? () {
                                    if (state.isInsert &&
                                        widget.formKey.currentState!
                                            .validate()) {
                                      // Gọi hàm API thêm tỉnh thành
                                      context.read<TinhThanhBloc>().add(
                                          InsertEvent(TinhThanh(
                                              id: -1,
                                              ten: tenController.text)));
                                    } else if (!state.isInsert) {
                                      // Gán giá trị cho biến tỉnh thành tạm
                                      context
                                          .read<TinhThanhBloc>()
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
                                        context.read<TinhThanhBloc>().add(
                                            UpdateEnvent(TinhThanh(
                                                id: state
                                                    .dsTinhThanh[
                                                        dsChon.indexOf(true)]
                                                    .id,
                                                ten: tenController.text)));
                                      }
                                    } else {
                                      setState(() {
                                        // Gán dữ liệu các thuộc tính của tỉnh thành vào các trường dữ liệu đẩu vào
                                        context.read<TinhThanhBloc>().add(
                                            StartUpdateEvent(state.dsTinhThanh[
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
                            onPressed: !state.isUpdate && !state.isInsert
                                ? () {
                                    context
                                        .read<TinhThanhBloc>()
                                        .add(DeleteEvent(dsChon));
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
                                        .read<TinhThanhBloc>()
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
  }

  Widget buildBangQuanHuyen(context, qh.QuanHuyenState state) {
    if (state is qh.QuanHuyenLoading) {
      return Padding(
        padding: const EdgeInsets.all(25),
        child: loadingCircle(size: 50),
      );
    } else if (state is qh.QuanHuyenLoaded) {
      return AbsorbPointer(
        absorbing: state.isUpdate || state.isInsert,
        child: BangQuanHuyen(
            widget: widget,
            dsQuanHuyen: state.dsQuanHuyen,
            dsChon: dsChon,
            dataTableSource: QuanHuyenDataTableSource(
              dsQuanHuyen: state.dsQuanHuyen,
              context: context,
              notifyParent: notifyQH,
            )),
      );
    } else {
      return BangQuanHuyen(
          widget: widget,
          dsQuanHuyen: const [],
          dsChon: dsChon,
          dataTableSource: QuanHuyenDataTableSource(
            dsQuanHuyen: [],
            context: context,
            notifyParent: notifyQH,
          ));
    }
  }

  Widget buildBangPhuongXa(context, px.PhuongXaState state) {
    if (state is px.PhuongXaLoading) {
      return loadingCircle(size: 50);
    } else if (state is px.PhuongXaLoaded) {
      return AbsorbPointer(
        absorbing: state.isUpdate || state.isInsert,
        child: BangPhuongXa(
            widget: widget,
            dsPhuongXa: state.dsPhuongXa,
            dsChon: dsChon,
            dataTableSource: PhuongXaDataTableSource(
              dsPhuongXa: state.dsPhuongXa,
            )),
      );
    } else {
      return BangPhuongXa(
          widget: widget,
          dsPhuongXa: const [],
          dsChon: dsChon,
          dataTableSource: PhuongXaDataTableSource(
            dsPhuongXa: [],
          ));
    }
  }
}
