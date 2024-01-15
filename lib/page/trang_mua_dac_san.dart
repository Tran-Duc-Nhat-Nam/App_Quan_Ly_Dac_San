import 'package:app_dac_san/model/mua_dac_san.dart';
import 'package:async_builder/async_builder.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TrangMuaDacSan extends StatefulWidget {
  TrangMuaDacSan({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController tenController = TextEditingController();
  @override
  State<TrangMuaDacSan> createState() => _TrangMuaDacSanState();
}

class _TrangMuaDacSanState extends State<TrangMuaDacSan> {
  List<MuaDacSan> dsMuaDacSan = [];
  List<bool> selectedRowsIndex = [];
  late MuaDacSanDataTableSource dataTableSource;
  late Future myFuture;
  void createTable() {
    dataTableSource = MuaDacSanDataTableSource(
      dsMuaDacSan: dsMuaDacSan,
      selectedRowIndexs: selectedRowsIndex,
    );
  }

  void showNotify(BuildContext context, String content) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(content)));
  }

  @override
  void initState() {
    myFuture = Future.delayed(const Duration(seconds: 1), () async {
      dsMuaDacSan = await MuaDacSan.doc();
      selectedRowsIndex = dsMuaDacSan.map((e) => false).toList();
      createTable();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: AsyncBuilder(
        future: myFuture,
        waiting: (context) => Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingAnimationWidget.discreteCircle(
                  color: Colors.cyan, size: 100),
            ],
          ),
        ),
        builder: (context, value) => Column(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 600),
                child: PaginatedDataTable2(
                  rowsPerPage: 10,
                  columns: const [
                    DataColumn2(
                      label: Text('ID'),
                    ),
                    DataColumn(
                      label: Text('Tên'),
                    ),
                  ],
                  source: dataTableSource,
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
                      TextFormField(
                        controller: widget.tenController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng nhập tên mùa";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            label: const Text("Tên mùa"),
                            hintText: "Nhập tên mùa",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            )),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: FilledButton(
                              onPressed: () => them(context),
                              child: const Text("Thêm"),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Flexible(
                            fit: FlexFit.tight,
                            child: FilledButton(
                              onPressed: () => capNhat(context),
                              child: const Text("Cập nhật"),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Flexible(
                            fit: FlexFit.tight,
                            child: FilledButton(
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

  void them(BuildContext context) {
    if (widget.formKey.currentState!.validate()) {
      MuaDacSan.them(widget.tenController.text).then((value) {
        if (value != null) {
          setState(() {
            dsMuaDacSan.add(value);
            selectedRowsIndex.add(false);
            createTable();
          });
        } else {
          showNotify(context, "Thêm mùa thất bại");
        }
      });
    }
  }

  void capNhat(BuildContext context) {
    if (widget.formKey.currentState!.validate()) {
      if (selectedRowsIndex.where((element) => element).length == 1) {
        int i = selectedRowsIndex.indexOf(true);
        MuaDacSan vungMien =
            MuaDacSan(id: dsMuaDacSan[i].id, ten: widget.tenController.text);
        MuaDacSan.capNhat(vungMien).then((value) {
          if (value) {
            setState(() {
              dsMuaDacSan[i] = vungMien;
              createTable();
            });
          } else {
            showNotify(context, "Cập nhật mùa thất bại");
          }
        });
      }
    }
  }

  void xoa(BuildContext context) {
    if (widget.formKey.currentState!.validate()) {
      for (int i = 0; i < selectedRowsIndex.length; i++) {
        if (selectedRowsIndex[i]) {
          MuaDacSan.xoa(dsMuaDacSan[i].id).then((value) {
            if (value) {
              setState(() {
                dsMuaDacSan.remove(dsMuaDacSan[i]);
                selectedRowsIndex[i] = false;
                createTable();
              });
            } else {
              showNotify(context, "Xóa mùa thất bại");
            }
          });
        }
      }
    }
  }
}

class MuaDacSanDataTableSource extends DataTableSource {
  List<MuaDacSan> dsMuaDacSan = [];
  List<bool> selectedRowIndexs = [];
  MuaDacSanDataTableSource({
    required this.dsMuaDacSan,
    required this.selectedRowIndexs,
  });
  @override
  DataRow? getRow(int index) {
    // TODO: implement getRow
    return DataRow2(
      onSelectChanged: (value) {
        selectedRowIndexs[index] = value!;
        notifyListeners();
      },
      selected: selectedRowIndexs[index],
      cells: [
        DataCell(Text(dsMuaDacSan[index].id.toString())),
        DataCell(Text(dsMuaDacSan[index].ten)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dsMuaDacSan.length;

  @override
  int get selectedRowCount => 0;
}
