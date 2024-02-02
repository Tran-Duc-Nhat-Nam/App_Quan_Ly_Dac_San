part of 'dac_san_bloc.dart';

abstract class DacSanEvent extends Equatable {
  const DacSanEvent();
}

class LoadDacSanEvent extends DacSanEvent {
  @override
  List<Object?> get props => [];
}

class LoadThanhPhanEvent extends DacSanEvent {
  final int index;
  const LoadThanhPhanEvent(this.index);
  @override
  List<Object?> get props => [index];
}

class AddVungMienEvent extends DacSanEvent {
  final VungMien vungMien;
  const AddVungMienEvent(this.vungMien);
  @override
  List<Object?> get props => [vungMien];
}

class AddMuaDacSanEvent extends DacSanEvent {
  final MuaDacSan muaDacSan;
  const AddMuaDacSanEvent(this.muaDacSan);
  @override
  List<Object?> get props => [muaDacSan];
}

class AddThanhPhanEvent extends DacSanEvent {
  final ThanhPhan thanhPhan;
  const AddThanhPhanEvent(this.thanhPhan);
  @override
  List<Object?> get props => [thanhPhan];
}

class AddHinhAnhEvent extends DacSanEvent {
  final HinhAnh hinhAnh;
  const AddHinhAnhEvent(this.hinhAnh);
  @override
  List<Object?> get props => [hinhAnh];
}

class AddHinhDaiDienEvent extends DacSanEvent {
  final HinhAnh hinhAnh;
  const AddHinhDaiDienEvent(this.hinhAnh);
  @override
  List<Object?> get props => [hinhAnh];
}

class RemoveVungMienEvent extends DacSanEvent {
  final VungMien vungMien;
  const RemoveVungMienEvent(this.vungMien);
  @override
  List<Object?> get props => [vungMien];
}

class RemoveMuaDacSanEvent extends DacSanEvent {
  final MuaDacSan muaDacSan;
  const RemoveMuaDacSanEvent(this.muaDacSan);
  @override
  List<Object?> get props => [muaDacSan];
}

class RemoveThanhPhanEvent extends DacSanEvent {
  final ThanhPhan thanhPhan;
  const RemoveThanhPhanEvent(this.thanhPhan);
  @override
  List<Object?> get props => [thanhPhan];
}

class RemoveHinhAnhEvent extends DacSanEvent {
  final HinhAnh hinhAnh;
  const RemoveHinhAnhEvent(this.hinhAnh);
  @override
  List<Object?> get props => [hinhAnh];
}

class StartInsertEvent extends DacSanEvent {
  @override
  List<Object?> get props => [];
}

class InsertEvent extends DacSanEvent {
  final String ten;
  final String? moTa;
  final String? cachCheBien;

  const InsertEvent(this.ten, {this.moTa, this.cachCheBien});
  @override
  List<Object?> get props => [ten];
}

class StartUpdateEvent extends DacSanEvent {
  final DacSan dacSan;
  const StartUpdateEvent(this.dacSan);
  @override
  List<Object?> get props => [dacSan];
}

class UpdateEnvent extends DacSanEvent {
  final DacSan dacSan;
  const UpdateEnvent(this.dacSan);
  @override
  List<Object?> get props => [dacSan];
}

class DeleteEvent extends DacSanEvent {
  final List<bool> dsChon;
  const DeleteEvent(this.dsChon);
  @override
  List<Object?> get props => [dsChon];
}

class StopEditEvent extends DacSanEvent {
  @override
  List<Object?> get props => [];
}
