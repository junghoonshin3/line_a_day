import 'package:fpdart/fpdart.dart';
import 'package:line_a_day/core/error/failures.dart';

abstract class UseCase<Type, Params> {
  /// UseCase 실행
  /// 성공: Right(결과)
  /// 실패: Left(Failure)
  Future<Either<Failure, Type>> call(Params params);
}

/// 파라미터가 없는 UseCase용
class NoParams {
  const NoParams();
}

/// Stream 기반 UseCase
abstract class StreamUseCase<Type, Params> {
  Stream<Type> call(Params params);
}

/// 동기 UseCase (즉시 실행)
abstract class SyncUseCase<Type, Params> {
  Type call(Params params);
}
