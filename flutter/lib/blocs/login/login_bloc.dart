import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/validators.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginLogoutRequested>(_onLogoutRequested);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    final isEmailValid = Validators.validateEmail(event.email) == null;
    emit(
      state.copyWith(
        email: event.email,
        isEmailValid: isEmailValid,
        errorMessage: null,
      ),
    );
  }

  void _onPasswordChanged(LoginPasswordChanged event, Emitter<LoginState> emit) {
    final isPasswordValid = Validators.validatePassword(event.password) == null;
    emit(
      state.copyWith(
        password: event.password,
        isPasswordValid: isPasswordValid,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(status: LoginStatus.loading));

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Simulate authentication logic
      // For demo purposes, accept any valid email/password combination
      // In a real app, this would make an API call to authenticate
      if (state.isEmailValid && state.isPasswordValid) {
        emit(state.copyWith(status: LoginStatus.success));
      } else {
        emit(
          state.copyWith(
            status: LoginStatus.failure,
            errorMessage: 'Invalid email or password. Please check your credentials.',
          ),
        );
      }
    } catch (error) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: 'Login failed: ${error.toString()}',
        ),
      );
    }
  }

  void _onLogoutRequested(LoginLogoutRequested event, Emitter<LoginState> emit) {
    emit(const LoginState());
  }
}
