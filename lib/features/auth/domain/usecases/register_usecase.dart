import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class RegisterUseCase extends UseCase<AuthUser, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, AuthUser>> call(RegisterParams params) async {
    return await repository.register(
      email: params.email,
      password: params.password,
      name: params.name,
      phoneNumber: params.phoneNumber,
    );
  }
}

class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String name;
  final String phoneNumber;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.name,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [email, password, name, phoneNumber];
}

