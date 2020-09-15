import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/number_trivia.dart';

/// NumberTriviaRepository Class: It is an abstract class that
/// contains various functions that are used to get data from the network or database
/// Since this is on the domain side we only do the definition
abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
