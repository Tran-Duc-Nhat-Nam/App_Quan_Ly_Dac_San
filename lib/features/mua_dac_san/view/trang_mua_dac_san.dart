import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/gui_helper.dart';
import '../bloc/mua_dac_san_bloc.dart';
import '../data/mua_dac_san.dart';
import 'bang_mua_dac_san.dart';

class TrangMuaDacSan extends StatefulWidget {
  TrangMuaDacSan({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController textController = TextEditingController();
  final PaginatorController pageController = PaginatorController();

  @override
  State<TrangMuaDacSan> createState() => _TrangMuaDacSanState();
}

class _TrangMuaDacSanState extends State<TrangMuaDacSan> {
  List<bool> dsChon = [];

  // Hàm cập nhật bảng mùa để truyền vào DacSanDataTableSource
  void notifyParent(List<bool> list) {
    dsChon = list;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MuaDacSanBloc()..add(LoadDataEvent()),
      child: BlocBuilder<MuaDacSanBloc, MuaDacSanState>(
        // Widget hiển thị sau khi đọc dữ liệu từ API thành công
        builder: (context, state) {
          if (state is MuaDacSanInitial) {
            return loadingCircle();
          } else if (state is MuaDacSanLoaded) {
            TextEditingController tenController = TextEditingController();
            dsChon = state.dsChon;

            if (dsChon.where((element) => element).toList().length == 1) {
              tenController.text = state
                  .dsMuaDacSan[dsChon.indexWhere((element) => element)].ten;
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
                      child: BangMuaDacSan(
                          widget: widget,
                          dsMuaDacSan: state.dsMuaDacSan,
                          dsChon: dsChon,
                          dataTableSource: MuaDacSanDataTableSource(
                            dsMuaDacSan: state.dsMuaDacSan,
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
                                  value, "Vui lòng nhập tên mùa"),
                              decoration: roundInputDecoration(
                                  "Tên mùa", "Nhập tên mùa"),
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
                                            // Gọi hàm API thêm mùa
                                            context.read<MuaDacSanBloc>().add(
                                                InsertEvent(MuaDacSan(
                                                    id: -1,
                                                    ten: tenController.text)));
                                          } else if (!state.isInsert) {
                                            // Gán giá trị cho biến mùa tạm
                                            context
                                                .read<MuaDacSanBloc>()
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
                                              context.read<MuaDacSanBloc>().add(
                                                  UpdateEnvent(MuaDacSan(
                                                      id: state
                                                          .dsMuaDacSan[dsChon
                                                              .indexOf(true)]
                                                          .id,
                                                      ten:
                                                          tenController.text)));
                                            }
                                          } else {
                                            setState(() {
                                              // Gán dữ liệu các thuộc tính của mùa vào các trường dữ liệu đẩu vào
                                              context.read<MuaDacSanBloc>().add(
                                                  StartUpdateEvent(state
                                                          .dsMuaDacSan[
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
                                              .read<MuaDacSanBloc>()
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
                                              .read<MuaDacSanBloc>()
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
