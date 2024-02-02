part of 'dac_san_bloc.dart';

abstract class DacSanState extends Equatable {
  const DacSanState();
}

class DacSanInitial extends DacSanState {
  @override
  List<Object> get props => [];
}

class DacSanLoaded extends DacSanState {
  final List<bool> dsChonDacSan;
  final DacSan dacSanTam;
  final List<ThanhPhan> dsThanhPhan;
  final List<bool> dsChonThanhPhan;
  final List<HinhAnh> dsHinhAnh;
  final bool isInsert;
  final bool isUpdate;
  final String? errorMessage;
  const DacSanLoaded(
    this.dsChonDacSan,
    this.dacSanTam, {
    this.isInsert = false,
    this.isUpdate = false,
    this.errorMessage,
    this.dsThanhPhan = const [],
    this.dsChonThanhPhan = const [],
    this.dsHinhAnh = const [],
  });
  @override
  List<Object> get props => [
        dsChonDacSan,
        dacSanTam.props,
        isInsert,
        isUpdate,
        dsHinhAnh,
        dsThanhPhan,
        dsChonThanhPhan
      ];
}
