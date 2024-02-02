import 'package:app_dac_san/core/gui_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../mua_dac_san/data/mua_dac_san.dart';
import '../../nguyen_lieu/data/nguyen_lieu.dart';
import '../../vung_mien/data/vung_mien.dart';
import '../data/dac_san.dart';
import '../data/hinh_anh.dart';
import '../data/thanh_phan.dart';

part 'dac_san_event.dart';
part 'dac_san_state.dart';

class DacSanBloc extends Bloc<DacSanEvent, DacSanState> {
  late List<DacSan> dsDacSan;
  late List<VungMien> dsVungMien;
  late List<MuaDacSan> dsMuaDacSan;
  late List<NguyenLieu> dsNguyenLieu;
  DacSanBloc() : super(DacSanInitial()) {
    on<LoadDacSanEvent>((event, emit) async {
      dsDacSan = await DacSan.doc();
      dsVungMien = await VungMien.doc();
      dsMuaDacSan = await MuaDacSan.doc();
      dsNguyenLieu = await NguyenLieu.doc();
      emit(DacSanLoaded(dsDacSan.map((e) => false).toList(), DacSan.tam()));
    });
    on<LoadThanhPhanEvent>((event, emit) async {
      final state = this.state as DacSanLoaded;
      List<ThanhPhan> dsThanhPhan = [];
      if (checkSingle(state.dsChonDacSan)) {
        dsThanhPhan = dsDacSan[event.index].thanhPhan;
      }
      emit(DacSanLoaded(state.dsChonDacSan, DacSan.tam(),
          dsThanhPhan: dsThanhPhan,
          dsChonThanhPhan:
              dsDacSan[event.index].thanhPhan.map((e) => false).toList()));
    });
    on<AddVungMienEvent>((event, emit) async {
      final state = this.state as DacSanLoaded;
      if (!state.dacSanTam.vungMien
          .any((element) => element.id == event.vungMien.id)) {
        DacSan temp = state.dacSanTam.copy();
        temp.vungMien = [...temp.vungMien, event.vungMien];
        if (state.isInsert) {
          dsDacSan.last = temp;
        } else {
          dsDacSan[state.dsChonDacSan.indexOf(true)] = temp;
        }
        emit(DacSanLoaded(dsDacSan.map((e) => false).toList(), temp,
            isInsert: state.isInsert,
            isUpdate: state.isUpdate,
            dsThanhPhan: state.dsThanhPhan,
            dsChonThanhPhan: state.dsChonThanhPhan));
      }
    });
    on<AddMuaDacSanEvent>((event, emit) async {
      final state = this.state as DacSanLoaded;
      if (!state.dacSanTam.muaDacSan
          .any((element) => element.id == event.muaDacSan.id)) {
        DacSan temp = state.dacSanTam.copy();
        temp.muaDacSan = [...temp.muaDacSan, event.muaDacSan];
        if (state.isInsert) {
          dsDacSan.last = temp;
        } else {
          dsDacSan[state.dsChonDacSan.indexOf(true)] = temp;
        }
        emit(DacSanLoaded(dsDacSan.map((e) => false).toList(), temp,
            isInsert: state.isInsert,
            isUpdate: state.isUpdate,
            dsThanhPhan: state.dsThanhPhan,
            dsChonThanhPhan: state.dsChonThanhPhan));
      }
    });
    on<AddThanhPhanEvent>((event, emit) async {
      final state = this.state as DacSanLoaded;
      if (!state.dacSanTam.thanhPhan.any((element) =>
          element.nguyenLieu.id == event.thanhPhan.nguyenLieu.id)) {
        DacSan temp = state.dacSanTam.copy();
        temp.thanhPhan = [...temp.thanhPhan, event.thanhPhan];
        if (state.isInsert) {
          dsDacSan.last = temp;
        } else {
          dsDacSan[state.dsChonDacSan.indexOf(true)] = temp;
        }
        emit(DacSanLoaded(dsDacSan.map((e) => false).toList(), temp,
            isInsert: state.isInsert,
            isUpdate: state.isUpdate,
            dsThanhPhan: temp.thanhPhan,
            dsChonThanhPhan: temp.thanhPhan.map((e) => false).toList()));
      }
    });
    on<AddHinhAnhEvent>((event, emit) async {
      final state = this.state as DacSanLoaded;
      DacSan temp = state.dacSanTam.copy();
      temp.hinhAnh = [...temp.hinhAnh, event.hinhAnh];
      if (state.isInsert) {
        dsDacSan.last = temp;
      } else {
        dsDacSan[state.dsChonDacSan.indexOf(true)] = temp;
      }
      emit(DacSanLoaded(dsDacSan.map((e) => false).toList(), temp,
          isInsert: state.isInsert,
          isUpdate: state.isUpdate,
          dsThanhPhan: state.dsThanhPhan,
          dsChonThanhPhan: state.dsChonThanhPhan));
    });
    on<AddHinhDaiDienEvent>((event, emit) async {
      final state = this.state as DacSanLoaded;
      DacSan temp = state.dacSanTam.copy();
      temp.hinhDaiDien = event.hinhAnh;
      if (state.isInsert) {
        dsDacSan.last = temp;
      } else {
        dsDacSan[state.dsChonDacSan.indexOf(true)] = temp;
      }
      emit(DacSanLoaded(dsDacSan.map((e) => false).toList(), temp,
          isInsert: state.isInsert,
          isUpdate: state.isUpdate,
          dsThanhPhan: state.dsThanhPhan,
          dsChonThanhPhan: state.dsChonThanhPhan));
    });
    on<RemoveVungMienEvent>((event, emit) async {
      final state = this.state as DacSanLoaded;
      DacSan temp = state.dacSanTam.copy();
      List<VungMien> dsTemp = [...temp.vungMien];
      dsTemp.remove(event.vungMien);
      temp.vungMien = [...dsTemp];
      if (state.isInsert) {
        dsDacSan.last = temp;
      } else {
        dsDacSan[state.dsChonDacSan.indexOf(true)] = temp;
      }
      emit(DacSanLoaded(dsDacSan.map((e) => false).toList(), temp,
          isInsert: state.isInsert,
          isUpdate: state.isUpdate,
          dsThanhPhan: state.dsThanhPhan,
          dsChonThanhPhan: state.dsChonThanhPhan));
    });
    on<RemoveMuaDacSanEvent>((event, emit) async {
      final state = this.state as DacSanLoaded;
      DacSan temp = state.dacSanTam.copy();
      List<MuaDacSan> dsTemp = [...temp.muaDacSan];
      dsTemp.remove(event.muaDacSan);
      temp.muaDacSan = [...dsTemp];
      if (state.isInsert) {
        dsDacSan.last = temp;
      } else {
        dsDacSan[state.dsChonDacSan.indexOf(true)] = temp;
      }
      emit(DacSanLoaded(dsDacSan.map((e) => false).toList(), temp,
          isInsert: state.isInsert,
          isUpdate: state.isUpdate,
          dsThanhPhan: state.dsThanhPhan,
          dsChonThanhPhan: state.dsChonThanhPhan));
    });
    on<RemoveThanhPhanEvent>((event, emit) async {
      final state = this.state as DacSanLoaded;
      DacSan temp = state.dacSanTam.copy();
      List<ThanhPhan> dsTemp = [...temp.thanhPhan];
      dsTemp.removeWhere(
          (element) => element.nguyenLieu.id == event.thanhPhan.nguyenLieu.id);
      temp.thanhPhan = [...dsTemp];
      if (state.isInsert) {
        dsDacSan.last = temp;
      } else {
        dsDacSan[state.dsChonDacSan.indexOf(true)] = temp;
      }
      emit(DacSanLoaded(dsDacSan.map((e) => false).toList(), temp,
          isInsert: state.isInsert,
          isUpdate: state.isUpdate,
          dsThanhPhan: temp.thanhPhan,
          dsChonThanhPhan: temp.thanhPhan.map((e) => false).toList()));
    });
    on<RemoveHinhAnhEvent>((event, emit) async {
      final state = this.state as DacSanLoaded;
      DacSan temp = state.dacSanTam.copy();
      List<HinhAnh> dsTemp = [...temp.hinhAnh];
      dsTemp.remove(event.hinhAnh);
      temp.hinhAnh = [...dsTemp];
      emit(DacSanLoaded(dsDacSan.map((e) => false).toList(), state.dacSanTam,
          isInsert: state.isInsert,
          isUpdate: state.isUpdate,
          dsThanhPhan: state.dsThanhPhan,
          dsChonThanhPhan: state.dsChonThanhPhan));
    });
    on<StartInsertEvent>((event, emit) {
      if (state is DacSanLoaded) {
        final state = this.state as DacSanLoaded;
        dsDacSan.add(DacSan.tam());
        emit(DacSanLoaded(dsDacSan.map((e) => false).toList(), DacSan.tam(),
            isInsert: true,
            dsThanhPhan: state.dsThanhPhan,
            dsChonThanhPhan: state.dsChonThanhPhan));
      }
    });
    on<InsertEvent>((event, emit) async {
      if (state is DacSanLoaded) {
        final state = this.state as DacSanLoaded;
        state.dacSanTam.ten = event.ten;
        state.dacSanTam.moTa = event.moTa;
        state.dacSanTam.cachCheBien = event.cachCheBien;
        DacSan? dacSan = await DacSan.them(state.dacSanTam);
        if (dacSan != null) {
          dsDacSan.last = dacSan;
          emit(DacSanLoaded(
            dsDacSan.map((e) => false).toList(),
            DacSan.tam(),
            dsThanhPhan: state.dsThanhPhan,
            dsChonThanhPhan: state.dsChonThanhPhan,
          ));
        } else {
          dsDacSan.remove(dsDacSan.last);
          emit(DacSanLoaded(dsDacSan.map((e) => false).toList(), DacSan.tam(),
              dsThanhPhan: state.dsThanhPhan,
              dsChonThanhPhan: state.dsChonThanhPhan,
              errorMessage: "Thêm thất bại"));
        }
      }
    });
    on<StartUpdateEvent>((event, emit) {
      if (state is DacSanLoaded) {
        List<bool> dsChon = dsDacSan.map((e) => false).toList();
        int index =
            dsDacSan.indexWhere((element) => element.id == event.dacSan.id);
        dsChon[index] = true;
        emit(DacSanLoaded(dsChon, dsDacSan[index],
            dsThanhPhan: dsDacSan[index].thanhPhan, isUpdate: true));
      }
    });
    on<UpdateEnvent>((event, emit) async {
      if (state is DacSanLoaded) {
        final state = this.state as DacSanLoaded;
        bool kq = await DacSan.capNhat(state.dacSanTam);
        if (kq) {
          dsDacSan[dsDacSan.indexWhere(
              (element) => element.id == event.dacSan.id)] = event.dacSan;
          emit(DacSanLoaded(
            dsDacSan.map((e) => false).toList(),
            DacSan.tam(),
            dsThanhPhan: state.dsThanhPhan,
            dsChonThanhPhan: state.dsChonThanhPhan,
          ));
        } else {
          List<bool> dsChon = dsDacSan.map((e) => false).toList();
          dsChon[dsDacSan
              .indexWhere((element) => element.id == event.dacSan.id)] = true;
          emit(DacSanLoaded(dsChon, DacSan.tam(),
              dsThanhPhan: state.dsThanhPhan,
              dsChonThanhPhan: state.dsChonThanhPhan,
              errorMessage: "Cập nhật thất bại"));
        }
      }
    });
    on<DeleteEvent>((event, emit) async {
      if (state is DacSanLoaded) {
        for (DacSan element in dsDacSan) {
          if (event.dsChon[dsDacSan.indexOf(element)]) {
            bool kq = await DacSan.xoa(element.id);
            if (kq) {
              event.dsChon[dsDacSan.indexOf(element)] = false;
              dsDacSan.remove(element);
            } else {
              emit(DacSanLoaded(event.dsChon, DacSan.tam(),
                  errorMessage: "Xóa thất bại"));
              break;
            }
          }
        }
        emit(DacSanLoaded(
          dsDacSan.map((e) => false).toList(),
          DacSan.tam(),
        ));
      }
    });
    on<StopEditEvent>((event, emit) async {
      if (state is DacSanLoaded) {
        if (dsDacSan.last.id == -1) {
          dsDacSan.remove(dsDacSan.last);
        }
        emit(DacSanLoaded(
          dsDacSan.map((e) => false).toList(),
          DacSan.tam(),
        ));
      }
    });
  }
}
