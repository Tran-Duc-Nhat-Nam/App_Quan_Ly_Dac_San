part of 'mua_dac_san_bloc.dart';

abstract class MuaDacSanEvent extends Equatable {
  const MuaDacSanEvent();
}

class LoadDataEvent extends MuaDacSanEvent {
  @override
  List<Object?> get props => [];
}

class StartInsertEvent extends MuaDacSanEvent {
  @override
  List<Object?> get props => [];
}

class InsertEvent extends MuaDacSanEvent {
  final MuaDacSan muaDacSan;
  const InsertEvent(this.muaDacSan);
  @override
  List<Object?> get props => [muaDacSan];
}

class StartUpdateEvent extends MuaDacSanEvent {
  final MuaDacSan muaDacSan;
  const StartUpdateEvent(this.muaDacSan);
  @override
  List<Object?> get props => [muaDacSan];
}

class UpdateEnvent extends MuaDacSanEvent {
  final MuaDacSan muaDacSan;
  const UpdateEnvent(this.muaDacSan);
  @override
  List<Object?> get props => [muaDacSan];
}

class DeleteEvent extends MuaDacSanEvent {
  final List<bool> dsChon;
  const DeleteEvent(this.dsChon);
  @override
  List<Object?> get props => [dsChon];
}

class StopEditEvent extends MuaDacSanEvent {
  @override
  List<Object?> get props => [];
}
