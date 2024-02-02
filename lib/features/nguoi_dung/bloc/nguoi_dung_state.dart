part of 'nguoi_dung_bloc.dart';

abstract class NguoiDungState extends Equatable {
  const NguoiDungState();
}

class NguoiDungInitial extends NguoiDungState {
  @override
  List<Object> get props => [];
}

class NguoiDungLoaded extends NguoiDungState {
  final List<NguoiDung> dsNguoiDung;
  final List<bool> dsChon;
  final bool isInsert;
  final bool isUpdate;
  final String? errorMessage;
  const NguoiDungLoaded(
    this.dsNguoiDung,
    this.dsChon, {
    this.isInsert = false,
    this.isUpdate = false,
    this.errorMessage,
  });
  @override
  List<Object> get props => [dsNguoiDung, dsChon, isInsert, isUpdate];
}
