import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/nguyen_lieu.dart';

part 'nguyen_lieu_event.dart';
part 'nguyen_lieu_state.dart';

class NguyenLieuBloc extends Bloc<NguyenLieuEvent, NguyenLieuState> {
  NguyenLieuBloc() : super(NguyenLieuInitial()) {
    on<LoadDataEvent>((event, emit) async {
      List<NguyenLieu> dsNguyenLieu = [];
      log("Getting data from API...");
      dsNguyenLieu = await NguyenLieu.doc();
      log("Gotten all data from API...");
      emit(NguyenLieuLoaded(
          dsNguyenLieu, dsNguyenLieu.map((e) => false).toList()));
    });
    on<StartInsertEvent>((event, emit) {
      if (state is NguyenLieuLoaded) {
        final state = this.state as NguyenLieuLoaded;
        List<NguyenLieu> dsNguyenLieu = state.dsNguyenLieu;
        dsNguyenLieu.add(NguyenLieu(id: -1, ten: ""));
        emit(NguyenLieuLoaded(
            dsNguyenLieu, dsNguyenLieu.map((e) => false).toList(),
            isInsert: true));
      }
    });
    on<InsertEvent>((event, emit) async {
      if (state is NguyenLieuLoaded) {
        NguyenLieu? nguyenLieu = await NguyenLieu.them(event.nguyenLieu.ten);
        final state = this.state as NguyenLieuLoaded;
        List<NguyenLieu> dsNguyenLieu = state.dsNguyenLieu;
        if (nguyenLieu != null) {
          dsNguyenLieu.last = nguyenLieu;
          emit(NguyenLieuLoaded(
              dsNguyenLieu, dsNguyenLieu.map((e) => false).toList()));
        } else {
          dsNguyenLieu.remove(dsNguyenLieu.last);
          emit(NguyenLieuLoaded(
              dsNguyenLieu, dsNguyenLieu.map((e) => false).toList(),
              errorMessage: "Thêm thất bại"));
        }
      }
    });
    on<StartUpdateEvent>((event, emit) {
      if (state is NguyenLieuLoaded) {
        final state = this.state as NguyenLieuLoaded;
        List<NguyenLieu> dsNguyenLieu = state.dsNguyenLieu;
        List<bool> dsChon = dsNguyenLieu.map((e) => false).toList();
        dsChon[dsNguyenLieu
            .indexWhere((element) => element.id == event.nguyenLieu.id)] = true;
        emit(NguyenLieuLoaded(dsNguyenLieu, dsChon, isUpdate: true));
      }
    });
    on<UpdateEnvent>((event, emit) async {
      if (state is NguyenLieuLoaded) {
        bool kq = await NguyenLieu.capNhat(event.nguyenLieu);
        final state = this.state as NguyenLieuLoaded;
        List<NguyenLieu> dsNguyenLieu = state.dsNguyenLieu;
        if (kq) {
          dsNguyenLieu[dsNguyenLieu
                  .indexWhere((element) => element.id == event.nguyenLieu.id)] =
              event.nguyenLieu;
          emit(NguyenLieuLoaded(
              dsNguyenLieu, dsNguyenLieu.map((e) => false).toList()));
        } else {
          List<bool> dsChon = dsNguyenLieu.map((e) => false).toList();
          dsChon[dsNguyenLieu.indexWhere(
              (element) => element.id == event.nguyenLieu.id)] = true;
          emit(NguyenLieuLoaded(state.dsNguyenLieu, dsChon,
              errorMessage: "Cập nhật thất bại"));
        }
      }
    });
    on<DeleteEvent>((event, emit) async {
      if (state is NguyenLieuLoaded) {
        final state = this.state as NguyenLieuLoaded;
        List<NguyenLieu> dsNguyenLieu = state.dsNguyenLieu;
        for (NguyenLieu element in dsNguyenLieu) {
          if (event.dsChon[dsNguyenLieu.indexOf(element)]) {
            bool kq = await NguyenLieu.xoa(element.id);
            if (kq) {
              event.dsChon[dsNguyenLieu.indexOf(element)] = false;
              dsNguyenLieu.remove(element);
            } else {
              emit(NguyenLieuLoaded(dsNguyenLieu, event.dsChon,
                  errorMessage: "Xóa thất bại"));
              break;
            }
          }
        }
        emit(NguyenLieuLoaded(
            dsNguyenLieu, dsNguyenLieu.map((e) => false).toList()));
      }
    });
    on<StopEditEvent>((event, emit) async {
      if (state is NguyenLieuLoaded) {
        final state = this.state as NguyenLieuLoaded;
        List<NguyenLieu> dsNguyenLieu = state.dsNguyenLieu;
        if (dsNguyenLieu.last.id == -1) {
          dsNguyenLieu.remove(dsNguyenLieu.last);
        }
        emit(NguyenLieuLoaded(
            dsNguyenLieu, dsNguyenLieu.map((e) => false).toList()));
      }
    });
  }
}
