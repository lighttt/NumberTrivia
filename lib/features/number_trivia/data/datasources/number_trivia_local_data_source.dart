import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

/// This class is used to cache our local data source when we do not
/// have connectivity
abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTrivialModel] which was gotten the last time
  /// the user had connection
  ///
  /// Throws [NoLocalDataException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}
