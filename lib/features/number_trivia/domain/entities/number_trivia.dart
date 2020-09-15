import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// NumberTrivia: Entity Class that handles types of data
/// we get from the API
/// Equatable helps to equate any objects for easy comparision
class NumberTrivia extends Equatable {
  final String text;
  final int number;

  NumberTrivia({
    @required this.text,
    @required this.number,
  });

  @override
  List<Object> get props => [text, number];
}
