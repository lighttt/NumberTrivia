import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repositories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

/// Since we have the contract/definition of the repository it is far
/// easier to do the testing with TDD approach for the use cases with need of implementation
/// Create the class for the Mock and implement the Repo
class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

/// Here we run all our tests
void main() {
  // Values needed : UseCase and MockClass
  GetRandomNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  /// This thing setups the necessary inits before the test
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  /// Starting for the test
  /// initial values for passing
  final tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  /// Test should return back values needed from the repo
  /// Here, it should return any Right value so that repo returns data
  test('should get trivia from repository', () async {
    // ARRANGE
    // make sure that the mock class function returns any data when
    // called that must of Right type i.e. No failure
    when(mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => Right(tNumberTrivia));

    // ACT
    // The "act" phase of the test. Call the not-yet-existent method.
    final result = await usecase(NoParams());

    // ASSERT
    // UseCase should simply return whatever was returned from the Repository
    expect(result, Right(tNumberTrivia));
    // Verify that the method has been called on the Repository
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    // Verify that the method has been called on the Repository
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
