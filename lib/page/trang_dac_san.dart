import 'package:app_dac_san/model/mua_dac_san.dart';
import 'package:app_dac_san/model/nguyen_lieu.dart';
import 'package:app_dac_san/model/thanh_phan.dart';
import 'package:app_dac_san/model/vung_mien.dart';
import 'package:async_builder/async_builder.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../gui_helper.dart';
import '../model/dac_san.dart';
import '../model/hinh_anh.dart';

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
  final PaginatorController dacSanController = PaginatorController();
  @override
  State<TrangDacSan> createState() => _TrangDacSanState();
}

class _TrangDacSanState extends State<TrangDacSan> {
  List<DacSan> dsDacSan = [];
  List<VungMien> dsVungMien = [];
  List<VungMien> dsVungMienTam = [];
  List<MuaDacSan> dsMuaDacSan = [];
  List<MuaDacSan> dsMuaDacSanTam = [];
  List<NguyenLieu> dsNguyenLieu = [];
  List<ThanhPhan> dsThanhPhan = [];
  List<ThanhPhan> dsThanhPhanTam = [];
  List<HinhAnh> dsHinhAnh = [];
  List<HinhAnh> dsHinhAnhTam = [];
  List<bool> dsChonDacSan = [];
  List<bool> dsChonThanhPhan = [];
  DacSan? dacSanTam;
  VungMien? vungMien;
  MuaDacSan? muaDacSan;
  NguyenLieu? nguyenLieu;
  HinhAnh? hinhDaiDien;
  bool isReadonly = true;
  bool isInsert = false;
  bool isUpdate = false;
  late DacSanDataTableSource bangDacSan;
  late ThanhPhanDataTableSource bangThanhPhan;
  late Future myFuture;

  void notifyParent(int index) {
    setState(() {
      if (dsChonDacSan[index]) {
        dsThanhPhan = dsChonDacSan.where((element) => element).length > 1
            ? []
            : dsDacSan[index].thanhPhan;
        dsChonThanhPhan = dsThanhPhan.map((e) => false).toList();
      } else {
        dsThanhPhan = dsChonDacSan.where((element) => element).length == 1
            ? dsDacSan[dsChonDacSan.indexOf(true)].thanhPhan
            : [];
        dsChonThanhPhan = [];
      }
      taoBangThanhPhan();
    });
  }

  void notifyParentTP(int index) {
    setState(() {
      nguyenLieu = dsThanhPhan[index].nguyenLieu;
      widget.soLuongController.text = dsThanhPhan[index].soLuong.toString();
      widget.donViTinhController.text = dsThanhPhan[index].donViTinh;
    });
  }

  void taoBangDacSan() {
    bangDacSan = DacSanDataTableSource(
      dsDacSan: dsDacSan,
      selectedRowIndexs: dsChonDacSan,
      notifyParent: notifyParent,
    );
  }

  void taoBangThanhPhan() {
    bangThanhPhan = ThanhPhanDataTableSource(
      dsThanhPhan: dsThanhPhan,
      selectedRowIndexs: dsChonThanhPhan,
      notifyParent: notifyParentTP,
    );
  }

