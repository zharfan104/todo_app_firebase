import 'package:bloc/bloc.dart';
import 'package:todo_app_firebase/features/logout/repository/logout_repository.dart';
import 'package:todo_app_firebase/utils/load_data_state.dart';

class LogoutCubit extends Cubit<LoadDataState<void>> {
  LogoutCubit({
    required this.logoutRepository,
  }) : super(InitialDataState());

  final LogoutRepository logoutRepository;

  Future<void> logout() async {
    try {
      emit(LoadingDataState());
      await logoutRepository.logOut();
      emit(const LoadedDataState(data: null));
    } catch (e) {
      emit(ErrorDataState(errorMessage: e.toString()));
    }
  }
}
