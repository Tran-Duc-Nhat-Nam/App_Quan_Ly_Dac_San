import 'dart:developer';

import 'package:app_dac_san/features/tinh_thanh/data/quan_huyen.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/phuong_xa.dart';

part 'phuong_xa_event.dart';
part 'phuong_xa_state.dart';

class PhuongXaBloc extends Bloc<PhuongXaEvent, PhuongXaState> {
  PhuongXaBloc() : super(PhuongXaInitial()) {
    on<LoadPhuongXaEvent>((event, emit) async {
      emit(PhuongXaLoading());
      List<PhuongXa> dsPhuongXa = [];
      log("Getting data from API...");
      dsPhuongXa = await PhuongXa.doc(event.quanHuyen.id);
      log("Gotten all data from API...");
      emit(PhuongXaLoaded(dsPhuongXa, dsPhuongXa.map((e) => false).toList()));
    });
  }
}
