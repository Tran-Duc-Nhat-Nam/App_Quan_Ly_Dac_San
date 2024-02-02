part of 'nguoi_dung_bloc.dart';

abstract class NguoiDungEvent extends Equatable {
  const NguoiDungEvent();
}

class LoadDataEvent extends NguoiDungEvent {
  @override
  List<Object?> get props => [];
}

class StartInsertEvent extends NguoiDungEvent {
  @override
  List<Object?> get props => [];
}

class InsertEvent extends NguoiDungEvent {
  final NguoiDung nguoiDung;
  const InsertEvent(this.nguoiDung);
  @override
  List<Object?> get props => [nguoiDung];
}

class StartUpdateEvent extends NguoiDungEvent {
  final NguoiDung nguoiDung;
  const StartUpdateEvent(this.nguoiDung);
  @override
  List<Object?> get props => [nguoiDung];
}

class UpdateEnvent extends NguoiDungEvent {
  final NguoiDung nguoiDung;
  const UpdateEnvent(this.nguoiDung);
  @override
  List<Object?> get props => [nguoiDung];
}

class DeleteEvent extends NguoiDungEvent {
  final List<bool> dsChon;
  const DeleteEvent(this.dsChon);
  @override
  List<Object?> get props => [dsChon];
}

class StopEditEvent extends NguoiDungEvent {
  @override
  List<Object?> get props => [];
}
