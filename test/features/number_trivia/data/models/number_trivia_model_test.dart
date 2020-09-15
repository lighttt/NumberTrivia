import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

// This test assures that the model is an subclass of the entity
void main() {
  //create model class
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test Text");

  // individual test to check class
  test(
    'should be a subclass of NumberTrivia entity',
    () async {
      // assert
      // check if its the type of entity class : NumberTrivia
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  //group test to check fixtures or fake json data
  group('fromJson', () {
    //first check if the return value is int or not
    test(
      'should return a valid model when the JSON number is an integer',
      () async {
        // arrange
        // convert the fixture file to the Map using json decode
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia.json'));
        // act
        // now check the conversion from the json model
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        // check if the got result is same to the model
        expect(result, tNumberTriviaModel);
      },
    );

    //second check if the return value is a double
    test(
      'should return a valid model when the JSON number is regarded as a double',
      () async {
        // arrange
        // convert the fixture file to the Map using json decode
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia_double.json'));
        // act
        // now check the conversion from the json model
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        // check if the got result is same to the model
        expect(result, tNumberTriviaModel);
      },
    );
  });

  //group test to check data we get is Json map
  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        // convert the model to a json
        final result = tNumberTriviaModel.toJson();
        // assert
        // check if the got result is same to the json file
        final expectedMap = {
          "text": "Test Text",
          "number": 1,
        };
        expect(result, expectedMap);
      },
    );
  });
}
