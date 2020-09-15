import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repositories.dart';

/// GetConcreteNumberTrivia Class: It is an use case class that handles getting
/// data from the network or repository
class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  /// The return value may either be failure or value: as Either<L,R>
  /// The call methods helps to directly call a class function
  /// rather than pointing to specific part
  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams noParams) async {
    return await repository.getRandomNumberTrivia();
  }
}
