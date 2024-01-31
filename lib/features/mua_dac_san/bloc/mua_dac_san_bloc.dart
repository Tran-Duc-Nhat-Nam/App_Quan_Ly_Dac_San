import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/mua_dac_san.dart';

part 'mua_dac_san_event.dart';
part 'mua_dac_san_state.dart';

class MuaDacSanBloc extends Bloc<MuaDacSanEvent, MuaDacSanState> {
  MuaDacSanBloc() : super(MuaDacSanInitial()) {
    on<LoadDataEvent>((event, emit) async {
      List<MuaDacSan> dsMuaDacSan = [];
      log("Getting data from API...");
      dsMuaDacSan = await MuaDacSan.doc();
      log("Gotten all data from API...");
      emit(
          MuaDacSanLoaded(dsMuaDacSan, dsMuaDacSan.map((e) => false).toList()));
    });
    on<StartInsertEvent>((event, emit) {
      if (state is MuaDacSanLoaded) {
        final state = this.state as MuaDacSanLoaded;
        List<MuaDacSan> dsMuaDacSan = state.dsMuaDacSan;
        dsMuaDacSan.add(MuaDacSan(id: -1, ten: ""));
        emit(MuaDacSanLoaded(
            dsMuaDacSan, dsMuaDacSan.map((e) => false).toList(),
            isInsert: true));
      }
    });
    on<InsertEvent>((event, emit) async {
      if (state is MuaDacSanLoaded) {
        MuaDacSan? muaDacSan = await MuaDacSan.them(event.muaDacSan.ten);
        final state = this.state as MuaDacSanLoaded;
        List<MuaDacSan> dsMuaDacSan = state.dsMuaDacSan;
        if (muaDacSan != null) {
          dsMuaDacSan.last = muaDacSan;
          emit(MuaDacSanLoaded(
              dsMuaDacSan, dsMuaDacSan.map((e) => false).toList()));
        } else {
          dsMuaDacSan.remove(dsMuaDacSan.last);
          emit(MuaDacSanLoaded(
              dsMuaDacSan, dsMuaDacSan.map((e) => false).toList(),
              errorMessage: "Thêm thất bại"));
        }
      }
    });
    on<StartUpdateEvent>((event, emit) {
      if (state is MuaDacSanLoaded) {
        final state = this.state as MuaDacSanLoaded;
        List<MuaDacSan> dsMuaDacSan = state.dsMuaDacSan;
        List<bool> dsChon = dsMuaDacSan.map((e) => false).toList();
        dsChon[dsMuaDacSan
            .indexWhere((element) => element.id == event.muaDacSan.id)] = true;
        emit(MuaDacSanLoaded(dsMuaDacSan, dsChon, isUpdate: true));
      }
    });
    on<UpdateEnvent>((event, emit) async {
      if (state is MuaDacSanLoaded) {
        bool kq = await MuaDacSan.capNhat(event.muaDacSan);
        final state = this.state as MuaDacSanLoaded;
        List<MuaDacSan> dsMuaDacSan = state.dsMuaDacSan;
        if (kq) {
          dsMuaDacSan[dsMuaDacSan.indexWhere(
              (element) => element.id == event.muaDacSan.id)] = event.muaDacSan;
          emit(MuaDacSanLoaded(
              dsMuaDacSan, dsMuaDacSan.map((e) => false).toList()));
        } else {
          List<bool> dsChon = dsMuaDacSan.map((e) => false).toList();
          dsChon[dsMuaDacSan.indexWhere(
              (element) => element.id == event.muaDacSan.id)] = true;
          emit(MuaDacSanLoaded(state.dsMuaDacSan, dsChon,
              errorMessage: "Cập nhật thất bại"));
        }
      }
    });
    on<DeleteEvent>((event, emit) async {
      if (state is MuaDacSanLoaded) {
        final state = this.state as MuaDacSanLoaded;
        List<MuaDacSan> dsMuaDacSan = state.dsMuaDacSan;
        for (MuaDacSan element in dsMuaDacSan) {
          if (event.dsChon[dsMuaDacSan.indexOf(element)]) {
            bool kq = await MuaDacSan.xoa(element.id);
            if (kq) {
              event.dsChon[dsMuaDacSan.indexOf(element)] = false;
              dsMuaDacSan.remove(element);
            } else {
              emit(MuaDacSanLoaded(dsMuaDacSan, event.dsChon,
                  errorMessage: "Xóa thất bại"));
              break;
            }
          }
        }
        emit(MuaDacSanLoaded(
            dsMuaDacSan, dsMuaDacSan.map((e) => false).toList()));
      }
    });
    on<StopEditEvent>((event, emit) async {
      if (state is MuaDacSanLoaded) {
        final state = this.state as MuaDacSanLoaded;
        List<MuaDacSan> dsMuaDacSan = state.dsMuaDacSan;
        if (dsMuaDacSan.last.id == -1) {
          dsMuaDacSan.remove(dsMuaDacSan.last);
        }
        emit(MuaDacSanLoaded(
            dsMuaDacSan, dsMuaDacSan.map((e) => false).toList()));
      }
    });
  }
}
