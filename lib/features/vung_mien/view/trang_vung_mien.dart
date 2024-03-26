import 'package:app_dac_san/features/vung_mien/bloc/vung_mien_bloc.dart';
import 'package:app_dac_san/features/vung_mien/data/vung_mien.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/gui_helper.dart';
import 'bang_vung_mien.dart';

class TrangVungMien extends StatefulWidget {
  TrangVungMien({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController textController = TextEditingController();
  final PaginatorController pageController = PaginatorController();

  @override
  State<TrangVungMien> createState() => _TrangVungMienState();
}

class _TrangVungMienState extends State<TrangVungMien> {
  List<bool> dsChon = [];

  // Hàm cập nhật bảng vùng miền để truyền vào DacSanDataTableSource
  void notifyParent(List<bool> list) {
    dsChon = list;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VungMienBloc()..add(LoadDataEvent()),
      child: BlocBuilder<VungMienBloc, VungMienState>(
        // Widget hiển thị sau khi đọc dữ liệu từ API thành công
        builder: (context, state) {
          if (state is VungMienInitial) {
            return loadingCircle();
          } else if (state is VungMienLoaded) {
            TextEditingController tenController = TextEditingController();
            dsChon = state.dsChon;

            if (dsChon.where((element) => element).toList().length == 1) {
              tenController.text =
                  state.dsVungMien[dsChon.indexWhere((element) => element)].ten;
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
                      child: BangTinhThanh(
                          widget: widget,
                          dsVungMien: state.dsVungMien,
                          dsChon: dsChon,
                          dataTableSource: VungMienDataTableSource(
                            dsVungMien: state.dsVungMien,
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
                                            context.read<VungMienBloc>().add(
                                                InsertEvent(VungMien(
                                                    id: -1,
                                                    ten: tenController.text)));
                                          } else if (!state.isInsert) {
                                            // Gán giá trị cho biến vùng miền tạm
                                            context
                                                .read<VungMienBloc>()
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
                                              context.read<VungMienBloc>().add(
                                                  UpdateEnvent(VungMien(
                                                      id: state
                                                          .dsVungMien[dsChon
                                                              .indexOf(true)]
                                                          .id,
                                                      ten:
                                                          tenController.text)));
                                            }
                                          } else {
                                            setState(() {
                                              // Gán dữ liệu các thuộc tính của vùng miền vào các trường dữ liệu đẩu vào
                                              context.read<VungMienBloc>().add(
                                                  StartUpdateEvent(state
                                                          .dsVungMien[
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
                                              .read<VungMienBloc>()
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
                                              .read<VungMienBloc>()
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
    );
  }
}
