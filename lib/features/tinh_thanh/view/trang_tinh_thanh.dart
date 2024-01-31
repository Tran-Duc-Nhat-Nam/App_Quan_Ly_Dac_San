import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/gui_helper.dart';
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

  // Hàm cập nhật bảng vùng miền để truyền vào DacSanDataTableSource
  void notifyParent(List<bool> list) {
    dsChon = list;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TinhThanhBloc()..add(LoadDataEvent()),
      child: Flexible(
        flex: 1,
        child: BlocBuilder<TinhThanhBloc, TinhThanhState>(
          // Widget hiển thị sau khi đọc dữ liệu từ API thành công
          builder: (context, state) {
            if (state is TinhThanhInitial) {
              return loadingCircle();
            } else if (state is TinhThanhLoaded) {
              TextEditingController tenController = TextEditingController();
              dsChon = state.dsChon;

              if (dsChon.where((element) => element).toList().length == 1) {
                tenController.text = state
                    .dsTinhThanh[dsChon.indexWhere((element) => element)].ten;
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
                        child: BangThanhPhan(
                            widget: widget,
                            dsTinhThanh: state.dsTinhThanh,
                            dsChon: dsChon,
                            dataTableSource: TinhThanhDataTableSource(
                              dsTinhThanh: state.dsTinhThanh,
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
                              child: TextFormField(
                                controller: tenController,
                                validator: (value) => textFieldValidator(
                                    value, "Vui lòng nhập tên vùng miền"),
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
                                    onPressed: !state.isUpdate
                                        ? () {
                                            if (state.isInsert &&
                                                widget.formKey.currentState!
                                                    .validate()) {
                                              // Gọi hàm API thêm vùng miền
                                              context.read<TinhThanhBloc>().add(
                                                  InsertEvent(TinhThanh(
                                                      id: -1,
                                                      ten:
                                                          tenController.text)));
                                            } else if (!state.isInsert) {
                                              // Gán giá trị cho biến vùng miền tạm
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
                                                context
                                                    .read<TinhThanhBloc>()
                                                    .add(UpdateEnvent(TinhThanh(
                                                        id: state
                                                            .dsTinhThanh[dsChon
                                                                .indexOf(true)]
                                                            .id,
                                                        ten: tenController
                                                            .text)));
                                              }
                                            } else {
                                              setState(() {
                                                // Gán dữ liệu các thuộc tính của vùng miền vào các trường dữ liệu đẩu vào
                                                context
                                                    .read<TinhThanhBloc>()
                                                    .add(StartUpdateEvent(state
                                                            .dsTinhThanh[
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
          },
        ),
      ),
    );
  }
}
