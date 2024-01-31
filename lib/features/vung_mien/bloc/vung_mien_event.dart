part of 'vung_mien_bloc.dart';

abstract class VungMienEvent extends Equatable {
  const VungMienEvent();
}

class LoadDataEvent extends VungMienEvent {
  @override
  List<Object?> get props => [];
}

class StartInsertEvent extends VungMienEvent {
  @override
  List<Object?> get props => [];
}

class InsertEvent extends VungMienEvent {
  final VungMien vungMien;
  const InsertEvent(this.vungMien);
  @override
  List<Object?> get props => [vungMien];
}

class StartUpdateEvent extends VungMienEvent {
  final VungMien vungMien;
  const StartUpdateEvent(this.vungMien);
  @override
  List<Object?> get props => [vungMien];
}

class UpdateEnvent extends VungMienEvent {
  final VungMien vungMien;
  const UpdateEnvent(this.vungMien);
  @override
  List<Object?> get props => [vungMien];
}

class DeleteEvent extends VungMienEvent {
  final List<bool> dsChon;
  const DeleteEvent(this.dsChon);
  @override
  List<Object?> get props => [dsChon];
}

class StopEditEvent extends VungMienEvent {
  @override
  List<Object?> get props => [];
}