  @override
  void initState() {
    myFuture = Future.delayed(const Duration(seconds: 1), () async {
      dsDacSan = await DacSan.doc();
      dsVungMien = await VungMien.doc();
      dsMuaDacSan = await MuaDacSan.doc();
      dsNguyenLieu = await NguyenLieu.doc();
      dsChonDacSan = dsDacSan.map((e) => false).toList();
      taoBangDacSan();
      taoBangThanhPhan();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: AsyncBuilder(
        future: myFuture,
        waiting: (context) => loadingCircle(),
        builder: (context, value) => Column(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 600),
                child: Row(children: [
                  BangDacSan(
                      isUpdate: isUpdate,
                      isInsert: isInsert,
                      widget: widget,
                      bangDacSan: bangDacSan),
                  BangThanhPhan(
                      dsChonDacSan: dsChonDacSan, bangThanhPhan: bangThanhPhan),
                ]),
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
                        visible: !isReadonly,
                        child: Column(
                          children: [
                            TextFormField(
                              readOnly: isReadonly,
                              controller: widget.tenController,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? "Vui lòng nhập tên đặc sản"
                                      : null,
                              decoration: roundInputDecoration(
                                  "Tên đặc sản", "Nhập tên đặc sản"),
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              readOnly: isReadonly,
                              controller: widget.moTaController,
                              decoration: roundInputDecoration(
                                  "Mô tả đặc sản", "Nhập thông tin mô tả"),
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              readOnly: isReadonly,
                              controller: widget.cachCheBienController,
                              decoration: roundInputDecoration(
                                  "Cách chế biến đặc sản",
                                  "Nhập thông tin chế biến"),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: DropdownSearch<VungMien>(
                                    enabled: !isReadonly,
                                    validator: (value) {
                                      if (dsVungMienTam.isEmpty) {
                                        return "Vui lòng thêm ít nhất 1 vùng miền";
                                      }
                                      return null;
                                    },
                                    popupProps: const PopupProps.menu(
                                      title: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Center(
                                          child: Text(
                                            "Danh sách vùng miền",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      showSelectedItems: true,
                                    ),
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                      dropdownSearchDecoration:
                                          roundInputDecoration("Vùng miền", ""),
                                    ),
                                    compareFn: (item1, item2) {
                                      return item1 == item2;
                                    },
                                    onChanged: (value) async {
                                      if (value != null) {
                                        vungMien = value;
                                      }
                                    },
                                    items: dsVungMien,
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
                                    onPressed: !isReadonly
                                        ? () {
                                            if (vungMien != null) {
                                              setState(() {
                                                dsVungMienTam.add(vungMien!);
                                                taoBangDacSan();
                                              });
                                            } else {
                                              showNotify(context,
                                                  "Vui lòng chọn vùng miền");
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
                                    onPressed: !isReadonly
                                        ? () {
                                            if (vungMien != null) {
                                              setState(() {
                                                dsVungMienTam.remove(vungMien!);
                                                taoBangDacSan();
                                              });
                                            } else {
                                              showNotify(context,
                                                  "Vui lòng chọn vùng miền");
                                            }
                                          }
                                        : null,
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
                                    enabled: !isReadonly,
                                    validator: (value) {
                                      if (dsMuaDacSanTam.isEmpty) {
                                        return "Vui lòng thêm ít nhất 1 mùa";
                                      }
                                      return null;
                                    },
                                    popupProps: const PopupProps.menu(
                                      title: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Center(
                                          child: Text(
                                            "Danh sách mùa",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      showSelectedItems: true,
                                    ),
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                      dropdownSearchDecoration:
                                          roundInputDecoration("Mùa", ""),
                                    ),
                                    compareFn: (item1, item2) {
                                      return item1 == item2;
                                    },
                                    onChanged: (value) {
                                      if (value != null) {
                                        muaDacSan = value;
                                      }
                                    },
                                    items: dsMuaDacSan,
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
                                    onPressed: !isReadonly
                                        ? () {
                                            if (muaDacSan != null) {
                                              setState(() {
                                                dsMuaDacSanTam.add(muaDacSan!);
                                                taoBangDacSan();
                                              });
                                            } else {
                                              showNotify(
                                                  context, "Vui lòng chọn mùa");
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
                                    onPressed: !isReadonly
                                        ? () {
                                            if (muaDacSan != null) {
                                              setState(() {
                                                dsMuaDacSan.remove(muaDacSan!);
                                                taoBangDacSan();
                                              });
                                            } else {
                                              showNotify(
                                                  context, "Vui lòng chọn mùa");
                                            }
                                          }
                                        : null,
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
                                        child: DropdownSearch<NguyenLieu>(
                                          enabled: !isReadonly,
                                          validator: (value) {
                                            if (dsThanhPhanTam.isEmpty) {
                                              return "Vui lòng thêm ít nhất 1 nguyên liệu";
                                            }
                                            return null;
                                          },
                                          popupProps: const PopupProps.menu(
                                            title: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: Center(
                                                child: Text(
                                                  "Danh sách nguyên liệu",
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
                                                InputDecoration(
                                              label: const Text("Nguyên liệu"),
                                              contentPadding:
                                                  const EdgeInsetsDirectional
                                                      .only(
                                                start: 25,
                                                top: 15,
                                                bottom: 15,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                            ),
                                          ),
                                          compareFn: (item1, item2) {
                                            return item1 == item2;
                                          },
                                          onChanged: (value) {
                                            if (value != null) {
                                              nguyenLieu = value;
                                            }
                                          },
                                          selectedItem: nguyenLieu,
                                          items: dsNguyenLieu,
                                          itemAsString: (value) {
                                            return value.ten;
                                          },
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
                                          readOnly: isReadonly,
                                          controller: widget.soLuongController,
                                          decoration: roundInputDecoration(
                                              "Số lượng", "Nhập số lượng"),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(
                                        flex: 2,
                                        child: TextFormField(
                                          readOnly: isReadonly,
                                          controller:
                                              widget.donViTinhController,
                                          decoration: roundInputDecoration(
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
                                          onPressed: !isReadonly
                                              ? () {
                                                  try {
                                                    ThanhPhan thanhPhan =
                                                        ThanhPhan(
                                                      nguyenLieu: nguyenLieu!,
                                                      soLuong: double.parse(
                                                          widget
                                                              .soLuongController
                                                              .text),
                                                      donViTinh: widget
                                                          .donViTinhController
                                                          .text,
                                                    );
                                                    setState(() {
                                                      dsThanhPhanTam
                                                          .add(thanhPhan);
                                                      taoBangDacSan();
                                                    });
                                                  } catch (e) {
                                                    showNotify(context,
                                                        "Dữ liệu không hợp lệ");
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
                                          onPressed: !isReadonly
                                              ? () {
                                                  try {
                                                    setState(() {
                                                      dsThanhPhanTam.remove(
                                                          dsThanhPhanTam.firstWhere(
                                                              (element) =>
                                                                  element
                                                                      .nguyenLieu
                                                                      .id ==
                                                                  nguyenLieu!
                                                                      .id));
                                                    });
                                                    taoBangDacSan();
                                                  } catch (e) {
                                                    showNotify(context,
                                                        "Thành phần chưa tồn tại trong thông tin đặc sản");
                                                  }
                                                }
                                              : null,
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
                                    readOnly: isReadonly,
                                    controller: widget.tenHinhAnhController,
                                    decoration: roundInputDecoration(
                                        "Tên hình ảnh", "Nhập tên hình ảnh"),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  flex: 1,
                                  child: TextFormField(
                                    readOnly: isReadonly,
                                    controller: widget.moTaHinhAnhController,
                                    decoration: roundInputDecoration(
                                        "Mô tả hình ảnh",
                                        "Nhập thông tin mô tả"),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  flex: 1,
                                  child: TextFormField(
                                    readOnly: isReadonly,
                                    controller: widget.urlHinhAnhController,
                                    decoration: roundInputDecoration(
                                        "URL", "Nhập đường dẫn hình ảnh"),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: FilledButton(
                                    style: roundButtonStyle(),
                                    onPressed: !isReadonly
                                        ? () {
                                            try {
                                              HinhAnh hinhAnh = HinhAnh(
                                                id: 0,
                                                ten: widget
                                                    .tenHinhAnhController.text,
                                                moTa: widget
                                                    .moTaHinhAnhController.text,
                                                urlHinhAnh: widget
                                                    .urlHinhAnhController.text,
                                              );
                                              setState(() {
                                                dsHinhAnhTam.add(hinhAnh);
                                              });
                                              taoBangDacSan();
                                            } catch (e) {
                                              showNotify(context,
                                                  "Dữ liệu không hợp lệ");
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
                                    onPressed: !isReadonly
                                        ? () {
                                            try {
                                              setState(() {
                                                dsHinhAnhTam.remove(dsHinhAnhTam
                                                    .firstWhere((element) =>
                                                        element.ten ==
                                                        widget
                                                            .tenHinhAnhController
                                                            .text));
                                              });
                                              taoBangDacSan();
                                            } catch (e) {
                                              showNotify(context,
                                                  "Hình ảnh chưa tồn tại trong thông tin đặc sản");
                                            }
                                          }
                                        : null,
                                    child: const Text("Xóa"),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: FilledButton(
                                    style: roundButtonStyle(),
                                    onPressed: !isReadonly
                                        ? () {
                                            try {
                                              HinhAnh hinhAnh = HinhAnh(
                                                id: 0,
                                                ten: widget
                                                    .tenHinhAnhController.text,
                                                moTa: widget
                                                    .moTaHinhAnhController.text,
                                                urlHinhAnh: widget
                                                    .urlHinhAnhController.text,
                                              );
                                              hinhDaiDien = hinhAnh;
                                              taoBangDacSan();
                                            } catch (e) {
                                              showNotify(context,
                                                  "Dữ liệu không hợp lệ");
                                            }
                                          }
                                        : null,
                                    child: const Text("Cập nhật hình đại diện"),
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
                              onPressed: isReadonly || isInsert
                                  ? () => them(context)
                                  : null,
                              child: const Text("Thêm"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            fit: FlexFit.tight,
                            child: FilledButton(
                              style: roundButtonStyle(),
                              onPressed: isReadonly || isUpdate
                                  ? () => capNhat(context)
                                  : null,
                              child: const Text("Cập nhật"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            fit: FlexFit.tight,
                            child: FilledButton(
                              style: roundButtonStyle(),
                              onPressed: isReadonly ? () => xoa(context) : null,
                              child: const Text("Xóa"),
                            ),
                          ),
                          Visibility(
                            visible: !isReadonly,
                            child: Flexible(
                              fit: FlexFit.tight,
                              child: Row(
                                children: [
                                  const SizedBox(width: 10),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    child: FilledButton(
                                      style: roundButtonStyle(),
                                      onPressed: () => huy(),
                                      child: const Text("Hủy"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
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
    if (isInsert &&
        widget.formKey.currentState!.validate() &&
        hinhDaiDien != null) {
      DacSan.them(DacSan(
        id: 0,
        ten: widget.tenController.text,
        moTa: widget.moTaController.text,
        cachCheBien: widget.cachCheBienController.text,
        vungMien: dsVungMienTam,
        muaDacSan: dsMuaDacSanTam,
        thanhPhan: dsThanhPhanTam,
        hinhAnh: dsHinhAnhTam,
        hinhDaiDien: hinhDaiDien!,
      )).then((value) {
        if (value != null) {
          for (ThanhPhan tp in dsThanhPhanTam) {
            ThanhPhan.them(tp);
          }
          setState(() {
            dsDacSan.add(value);
            dsChonDacSan.add(false);
            taoBangDacSan();
          });
        } else {
          showNotify(context, "Thêm đặc sản thất bại");
        }
      });
    } else if (!isInsert) {
      hinhDaiDien = HinhAnh(
        id: -1,
        ten: "",
        urlHinhAnh: "",
      );
      dacSanTam = DacSan(
        id: -1,
        ten: widget.tenHinhAnhController.text,
        moTa: widget.moTaHinhAnhController.text,
        cachCheBien: widget.cachCheBienController.text,
        vungMien: dsVungMienTam,
        muaDacSan: dsMuaDacSanTam,
        thanhPhan: dsThanhPhanTam,
        hinhAnh: dsHinhAnh,
        hinhDaiDien: hinhDaiDien!,
      );
      dsDacSan.add(dacSanTam!);
      dsChonDacSan.add(true);
      taoBangDacSan();
    }
    setState(() {
      isReadonly = !isReadonly;
      isInsert = !isInsert;
    });
  }

  void capNhat(BuildContext context) {
    if (dsChonDacSan.where((element) => element).length == 1) {
      if (isUpdate) {
        if (widget.formKey.currentState!.validate() && hinhDaiDien != null) {
          int i = dsChonDacSan.indexOf(true);
          DacSan dacSan = DacSan(
            id: dsDacSan[i].id,
            ten: widget.tenController.text,
            moTa: widget.moTaController.text,
            cachCheBien: widget.cachCheBienController.text,
            vungMien: dsVungMienTam,
            muaDacSan: dsMuaDacSanTam,
            thanhPhan: dsThanhPhanTam,
            hinhAnh: dsHinhAnhTam,
            hinhDaiDien: hinhDaiDien!,
          );
          DacSan.capNhat(dacSan).then((value) {
            if (value) {
              setState(() {
                dsDacSan[i] = dacSan;
                taoBangDacSan();
              });
            } else {
              showNotify(context, "Cập nhật đặc sản thất bại");
            }
          });
          setState(() {
            isReadonly = !isReadonly;
            isUpdate = !isUpdate;
          });
        }
      } else {
        setState(() {
          DacSan temp = dsDacSan[dsChonDacSan.indexOf(true)];
          widget.tenController.text = temp.ten;
          widget.moTaController.text = temp.moTa ?? "Chưa có thông tin";
          widget.cachCheBienController.text =
              temp.cachCheBien ?? "Chưa có thông tin";
          widget.tenHinhAnhController.text = temp.hinhDaiDien.ten;
          widget.moTaHinhAnhController.text =
              temp.hinhDaiDien.moTa ?? "Chưa có thông tin";
          widget.urlHinhAnhController.text = temp.hinhDaiDien.urlHinhAnh;
          dsVungMienTam = temp.vungMien;
          dsMuaDacSanTam = temp.muaDacSan;
          dsThanhPhanTam = temp.thanhPhan;
          dsHinhAnhTam = temp.hinhAnh;
          hinhDaiDien = temp.hinhDaiDien;
          isReadonly = !isReadonly;
          isUpdate = !isUpdate;
          dacSanTam = temp;
        });
      }
    } else {
      showNotify(context, "Vui lòng chỉ chọn một dòng để cập nhật");
    }
  }

  void xoa(BuildContext context) {
    if (widget.formKey.currentState!.validate()) {
      for (int i = 0; i < dsChonDacSan.length; i++) {
        if (dsChonDacSan[i]) {
          DacSan.xoa(dsDacSan[i].id).then((value) {
            if (value) {
              setState(() {
                dsDacSan.remove(dsDacSan[i]);
                dsChonDacSan[i] = false;
                taoBangDacSan();
              });
            } else {
              showNotify(context, "Xóa đặc sản thất bại");
            }
          });
        }
      }
    }
  }

  Future<void> huy() async {
    if (isInsert) {
      int v = dsDacSan.indexOf(dacSanTam!);
      dsDacSan.remove(dsDacSan[v]);
      dsChonDacSan.remove(dsChonDacSan[v]);
    } else if (isUpdate) {
      int v = dsDacSan.indexOf(dacSanTam!);
      dsDacSan[v] = await DacSan.docTheoID(dacSanTam!.id);
      dsChonDacSan[v] = false;
    }
    setState(() {
      isReadonly = true;
      isInsert = false;
      isUpdate = false;
      taoBangDacSan();
    });
  }
}

class BangThanhPhan extends StatelessWidget {
  const BangThanhPhan({
    super.key,
    required this.dsChonDacSan,
    required this.bangThanhPhan,
  });

  final List<bool> dsChonDacSan;
  final ThanhPhanDataTableSource bangThanhPhan;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: PaginatedDataTable2(
        empty: Center(
          child: Text(dsChonDacSan.where((element) => element).length > 1
              ? "Vui lòng chỉ chọn một dòng dữ liệu"
              : "Không có dữ liệu thành phần của đặc sản này"),
        ),
        rowsPerPage: 10,
        columns: const [
          DataColumn2(
            label: Text('Tên'),
            size: ColumnSize.M,
          ),
          DataColumn2(
            label: Text('Số lượng'),
            size: ColumnSize.S,
          ),
          DataColumn2(
            label: Text('Đơn vị tính'),
            size: ColumnSize.S,
          ),
        ],
        source: bangThanhPhan,
      ),
    );
  }
}

class BangDacSan extends StatelessWidget {
  const BangDacSan({
    super.key,
    required this.isUpdate,
    required this.isInsert,
    required this.widget,
    required this.bangDacSan,
  });

  final bool isUpdate;
  final bool isInsert;
  final TrangDacSan widget;
  final DacSanDataTableSource bangDacSan;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 3,
      child: AbsorbPointer(
        absorbing: isUpdate || isInsert,
        child: PaginatedDataTable2(
          controller: widget.dacSanController,
          rowsPerPage: 10,
          columns: const [
            DataColumn2(
              label: Text('ID'),
              size: ColumnSize.S,
            ),
            DataColumn2(
              label: Text('Tên'),
              size: ColumnSize.M,
            ),
            DataColumn2(
              label: Text('Mô tả'),
              size: ColumnSize.L,
            ),
            DataColumn2(
              label: Text('Địa chỉ'),
              size: ColumnSize.L,
            ),
            DataColumn2(
              label: Text('Vùng miền'),
              size: ColumnSize.L,
            ),
            DataColumn2(
              label: Text('Mùa'),
              size: ColumnSize.L,
            ),
            DataColumn2(
              label: Text('Lượt xem'),
              size: ColumnSize.S,
              numeric: true,
            ),
            DataColumn2(
              label: Text('Điểm đánh giá'),
              size: ColumnSize.S,
              numeric: true,
            ),
            DataColumn2(
              label: Text('Lượt đánh giá'),
              size: ColumnSize.S,
              numeric: true,
            ),
          ],
          source: bangDacSan,
        ),
      ),
    );
  }
}

class DacSanDataTableSource extends DataTableSource {
  List<DacSan> dsDacSan = [];
  List<bool> selectedRowIndexs = [];
  void Function(int) notifyParent;
  DacSanDataTableSource({
    required this.dsDacSan,
    required this.selectedRowIndexs,
    required this.notifyParent,
  });
  @override
  DataRow? getRow(int index) {
    return DataRow2(
      onSelectChanged: (value) {
        selectedRowIndexs[index] = value!;
        notifyListeners();
        notifyParent(index);
      },
      selected: selectedRowIndexs[index],
      cells: [
        DataCell(Text(dsDacSan[index].id.toString())),
        DataCell(Text(dsDacSan[index].ten)),
        DataCell(Text(dsDacSan[index].moTa ?? "Chưa có thông tin")),
        DataCell(Text(dsDacSan[index].cachCheBien ?? "Chưa có thông tin")),
        DataCell(Text(
            dsDacSan[index].vungMien.map((e) => e.ten).toList().join(", "))),
        DataCell(Text(
            dsDacSan[index].muaDacSan.map((e) => e.ten).toList().join(", "))),
        DataCell(Text(dsDacSan[index].luotXem.toString())),
        DataCell(Text(dsDacSan[index].diemDanhGia.toString())),
        DataCell(Text(dsDacSan[index].luotDanhGia.toString())),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dsDacSan.length;

  @override
  int get selectedRowCount => 0;
}

class ThanhPhanDataTableSource extends DataTableSource {
  List<ThanhPhan> dsThanhPhan = [];
  List<bool> selectedRowIndexs = [];
  void Function(int) notifyParent;
  ThanhPhanDataTableSource({
    required this.dsThanhPhan,
    required this.selectedRowIndexs,
    required this.notifyParent,
  });
  @override
  DataRow? getRow(int index) {
    return DataRow2(
      onSelectChanged: (value) {
        selectedRowIndexs[index] = value!;
        notifyListeners();
        notifyParent(index);
      },
      selected: selectedRowIndexs[index],
      cells: [
        DataCell(Text(dsThanhPhan[index].nguyenLieu.ten)),
        DataCell(Text(dsThanhPhan[index].soLuong.toString())),
        DataCell(Text(dsThanhPhan[index].donViTinh)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dsThanhPhan.length;

  @override
  int get selectedRowCount => 0;
}
