import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/tinh_thanh.dart';

part 'tinh_thanh_event.dart';
part 'tinh_thanh_state.dart';

class TinhThanhBloc extends Bloc<TinhThanhEvent, TinhThanhState> {
  TinhThanhBloc() : super(TinhThanhInitial()) {
    on<LoadDataEvent>((event, emit) async {
      List<TinhThanh> dsTinhThanh = [];
      log("Getting data from API...");
      dsTinhThanh = await TinhThanh.doc();
      log("Gotten all data from API...");
      emit(
          TinhThanhLoaded(dsTinhThanh, dsTinhThanh.map((e) => false).toList()));
    });
    on<StartInsertEvent>((event, emit) {
      if (state is TinhThanhLoaded) {
        final state = this.state as TinhThanhLoaded;
        List<TinhThanh> dsTinhThanh = state.dsTinhThanh;
        dsTinhThanh.add(TinhThanh(id: -1, ten: ""));
        emit(TinhThanhLoaded(
            dsTinhThanh, dsTinhThanh.map((e) => false).toList(),
            isInsert: true));
      }
    });
    on<InsertEvent>((event, emit) async {
      if (state is TinhThanhLoaded) {
        TinhThanh? tinhThanh = await TinhThanh.them(event.tinhThanh.ten);
        final state = this.state as TinhThanhLoaded;
        List<TinhThanh> dsTinhThanh = state.dsTinhThanh;
        if (tinhThanh != null) {
          dsTinhThanh.last = tinhThanh;
          emit(TinhThanhLoaded(
              dsTinhThanh, dsTinhThanh.map((e) => false).toList()));
        } else {
          dsTinhThanh.remove(dsTinhThanh.last);
          emit(TinhThanhLoaded(
              dsTinhThanh, dsTinhThanh.map((e) => false).toList(),
              errorMessage: "Thêm thất bại"));
        }
      }
    });
    on<StartUpdateEvent>((event, emit) {
      if (state is TinhThanhLoaded) {
        final state = this.state as TinhThanhLoaded;
        List<TinhThanh> dsTinhThanh = state.dsTinhThanh;
        List<bool> dsChon = dsTinhThanh.map((e) => false).toList();
        dsChon[dsTinhThanh
            .indexWhere((element) => element.id == event.tinhThanh.id)] = true;
        emit(TinhThanhLoaded(dsTinhThanh, dsChon, isUpdate: true));
      }
    });
    on<UpdateEnvent>((event, emit) async {
      if (state is TinhThanhLoaded) {
        bool kq = await TinhThanh.capNhat(event.tinhThanh);
        final state = this.state as TinhThanhLoaded;
        List<TinhThanh> dsTinhThanh = state.dsTinhThanh;
        if (kq) {
          dsTinhThanh[dsTinhThanh.indexWhere(
              (element) => element.id == event.tinhThanh.id)] = event.tinhThanh;
          emit(TinhThanhLoaded(
              dsTinhThanh, dsTinhThanh.map((e) => false).toList()));
        } else {
          List<bool> dsChon = dsTinhThanh.map((e) => false).toList();
          dsChon[dsTinhThanh.indexWhere(
              (element) => element.id == event.tinhThanh.id)] = true;
          emit(TinhThanhLoaded(state.dsTinhThanh, dsChon,
              errorMessage: "Cập nhật thất bại"));
        }
      }
    });
    on<DeleteEvent>((event, emit) async {
      if (state is TinhThanhLoaded) {
        final state = this.state as TinhThanhLoaded;
        List<TinhThanh> dsTinhThanh = state.dsTinhThanh;
        for (TinhThanh element in dsTinhThanh) {
          if (event.dsChon[dsTinhThanh.indexOf(element)]) {
            bool kq = await TinhThanh.xoa(element.id);
            if (kq) {
              event.dsChon[dsTinhThanh.indexOf(element)] = false;
              dsTinhThanh.remove(element);
            } else {
              emit(TinhThanhLoaded(dsTinhThanh, event.dsChon,
                  errorMessage: "Xóa thất bại"));
              break;
            }
          }
        }
        emit(TinhThanhLoaded(
            dsTinhThanh, dsTinhThanh.map((e) => false).toList()));
      }
    });
    on<StopEditEvent>((event, emit) async {
      if (state is TinhThanhLoaded) {
        final state = this.state as TinhThanhLoaded;
        List<TinhThanh> dsTinhThanh = state.dsTinhThanh;
        if (dsTinhThanh.last.id == -1) {
          dsTinhThanh.remove(dsTinhThanh.last);
        }
        emit(TinhThanhLoaded(
            dsTinhThanh, dsTinhThanh.map((e) => false).toList()));
      }
    });
  }
}
