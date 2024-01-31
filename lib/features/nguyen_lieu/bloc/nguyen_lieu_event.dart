part of 'nguyen_lieu_bloc.dart';

abstract class NguyenLieuEvent extends Equatable {
  const NguyenLieuEvent();
}

class LoadDataEvent extends NguyenLieuEvent {
  @override
  List<Object?> get props => [];
}

class StartInsertEvent extends NguyenLieuEvent {
  @override
  List<Object?> get props => [];
}

class InsertEvent extends NguyenLieuEvent {
  final NguyenLieu nguyenLieu;
  const InsertEvent(this.nguyenLieu);
  @override
  List<Object?> get props => [nguyenLieu];
}

class StartUpdateEvent extends NguyenLieuEvent {
  final NguyenLieu nguyenLieu;
  const StartUpdateEvent(this.nguyenLieu);
  @override
  List<Object?> get props => [nguyenLieu];
}

class UpdateEnvent extends NguyenLieuEvent {
  final NguyenLieu nguyenLieu;
  const UpdateEnvent(this.nguyenLieu);
  @override
  List<Object?> get props => [nguyenLieu];
}

class DeleteEvent extends NguyenLieuEvent {
  final List<bool> dsChon;
  const DeleteEvent(this.dsChon);
  @override
  List<Object?> get props => [dsChon];
}

class StopEditEvent extends NguyenLieuEvent {
  @override
  List<Object?> get props => [];
}
