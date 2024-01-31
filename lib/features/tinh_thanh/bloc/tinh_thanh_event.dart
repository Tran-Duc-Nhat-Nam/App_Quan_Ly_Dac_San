part of 'tinh_thanh_bloc.dart';

abstract class TinhThanhEvent extends Equatable {
  const TinhThanhEvent();
}

class LoadDataEvent extends TinhThanhEvent {
  @override
  List<Object?> get props => [];
}

class StartInsertEvent extends TinhThanhEvent {
  @override
  List<Object?> get props => [];
}

class InsertEvent extends TinhThanhEvent {
  final TinhThanh tinhThanh;
  const InsertEvent(this.tinhThanh);
  @override
  List<Object?> get props => [tinhThanh];
}

class StartUpdateEvent extends TinhThanhEvent {
  final TinhThanh tinhThanh;
  const StartUpdateEvent(this.tinhThanh);
  @override
  List<Object?> get props => [tinhThanh];
}

class UpdateEnvent extends TinhThanhEvent {
  final TinhThanh tinhThanh;
  const UpdateEnvent(this.tinhThanh);
  @override
  List<Object?> get props => [tinhThanh];
}

class DeleteEvent extends TinhThanhEvent {
  final List<bool> dsChon;
  const DeleteEvent(this.dsChon);
  @override
  List<Object?> get props => [dsChon];
}

class StopEditEvent extends TinhThanhEvent {
  @override
  List<Object?> get props => [];
}
