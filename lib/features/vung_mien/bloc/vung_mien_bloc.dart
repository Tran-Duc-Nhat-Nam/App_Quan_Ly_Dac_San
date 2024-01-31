import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/vung_mien.dart';

part 'vung_mien_event.dart';
part 'vung_mien_state.dart';

class VungMienBloc extends Bloc<VungMienEvent, VungMienState> {
  VungMienBloc() : super(VungMienInitial()) {
    on<LoadDataEvent>((event, emit) async {
      List<VungMien> dsVungMien = [];
      log("Getting data from API...");
      dsVungMien = await VungMien.doc();
      log("Gotten all data from API...");
      emit(VungMienLoaded(dsVungMien, dsVungMien.map((e) => false).toList()));
    });
    on<StartInsertEvent>((event, emit) {
      if (state is VungMienLoaded) {
        final state = this.state as VungMienLoaded;
        List<VungMien> dsVungMien = state.dsVungMien;
        dsVungMien.add(VungMien(id: -1, ten: ""));
        emit(VungMienLoaded(dsVungMien, dsVungMien.map((e) => false).toList(),
            isInsert: true));
      }
    });
    on<InsertEvent>((event, emit) async {
      if (state is VungMienLoaded) {
        VungMien? vungMien = await VungMien.them(event.vungMien.ten);
        final state = this.state as VungMienLoaded;
        List<VungMien> dsVungMien = state.dsVungMien;
        if (vungMien != null) {
          dsVungMien.last = vungMien;
          emit(VungMienLoaded(
              dsVungMien, dsVungMien.map((e) => false).toList()));
        } else {
          dsVungMien.remove(dsVungMien.last);
          emit(VungMienLoaded(dsVungMien, dsVungMien.map((e) => false).toList(),
              errorMessage: "Thêm thất bại"));
        }
      }
    });
    on<StartUpdateEvent>((event, emit) {
      if (state is VungMienLoaded) {
        final state = this.state as VungMienLoaded;
        List<VungMien> dsVungMien = state.dsVungMien;
        List<bool> dsChon = dsVungMien.map((e) => false).toList();
        dsChon[dsVungMien
            .indexWhere((element) => element.id == event.vungMien.id)] = true;
        emit(VungMienLoaded(dsVungMien, dsChon, isUpdate: true));
      }
    });
    on<UpdateEnvent>((event, emit) async {
      if (state is VungMienLoaded) {
        bool kq = await VungMien.capNhat(event.vungMien);
        final state = this.state as VungMienLoaded;
        List<VungMien> dsVungMien = state.dsVungMien;
        if (kq) {
          dsVungMien[dsVungMien.indexWhere(
              (element) => element.id == event.vungMien.id)] = event.vungMien;
          emit(VungMienLoaded(
              dsVungMien, dsVungMien.map((e) => false).toList()));
        } else {
          List<bool> dsChon = dsVungMien.map((e) => false).toList();
          dsChon[dsVungMien
              .indexWhere((element) => element.id == event.vungMien.id)] = true;
          emit(VungMienLoaded(state.dsVungMien, dsChon,
              errorMessage: "Cập nhật thất bại"));
        }
      }
    });
    on<DeleteEvent>((event, emit) async {
      if (state is VungMienLoaded) {
        final state = this.state as VungMienLoaded;
        List<VungMien> dsVungMien = state.dsVungMien;
        for (VungMien element in dsVungMien) {
          if (event.dsChon[dsVungMien.indexOf(element)]) {
            bool kq = await VungMien.xoa(element.id);
            if (kq) {
              event.dsChon[dsVungMien.indexOf(element)] = false;
              dsVungMien.remove(element);
            } else {
              emit(VungMienLoaded(dsVungMien, event.dsChon,
                  errorMessage: "Xóa thất bại"));
              break;
            }
          }
        }
        emit(VungMienLoaded(dsVungMien, dsVungMien.map((e) => false).toList()));
      }
    });
    on<StopEditEvent>((event, emit) async {
      if (state is VungMienLoaded) {
        final state = this.state as VungMienLoaded;
        List<VungMien> dsVungMien = state.dsVungMien;
        if (dsVungMien.last.id == -1) {
          dsVungMien.remove(dsVungMien.last);
        }
        emit(VungMienLoaded(dsVungMien, dsVungMien.map((e) => false).toList()));
      }
    });
  }
}
