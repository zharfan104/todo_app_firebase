// ignore_for_file: avoid_as

import 'package:equatable/equatable.dart';

abstract class LoadDataState<T> extends Equatable {
  const LoadDataState();

  @override
  List<Object?> get props => [];
}

class InitialDataState<T> extends LoadDataState<T> {}

class LoadingDataState<T> extends LoadDataState<T> {}

class LoadedDataState<T> extends LoadDataState<T> {
  const LoadedDataState({required this.data});

  final T data;

  @override
  List<Object?> get props => [data];
}

class ErrorDataState<T> extends LoadDataState<T> {
  const ErrorDataState({
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

extension LoadDataStateExtension<T> on LoadDataState<T> {
  bool get isLoading => this is LoadingDataState<T>;
  bool get isError => this is ErrorDataState<T>;
  bool get isLoaded => this is LoadedDataState<T>;

  T? get getData =>
      (this is LoadedDataState<T>) ? (this as LoadedDataState<T>).data : null;

  String? get getErrorMessage => (this is ErrorDataState<T>)
      ? (this as ErrorDataState<T>).errorMessage
      : null;
}
