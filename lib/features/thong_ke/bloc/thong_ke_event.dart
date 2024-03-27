part of 'thong_ke_bloc.dart';

abstract class ThongKeEvent extends Equatable {
  const ThongKeEvent();
}

class LoadDataEvent extends ThongKeEvent {
  @override
  List<Object?> get props => [];
}
