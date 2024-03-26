part of 'noi_ban_bloc.dart';

abstract class NoiBanState extends Equatable {
  const NoiBanState();
}

class NoiBanInitial extends NoiBanState {
  @override
  List<Object> get props => [];
}

class NoiBanLoaded extends NoiBanState {
  final List<bool> dsChonNoiBan;
  final NoiBan noiBanTam;
  final List<DacSan> dsDacSan;
  final List<bool> dsChonDacSan;
  final bool isInsert;
  final bool isUpdate;
  final String? errorMessage;
  const NoiBanLoaded(
    this.dsChonNoiBan,
    this.noiBanTam, {
    this.isInsert = false,
    this.isUpdate = false,
    this.errorMessage,
    this.dsDacSan = const [],
    this.dsChonDacSan = const [],
  });
  @override
  List<Object> get props => [
        dsChonNoiBan,
        noiBanTam.props,
        isInsert,
        isUpdate,
        dsDacSan,
        dsChonDacSan
      ];
}
