part of 'quan_huyen_bloc.dart';

abstract class QuanHuyenEvent extends Equatable {
  const QuanHuyenEvent();
}

class LoadQuanHuyenEvent extends QuanHuyenEvent {
  final TinhThanh tinhThanh;
  const LoadQuanHuyenEvent(this.tinhThanh);
  @override
  List<Object?> get props => [tinhThanh];
}
