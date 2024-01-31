// import 'package:async_builder/async_builder.dart';
// import 'package:data_table_2/data_table_2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
//
// import '../class/mua_dac_san.dart';
// import '../core/gui_helper.dart';
//
// class TrangMuaDacSan extends StatefulWidget {
//   TrangMuaDacSan({super.key});
//
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   final TextEditingController tenController = TextEditingController();
//   final TextEditingController textController = TextEditingController();
//   final PaginatorController pageController = PaginatorController();
//
//   @override
//   State<TrangMuaDacSan> createState() => _TrangMuaDacSanState();
// }
//
// class _TrangMuaDacSanState extends State<TrangMuaDacSan> {
//   // Các danh sách lấy từ API
//   List<MuaDacSan> dsMuaDacSan = [];
//   List<bool> dsChon = [];
//
//   // Đặc sản hiển thị tạm thời khi thêm và cập nhật
//   MuaDacSan? muaDacSanTam;
//
//   // Các biến để lưu tình trạng thêm hoặc cập nhật của trang
//   bool isReadonly = true;
//   bool isInsert = false;
//   bool isUpdate = false;
//
//   late Future myFuture;
//
//   // Các biến chứa DataTableSource cho các bảng
//   late MuaDacSanDataTableSource dataTableSource;
//
//   // Hàm cập nhật bảng mùa  để truyền vào DacSanDataTableSource
//   // Cập nhật danh sách thành phần (trống nếu số mùa  được chọn khác 1)
//   void notifyParent(int index) {
//     setState(() {
//       widget.tenController.text = dsMuaDacSan[index].ten;
//     });
//   }
//
//   void taoBang() {
//     dataTableSource = MuaDacSanDataTableSource(
//       dsMuaDacSan: dsMuaDacSan,
//       dsChon: dsChon,
//       notifyParent: notifyParent,
//     );
//   }
//
//   @override
//   void initState() {
//     myFuture = Future.delayed(const Duration(seconds: 1), () async {
//       // Doc danh sách từ API
//       dsMuaDacSan = await MuaDacSan.doc();
//       // Tạo bảng lưu tình trạng chọn mùa  theo danh sách mùa
//       dsChon = dsMuaDacSan.map((e) => false).toList();
//       taoBang();
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Flexible(
//       flex: 1,
//       child: AsyncBuilder(
//         // Quá trình đọc dữ liệu từ API
//         future: myFuture,
//         // Widget hiển thị trong quá trình đọc dữ liệu từ API
//         waiting: (context) => loadingCircle(),
//         // Widget hiển thị sau khi đọc dữ liệu từ API thành công
//         builder: (context, value) => Column(
//           children: [
//             Flexible(
//               flex: 1,
//               child: Container(
//                 constraints: const BoxConstraints(maxHeight: 600),
//                 child: AbsorbPointer(
//                   absorbing: isUpdate || isInsert,
//                   child: PaginatedDataTable2(
//                     controller: widget.pageController,
//                     rowsPerPage: 10,
//                     header: Row(
//                       children: [
//                         const Flexible(flex: 1, child: Text("Mùa")),
//                         const SizedBox(width: 25),
//                         Flexible(
//                           flex: 1,
//                           child: TypeAheadField(
//                             controller: widget.textController,
//                             builder: (context, controller, focusNode) {
//                               return TextField(
//                                 onSubmitted: (value) {
//                                   int slot = dsMuaDacSan.indexWhere(
//                                       (element) => element.ten == value);
//                                   if (slot != -1) {
//                                     widget.pageController.goToRow(slot);
//                                     dsChon[slot] = true;
//                                   }
//                                 },
//                                 controller: widget.textController,
//                                 focusNode: focusNode,
//                                 autofocus: false,
//                                 decoration: roundSearchBarInputDecoration(),
//                               );
//                             },
//                             loadingBuilder: (context) =>
//                                 loadingCircle(size: 50),
//                             emptyBuilder: (context) => const ListTile(
//                               title: Text("Không có mùa trùng khớp"),
//                             ),
//                             itemBuilder: (context, item) {
//                               return ListTile(
//                                 title: Text(item.ten),
//                               );
//                             },
//                             onSelected: (value) {
//                               int slot = dsMuaDacSan.indexWhere(
//                                   (element) => element.ten == value.ten);
//                               widget.pageController.goToRow(slot);
//                               dsChon[slot] = true;
//                             },
//                             suggestionsCallback: (search) => dsMuaDacSan
//                                 .where(
//                                     (element) => element.ten.contains(search))
//                                 .toList(),
//                           ),
//                         )
//                       ],
//                     ),
//                     columns: const [
//                       DataColumn2(
//                         label: Text('ID'),
//                       ),
//                       DataColumn(
//                         label: Text('Tên'),
//                       ),
//                     ],
//                     source: dataTableSource,
//                   ),
//                 ),
//               ),
//             ),
//             Form(
//               key: widget.formKey,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.vertical,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Column(
//                     children: [
//                       Visibility(
//                         visible: !isReadonly,
//                         child: TextFormField(
//                           controller: widget.tenController,
//                           validator: (value) => textFieldValidator(
//                               value, "Vui lòng nhập tên mùa"),
//                           decoration:
//                               roundInputDecoration("Tên mùa", "Nhập tên mùa"),
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//                       Row(
//                         children: [
//                           Flexible(
//                             fit: FlexFit.tight,
//                             child: FilledButton(
//                               style: roundButtonStyle(),
//                               onPressed: isReadonly || isInsert
//                                   ? () => them(context)
//                                   : null,
//                               child: const Text("Thêm"),
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           Flexible(
//                             fit: FlexFit.tight,
//                             child: FilledButton(
//                               style: roundButtonStyle(),
//                               onPressed: isReadonly || isUpdate
//                                   ? () => capNhat(context)
//                                   : null,
//                               child: const Text("Cập nhật"),
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           Flexible(
//                             fit: FlexFit.tight,
//                             child: FilledButton(
//                               style: roundButtonStyle(),
//                               onPressed: isReadonly ? () => xoa(context) : null,
//                               child: const Text("Xóa"),
//                             ),
//                           ),
//                           Visibility(
//                             visible: !isReadonly,
//                             child: Flexible(
//                               fit: FlexFit.tight,
//                               child: Row(
//                                 children: [
//                                   const SizedBox(width: 10),
//                                   Flexible(
//                                     fit: FlexFit.tight,
//                                     child: FilledButton(
//                                       style: roundButtonStyle(),
//                                       onPressed: () => huy(),
//                                       child: const Text("Hủy"),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         // Widget hiển thị sau khi đọc dữ liệu từ API thất bại
//         error: (context, error, stackTrace) =>
//             Center(child: Text('Error: $error')),
//       ),
//     );
//   }
//
//   // Hàm để thêm 1 dòng dữ liệu
//   void them(BuildContext context) {
//     if (isInsert && widget.formKey.currentState!.validate()) {
//       // Gọi hàm API thêm mùa
//       MuaDacSan.them(widget.tenController.text).then(
//         (value) {
//           if (value != null) {
//             // Cập nhật danh sách và bảng mùa  nếu thành công
//             setState(() {
//               dsMuaDacSan.add(value);
//               dsChon.add(false);
//             });
//             huy();
//           } else {
//             showNotify(context, "Thêm mùa  thất bại");
//           }
//         },
//       );
//     } else if (!isInsert) {
//       // Gán giá trị cho biến mùa  tạm
//       muaDacSanTam = MuaDacSan(
//         id: -1,
//         ten: widget.tenController.text,
//       );
//       dsMuaDacSan.add(muaDacSanTam!);
//       dsChon.add(true);
//       taoBang();
//       // Cập nhật tình trạng thêm của trang
//       setState(() {
//         isReadonly = !isReadonly;
//         isInsert = !isInsert;
//       });
//     }
//   }
//
//   // Hàm để cập nhật 1 dòng dữ liệu
//   void capNhat(BuildContext context) {
//     // Kiểm tra nếu số dòng đã chọn bằng 1
//     if (dsChon.where((element) => element).length == 1) {
//       // Kiếm tra tình trạng cập nhật
//       if (isUpdate) {
//         // Kiểm tra các dữ liệu đầu vào hợp lệ
//         if (widget.formKey.currentState!.validate()) {
//           int i = dsChon.indexOf(true);
//           MuaDacSan muaDacSan =
//               MuaDacSan(id: dsMuaDacSan[i].id, ten: widget.tenController.text);
//           // Gọi hàm API Cập nhật đặc sàn
//           MuaDacSan.capNhat(muaDacSan).then((value) {
//             if (value) {
//               // Cập nhật danh sách và bảng đặc sán nếu thành công
//               setState(() {
//                 dsMuaDacSan[i] = muaDacSan;
//                 taoBang();
//               });
//             } else {
//               showNotify(context, "Cập nhật mùa  thất bại");
//             }
//           });
//           setState(() {
//             isReadonly = !isReadonly;
//             isUpdate = !isUpdate;
//           });
//         }
//       } else {
//         setState(() {
//           // Gán dữ liệu các thuộc tính của mùa  vào các trường dữ liệu đẩu vào
//           muaDacSanTam = dsMuaDacSan[dsChon.indexOf(true)];
//           widget.tenController.text = muaDacSanTam!.ten;
//
//           // Cập nhật tình trạng cập nhật của trang
//           isReadonly = !isReadonly;
//           isUpdate = !isUpdate;
//         });
//       }
//     } else {
//       showNotify(context, "Vui lòng chỉ chọn một dòng để cập nhật");
//     }
//   }
//
//   void xoa(BuildContext context) {
//     for (int i = 0; i < dsChon.length; i++) {
//       if (dsChon[i]) {
//         MuaDacSan.xoa(dsMuaDacSan[i].id).then((value) {
//           if (value) {
//             setState(() {
//               dsMuaDacSan.remove(dsMuaDacSan[i]);
//               dsChon[i] = false;
//               taoBang();
//             });
//           } else {
//             showNotify(context, "Xóa mùa  thất bại");
//           }
//         });
//       }
//     }
//   }
//
//   Future<void> huy() async {
//     if (isInsert) {
//       int v = dsMuaDacSan.indexOf(muaDacSanTam!);
//       dsMuaDacSan.remove(dsMuaDacSan[v]);
//       dsChon.remove(dsChon[v]);
//     } else if (isUpdate) {
//       int v = dsMuaDacSan.indexOf(muaDacSanTam!);
//       dsMuaDacSan[v] = await MuaDacSan.docTheoID(muaDacSanTam!.id);
//       dsChon[v] = false;
//     }
//     setState(() {
//       isReadonly = true;
//       isInsert = false;
//       isUpdate = false;
//       taoBang();
//     });
//   }
// }
//
// class MuaDacSanDataTableSource extends DataTableSource {
//   List<MuaDacSan> dsMuaDacSan = [];
//   List<bool> dsChon = [];
//   void Function(int) notifyParent;
//
//   MuaDacSanDataTableSource({
//     required this.dsMuaDacSan,
//     required this.dsChon,
//     required this.notifyParent,
//   });
//
//   @override
//   DataRow? getRow(int index) {
//     // TODO: implement getRow
//     return DataRow2(
//       onSelectChanged: (value) {
//         dsChon[index] = value!;
//         notifyListeners();
//         notifyParent(index);
//       },
//       selected: dsChon[index],
//       cells: [
//         DataCell(Text(dsMuaDacSan[index].id.toString())),
//         DataCell(Text(dsMuaDacSan[index].ten)),
//       ],
//     );
//   }
//
//   @override
//   bool get isRowCountApproximate => false;
//
//   @override
//   int get rowCount => dsMuaDacSan.length;
//
//   @override
//   int get selectedRowCount => 0;
// }
