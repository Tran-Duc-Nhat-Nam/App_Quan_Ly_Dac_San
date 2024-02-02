part of 'phuong_xa_bloc.dart';

abstract class PhuongXaEvent extends Equatable {
  const PhuongXaEvent();
}

class LoadPhuongXaEvent extends PhuongXaEvent {
  final QuanHuyen quanHuyen;
  const LoadPhuongXaEvent(this.quanHuyen);
  @override
  List<Object?> get props => [quanHuyen];
}
