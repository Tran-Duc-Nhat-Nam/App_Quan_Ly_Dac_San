part of 'thong_ke_bloc.dart';

abstract class ThongKeState extends Equatable {
  const ThongKeState();
}

class ThongKeInitial extends ThongKeState {
  @override
  List<Object> get props => [];
}

class ThongKeLoaded extends ThongKeState {
  final List<DacSan> dsDacSan;
  final List<NoiBan> dsNoiBan;
  final List<NguoiDung> dsNguoiDung;
  final String? errorMessage;

  const ThongKeLoaded(
    this.dsDacSan,
    this.dsNoiBan,
    this.dsNguoiDung, {
    this.errorMessage,
  });

  @override
  List<Object> get props => [dsDacSan, dsNoiBan, dsNguoiDung];
}
