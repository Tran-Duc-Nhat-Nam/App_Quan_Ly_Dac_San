part of 'phuong_xa_bloc.dart';

abstract class PhuongXaState extends Equatable {
  const PhuongXaState();
}

class PhuongXaInitial extends PhuongXaState {
  @override
  List<Object> get props => [];
}

class PhuongXaLoading extends PhuongXaState {
  @override
  List<Object> get props => [];
}

class PhuongXaLoaded extends PhuongXaState {
  final List<PhuongXa> dsPhuongXa;
  final List<bool> dsChon;
  final bool isInsert;
  final bool isUpdate;
  final String? errorMessage;
  const PhuongXaLoaded(
    this.dsPhuongXa,
    this.dsChon, {
    this.isInsert = false,
    this.isUpdate = false,
    this.errorMessage,
  });
  @override
  List<Object> get props =>
      [dsPhuongXa, dsChon, isInsert, isUpdate, dsPhuongXa];
}
