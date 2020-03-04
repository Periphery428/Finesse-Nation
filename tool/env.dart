import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final config = {
    'FINESSE_API_TOKEN': Platform.environment['FINESSE_API_TOKEN']
  };

  final filename = 'lib/.env.dart';
  File(filename).writeAsString('final environment = ${json.encode(config)};');
  print('generated .env.dart');
}
