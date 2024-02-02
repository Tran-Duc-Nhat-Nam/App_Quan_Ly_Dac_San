part of 'quan_huyen_bloc.dart';

abstract class QuanHuyenState extends Equatable {
  const QuanHuyenState();
}

class QuanHuyenInitial extends QuanHuyenState {
  @override
  List<Object> get props => [];
}

class QuanHuyenLoading extends QuanHuyenState {
  @override
  List<Object> get props => [];
}

class QuanHuyenLoaded extends QuanHuyenState {
  final List<QuanHuyen> dsQuanHuyen;
  final List<bool> dsChon;
  final bool isInsert;
  final bool isUpdate;
  final String? errorMessage;
  const QuanHuyenLoaded(
    this.dsQuanHuyen,
    this.dsChon, {
    this.isInsert = false,
    this.isUpdate = false,
    this.errorMessage,
  });
  @override
  List<Object> get props =>
      [dsQuanHuyen, dsChon, isInsert, isUpdate, dsQuanHuyen];
}
