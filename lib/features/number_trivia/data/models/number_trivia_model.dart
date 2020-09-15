import 'package:meta/meta.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

/// NumberTriviaModel is the actual converted Json data got from calling repository
/// Which will extend our base entity and match the data got
/// this helps in making sure if our API format change the main entities are not affected
class NumberTriviaModel extends NumberTrivia {
  //constructor with super
  NumberTriviaModel({@required String text, @required int number})
      : super(text: text, number: number);

  ///factory constructor for converting json data to required model
  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      text: json['text'],
      number: (json['number'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number,
    };
  }
}
