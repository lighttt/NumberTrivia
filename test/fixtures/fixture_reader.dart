import 'dart:io';

// convert the fixture file or json file to the string value so that it can be decoded
String fixture(String name) => File('test/fixtures/$name').readAsStringSync();
