part of 'noi_ban_bloc.dart';

abstract class NoiBanEvent extends Equatable {
  const NoiBanEvent();
}

class LoadNoiBanEvent extends NoiBanEvent {
  @override
  List<Object?> get props => [];
}

class LoadDacSanEvent extends NoiBanEvent {
  final int index;
  const LoadDacSanEvent(this.index);
  @override
  List<Object?> get props => [index];
}

class AddDacSanEvent extends NoiBanEvent {
  final DacSan thanhPhan;
  const AddDacSanEvent(this.thanhPhan);
  @override
  List<Object?> get props => [thanhPhan];
}

class RemoveDacSanEvent extends NoiBanEvent {
  final DacSan dacSan;
  const RemoveDacSanEvent(this.dacSan);
  @override
  List<Object?> get props => [dacSan];
}

class StartInsertEvent extends NoiBanEvent {
  @override
  List<Object?> get props => [];
}

class InsertEvent extends NoiBanEvent {
  final String ten;
  final String? moTa;
  final String? cachCheBien;
  final DiaChi diaChi;

  const InsertEvent(this.ten, this.diaChi, {this.moTa, this.cachCheBien});
  @override
  List<Object?> get props => [ten, diaChi];
}

class StartUpdateEvent extends NoiBanEvent {
  final NoiBan noiBan;
  const StartUpdateEvent(this.noiBan);
  @override
  List<Object?> get props => [noiBan];
}

class UpdateEnvent extends NoiBanEvent {
  final NoiBan noiBan;
  const UpdateEnvent(this.noiBan);
  @override
  List<Object?> get props => [noiBan];
}

class DeleteEvent extends NoiBanEvent {
  final List<bool> dsChon;
  const DeleteEvent(this.dsChon);
  @override
  List<Object?> get props => [dsChon];
}

class StopEditEvent extends NoiBanEvent {
  @override
  List<Object?> get props => [];
}
