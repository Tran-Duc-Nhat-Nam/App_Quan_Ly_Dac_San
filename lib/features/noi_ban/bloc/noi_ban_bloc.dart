import 'dart:developer';

import 'package:app_dac_san/core/gui_helper.dart';
import 'package:app_dac_san/features/dac_san/data/dac_san.dart';
import 'package:app_dac_san/features/tinh_thanh/data/dia_chi.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/noi_ban.dart';

part 'noi_ban_event.dart';
part 'noi_ban_state.dart';

class NoiBanBloc extends Bloc<NoiBanEvent, NoiBanState> {
  late List<NoiBan> dsNoiBan;
  late List<DacSan> dsDacSan;
  NoiBanBloc() : super(NoiBanInitial()) {
    on<LoadNoiBanEvent>((event, emit) async {
      dsNoiBan = await NoiBan.doc();
      dsDacSan = await DacSan.doc();
      emit(NoiBanLoaded(dsNoiBan.map((e) => false).toList(), NoiBan.tam()));
    });
    on<LoadDacSanEvent>((event, emit) async {
      final state = this.state as NoiBanLoaded;
      List<DacSan> dsDacSan = [];
      if (checkSingle(state.dsChonNoiBan)) {
        dsDacSan = await dsNoiBan[event.index].docDacSan();
      }
      emit(NoiBanLoaded(state.dsChonNoiBan, NoiBan.tam(),
          dsDacSan: dsDacSan,
          dsChonDacSan: dsDacSan.map((e) => false).toList()));
    });

    on<AddDacSanEvent>((event, emit) async {
      final state = this.state as NoiBanLoaded;
      List<DacSan> tempList = await state.noiBanTam.docDacSan();
      if (!tempList.any((element) => element.id == event.thanhPhan.id)) {
        NoiBan temp = state.noiBanTam.copy();
        temp.dsDacSan = [...temp.dsDacSan, event.thanhPhan.id];
        if (state.isInsert) {
          dsNoiBan.last = temp;
        } else {
          dsNoiBan[state.dsChonNoiBan.indexOf(true)] = temp;
        }
        emit(NoiBanLoaded(dsNoiBan.map((e) => false).toList(), temp,
            isInsert: state.isInsert,
            isUpdate: state.isUpdate,
            dsDacSan: [...tempList, event.thanhPhan],
            dsChonDacSan: temp.dsDacSan.map((e) => false).toList()));
      }
    });
    on<RemoveDacSanEvent>((event, emit) async {
      final state = this.state as NoiBanLoaded;
      List<DacSan> tempList = await state.noiBanTam.docDacSan();
      NoiBan temp = state.noiBanTam.copy();
      List<int> dsTemp = [...temp.dsDacSan];
      dsTemp.removeWhere((element) => element == event.dacSan.id);
      tempList.removeWhere((element) => element.id == event.dacSan.id);
      temp.dsDacSan = [...dsTemp];
      if (state.isInsert) {
        dsNoiBan.last = temp;
      } else {
        dsNoiBan[state.dsChonNoiBan.indexOf(true)] = temp;
      }
      emit(NoiBanLoaded(dsNoiBan.map((e) => false).toList(), temp,
          isInsert: state.isInsert,
          isUpdate: state.isUpdate,
          dsDacSan: tempList,
          dsChonDacSan: temp.dsDacSan.map((e) => false).toList()));
    });
    on<StartInsertEvent>((event, emit) async {
      if (state is NoiBanLoaded) {
        dsNoiBan.add(NoiBan.tam());
        emit(NoiBanLoaded(dsNoiBan.map((e) => false).toList(), NoiBan.tam(),
            isInsert: true));
      }
    });
    on<InsertEvent>((event, emit) async {
      if (state is NoiBanLoaded) {
        final state = this.state as NoiBanLoaded;
        state.noiBanTam.ten = event.ten;
        state.noiBanTam.moTa = event.moTa;
        state.noiBanTam.diaChi = event.diaChi;
        log(state.noiBanTam.diaChi.toJson().toString());
        NoiBan? noiBan = await NoiBan.them(state.noiBanTam);
        if (noiBan != null) {
          dsNoiBan.last = noiBan;
          emit(NoiBanLoaded(
            dsNoiBan.map((e) => false).toList(),
            NoiBan.tam(),
          ));
        } else {
          dsNoiBan.remove(dsNoiBan.last);
          emit(NoiBanLoaded(dsNoiBan.map((e) => false).toList(), NoiBan.tam(),
              errorMessage: "Thêm thất bại"));
        }
      }
    });
    on<StartUpdateEvent>((event, emit) async {
      if (state is NoiBanLoaded) {
        final state = this.state as NoiBanLoaded;
        List<DacSan> tempList = await state.noiBanTam.docDacSan();
        List<bool> dsChon = dsNoiBan.map((e) => false).toList();
        int index =
            dsNoiBan.indexWhere((element) => element.id == event.noiBan.id);
        dsChon[index] = true;
        emit(NoiBanLoaded(dsChon, dsNoiBan[index],
            dsDacSan: tempList, isUpdate: true));
      }
    });
    on<UpdateEnvent>((event, emit) async {
      if (state is NoiBanLoaded) {
        final state = this.state as NoiBanLoaded;
        bool kq = await NoiBan.capNhat(state.noiBanTam);
        if (kq) {
          dsNoiBan[dsNoiBan.indexWhere(
              (element) => element.id == event.noiBan.id)] = event.noiBan;
          emit(NoiBanLoaded(
            dsNoiBan.map((e) => false).toList(),
            NoiBan.tam(),
            dsDacSan: state.dsDacSan,
            dsChonDacSan: state.dsChonDacSan,
          ));
        } else {
          List<bool> dsChon = dsNoiBan.map((e) => false).toList();
          dsChon[dsNoiBan
              .indexWhere((element) => element.id == event.noiBan.id)] = true;
          emit(NoiBanLoaded(dsChon, NoiBan.tam(),
              dsDacSan: state.dsDacSan,
              dsChonDacSan: state.dsChonDacSan,
              errorMessage: "Cập nhật thất bại"));
        }
      }
    });
    on<DeleteEvent>((event, emit) async {
      if (state is NoiBanLoaded) {
        for (NoiBan element in dsNoiBan) {
          if (event.dsChon[dsNoiBan.indexOf(element)]) {
            bool kq = await NoiBan.xoa(element.id);
            if (kq) {
              event.dsChon[dsNoiBan.indexOf(element)] = false;
              dsNoiBan.remove(element);
            } else {
              emit(NoiBanLoaded(event.dsChon, NoiBan.tam(),
                  errorMessage: "Xóa thất bại"));
              break;
            }
          }
        }
        emit(NoiBanLoaded(
          dsNoiBan.map((e) => false).toList(),
          NoiBan.tam(),
        ));
      }
    });
    on<StopEditEvent>((event, emit) async {
      if (state is NoiBanLoaded) {
        if (dsNoiBan.last.id == -1) {
          dsNoiBan.remove(dsNoiBan.last);
        }
        emit(NoiBanLoaded(
          dsNoiBan.map((e) => false).toList(),
          NoiBan.tam(),
        ));
      }
    });
  }
}
