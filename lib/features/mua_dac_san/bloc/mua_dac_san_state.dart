part of 'mua_dac_san_bloc.dart';

abstract class MuaDacSanState extends Equatable {
  const MuaDacSanState();
}

class MuaDacSanInitial extends MuaDacSanState {
  @override
  List<Object> get props => [];
}

class MuaDacSanLoaded extends MuaDacSanState {
  final List<MuaDacSan> dsMuaDacSan;
  final List<bool> dsChon;
  final bool isInsert;
  final bool isUpdate;
  final String? errorMessage;
  const MuaDacSanLoaded(
    this.dsMuaDacSan,
    this.dsChon, {
    this.isInsert = false,
    this.isUpdate = false,
    this.errorMessage,
  });
  @override
  List<Object> get props => [dsMuaDacSan, dsChon, isInsert, isUpdate];
}
