import 'package:app_dac_san/features/dac_san/data/dac_san.dart';
import 'package:app_dac_san/features/nguoi_dung/data/nguoi_dung.dart';
import 'package:app_dac_san/features/noi_ban/data/noi_ban.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'thong_ke_event.dart';
part 'thong_ke_state.dart';

class ThongKeBloc extends Bloc<ThongKeEvent, ThongKeState> {
  ThongKeBloc() : super(ThongKeInitial()) {
    on<LoadDataEvent>((event, emit) async {
      List<DacSan> dsDacSan = await DacSan.doc();
      List<NoiBan> dsNoiBan = await NoiBan.doc();
      List<NguoiDung> dsNguoiDung = await NguoiDung.doc();
      emit(ThongKeLoaded(dsDacSan, dsNoiBan, dsNguoiDung));
    });
  }
}
