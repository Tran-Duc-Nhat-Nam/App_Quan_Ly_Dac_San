import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/nguoi_dung.dart';

part 'nguoi_dung_event.dart';
part 'nguoi_dung_state.dart';

class NguoiDungBloc extends Bloc<NguoiDungEvent, NguoiDungState> {
  NguoiDungBloc() : super(NguoiDungInitial()) {
    on<LoadDataEvent>((event, emit) async {
      List<NguoiDung> dsNguoiDung = [];
      log("Getting data from API...");
      dsNguoiDung = await NguoiDung.doc();
      log("Gotten all data from API...");
      emit(
          NguoiDungLoaded(dsNguoiDung, dsNguoiDung.map((e) => false).toList()));
    });
    on<StartInsertEvent>((event, emit) {
      if (state is NguoiDungLoaded) {
        final state = this.state as NguoiDungLoaded;
        List<NguoiDung> dsNguoiDung = state.dsNguoiDung;
        dsNguoiDung.add(NguoiDung.tam());
        emit(NguoiDungLoaded(
            dsNguoiDung, dsNguoiDung.map((e) => false).toList(),
            isInsert: true));
      }
    });
    on<InsertEvent>((event, emit) async {
      if (state is NguoiDungLoaded) {
        NguoiDung? nguoiDung = await NguoiDung.them(event.nguoiDung);
        final state = this.state as NguoiDungLoaded;
        List<NguoiDung> dsNguoiDung = state.dsNguoiDung;
        if (nguoiDung != null) {
          dsNguoiDung.last = nguoiDung;
          emit(NguoiDungLoaded(
              dsNguoiDung, dsNguoiDung.map((e) => false).toList()));
        } else {
          dsNguoiDung.remove(dsNguoiDung.last);
          emit(NguoiDungLoaded(
              dsNguoiDung, dsNguoiDung.map((e) => false).toList(),
              errorMessage: "Thêm thất bại"));
        }
      }
    });
    on<StartUpdateEvent>((event, emit) {
      if (state is NguoiDungLoaded) {
        final state = this.state as NguoiDungLoaded;
        List<NguoiDung> dsNguoiDung = state.dsNguoiDung;
        List<bool> dsChon = dsNguoiDung.map((e) => false).toList();
        dsChon[dsNguoiDung
            .indexWhere((element) => element.id == event.nguoiDung.id)] = true;
        emit(NguoiDungLoaded(dsNguoiDung, dsChon, isUpdate: true));
      }
    });
    on<UpdateEnvent>((event, emit) async {
      if (state is NguoiDungLoaded) {
        bool kq = await NguoiDung.capNhat(event.nguoiDung);
        final state = this.state as NguoiDungLoaded;
        List<NguoiDung> dsNguoiDung = state.dsNguoiDung;
        if (kq) {
          dsNguoiDung[dsNguoiDung.indexWhere(
              (element) => element.id == event.nguoiDung.id)] = event.nguoiDung;
          emit(NguoiDungLoaded(
              dsNguoiDung, dsNguoiDung.map((e) => false).toList()));
        } else {
          List<bool> dsChon = dsNguoiDung.map((e) => false).toList();
          dsChon[dsNguoiDung.indexWhere(
              (element) => element.id == event.nguoiDung.id)] = true;
          emit(NguoiDungLoaded(state.dsNguoiDung, dsChon,
              errorMessage: "Cập nhật thất bại"));
        }
      }
    });
    on<DeleteEvent>((event, emit) async {
      if (state is NguoiDungLoaded) {
        final state = this.state as NguoiDungLoaded;
        List<NguoiDung> dsNguoiDung = state.dsNguoiDung;
        for (NguoiDung element in dsNguoiDung) {
          if (event.dsChon[dsNguoiDung.indexOf(element)]) {
            bool kq = await NguoiDung.xoa(element.id);
            if (kq) {
              event.dsChon[dsNguoiDung.indexOf(element)] = false;
              dsNguoiDung.remove(element);
            } else {
              emit(NguoiDungLoaded(dsNguoiDung, event.dsChon,
                  errorMessage: "Xóa thất bại"));
              break;
            }
          }
        }
        emit(NguoiDungLoaded(
            dsNguoiDung, dsNguoiDung.map((e) => false).toList()));
      }
    });
    on<StopEditEvent>((event, emit) async {
      if (state is NguoiDungLoaded) {
        final state = this.state as NguoiDungLoaded;
        List<NguoiDung> dsNguoiDung = state.dsNguoiDung;
        if (dsNguoiDung.last.id == -1) {
          dsNguoiDung.remove(dsNguoiDung.last);
        }
        emit(NguoiDungLoaded(
            dsNguoiDung, dsNguoiDung.map((e) => false).toList()));
      }
    });
  }
}
