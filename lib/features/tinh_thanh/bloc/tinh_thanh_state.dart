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
  });
  @override
  List<Object> get props => [dsTinhThanh, dsChon, isInsert, isUpdate];
}
