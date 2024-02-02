import 'dart:developer';

import 'package:app_dac_san/features/tinh_thanh/data/quan_huyen.dart';
import 'package:app_dac_san/features/tinh_thanh/data/tinh_thanh.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'quan_huyen_event.dart';
part 'quan_huyen_state.dart';

class QuanHuyenBloc extends Bloc<QuanHuyenEvent, QuanHuyenState> {
  QuanHuyenBloc() : super(QuanHuyenInitial()) {
    on<LoadQuanHuyenEvent>((event, emit) async {
      emit(QuanHuyenLoading());
      List<QuanHuyen> dsQuanHuyen = [];
      log("Getting data from API...");
      dsQuanHuyen = await QuanHuyen.doc(event.tinhThanh.id);
      log("Gotten all data from API...");
      emit(
          QuanHuyenLoaded(dsQuanHuyen, dsQuanHuyen.map((e) => false).toList()));
    });
  }
}
