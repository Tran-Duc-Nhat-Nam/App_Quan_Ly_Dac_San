part of 'tinh_thanh_bloc.dart';

abstract class TinhThanhState extends Equatable {
  const TinhThanhState();
}

class TinhThanhInitial extends TinhThanhState {
  @override
  List<Object> get props => [];
}

class TinhThanhLoaded extends TinhThanhState {
  final List<TinhThanh> dsTinhThanh;
  final List<QuanHuyen> dsQuanHuyen;
  final List<PhuongXa> dsPhuongXa;
  final List<bool> dsChon;
  final bool isInsert;
  final bool isUpdate;
  final String? errorMessage;
  const TinhThanhLoaded(
    this.dsTinhThanh,
    this.dsChon, {
    this.isInsert = false,
    this.isUpdate = false,
    this.errorMessage,
    this.dsQuanHuyen = const [],
    this.dsPhuongXa = const [],
  });
  @override
  List<Object> get props =>
      [dsTinhThanh, dsChon, isInsert, isUpdate, dsQuanHuyen, dsPhuongXa];
}
