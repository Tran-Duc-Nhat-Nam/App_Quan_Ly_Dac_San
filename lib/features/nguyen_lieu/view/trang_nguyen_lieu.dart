import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/gui_helper.dart';
import '../bloc/nguyen_lieu_bloc.dart';
import '../data/nguyen_lieu.dart';
import 'bang_nguyen_lieu.dart';

class TrangNguyenLieu extends StatefulWidget {
  TrangNguyenLieu({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController textController = TextEditingController();
  final PaginatorController pageController = PaginatorController();

  @override
  State<TrangNguyenLieu> createState() => _TrangNguyenLieuState();
}

class _TrangNguyenLieuState extends State<TrangNguyenLieu> {
  List<bool> dsChon = [];

  // Hàm cập nhật bảng nguyên liệu để truyền vào DacSanDataTableSource
  void notifyParent(List<bool> list) {
    dsChon = list;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NguyenLieuBloc()..add(LoadDataEvent()),
      child: Flexible(
        flex: 1,
        child: BlocBuilder<NguyenLieuBloc, NguyenLieuState>(
          // Widget hiển thị sau khi đọc dữ liệu từ API thành công
          builder: (context, state) {
            if (state is NguyenLieuInitial) {
              return loadingCircle();
            } else if (state is NguyenLieuLoaded) {
              TextEditingController tenController = TextEditingController();
              dsChon = state.dsChon;

              if (dsChon.where((element) => element).toList().length == 1) {
                tenController.text = state
                    .dsNguyenLieu[dsChon.indexWhere((element) => element)].ten;
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
                        child: BangNguyenLieu(
                            widget: widget,
                            dsNguyenLieu: state.dsNguyenLieu,
                            dsChon: dsChon,
                            dataTableSource: NguyenLieuDataTableSource(
                              dsNguyenLieu: state.dsNguyenLieu,
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
                                    onPressed: !state.isUpdate
                                        ? () {
                                            if (state.isInsert &&
                                                widget.formKey.currentState!
                                                    .validate()) {
                                              // Gọi hàm API thêm nguyên liệu
                                              context
                                                  .read<NguyenLieuBloc>()
                                                  .add(InsertEvent(NguyenLieu(
                                                      id: -1,
                                                      ten:
                                                          tenController.text)));
                                            } else if (!state.isInsert) {
                                              // Gán giá trị cho biến nguyên liệu tạm
                                              context
                                                  .read<NguyenLieuBloc>()
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
                                                    .read<NguyenLieuBloc>()
                                                    .add(UpdateEnvent(NguyenLieu(
                                                        id: state
                                                            .dsNguyenLieu[dsChon
                                                                .indexOf(true)]
                                                            .id,
                                                        ten: tenController
                                                            .text)));
                                              }
                                            } else {
                                              setState(() {
                                                // Gán dữ liệu các thuộc tính của nguyên liệu vào các trường dữ liệu đẩu vào
                                                context
                                                    .read<NguyenLieuBloc>()
                                                    .add(StartUpdateEvent(state
                                                            .dsNguyenLieu[
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
                                                    .read<NguyenLieuBloc>()
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
                                                .read<NguyenLieuBloc>()
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
