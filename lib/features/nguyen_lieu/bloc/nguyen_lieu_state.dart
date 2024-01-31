part of 'nguyen_lieu_bloc.dart';

abstract class NguyenLieuState extends Equatable {
  const NguyenLieuState();
}

class NguyenLieuInitial extends NguyenLieuState {
  @override
  List<Object> get props => [];
}

class NguyenLieuLoaded extends NguyenLieuState {
  final List<NguyenLieu> dsNguyenLieu;
  final List<bool> dsChon;
  final bool isInsert;
  final bool isUpdate;
  final String? errorMessage;
  const NguyenLieuLoaded(
    this.dsNguyenLieu,
    this.dsChon, {
    this.isInsert = false,
    this.isUpdate = false,
    this.errorMessage,
  });
  @override
  List<Object> get props => [dsNguyenLieu, dsChon, isInsert, isUpdate];
}
