part of 'vung_mien_bloc.dart';

abstract class VungMienState extends Equatable {
  const VungMienState();
}

class VungMienInitial extends VungMienState {
  @override
  List<Object> get props => [];
}

class VungMienLoaded extends VungMienState {
  final List<VungMien> dsVungMien;
  final List<bool> dsChon;
  final bool isInsert;
  final bool isUpdate;
  final String? errorMessage;
  const VungMienLoaded(
    this.dsVungMien,
    this.dsChon, {
    this.isInsert = false,
    this.isUpdate = false,
    this.errorMessage,
  });
  @override
  List<Object> get props => [dsVungMien, dsChon, isInsert, isUpdate];
}
