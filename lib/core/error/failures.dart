import 'package:equatable/equatable.dart';

/// Failure Class: It is an abstract class that handles failures or
/// exceptions which can be of any dynamic types
/// Equatable helps to equate any objects for easy comparision
abstract class Failure extends Equatable {
  Failure([List properties = const <dynamic>[]]);
}
