#! /usr/bin/env dcli

import 'dart:io';

import 'package:dcli/dcli.dart';

///
/// Call this program using:
/// dcli find.dart -v --workingDirectory . ---recursive  *.*
///
/// to see the usage run:
///
/// bin/find.dart
///
/// Find all files that match the given pattern.
/// Starts from the current directory unless [--workingDirectory]
/// is provided.
void main(List<String> args) {
  final parser = ArgParser()
    ..addFlag('verbose', abbr: 'v')
    ..addFlag('recursive', abbr: 'r', defaultsTo: true)
    ..addOption(
      'workingDirectory',
      defaultsTo: '.',
      help: 'Specifies the directory to start searching from',
    );

  final ArgResults results;

  try {
    results = parser.parse(args);
  } on FormatException catch (e) {
    print('');
    printerr(red(e.message));
    showUsage(parser);
    exit(1);
  }

  final workingDirectory = results['workingDirectory'] as String;
  final verbose = results['verbose'] as bool;
  final recursive = results['recursive'] as bool;

  if (verbose) {
    print('Verbose is on, starting find');
  }

  if (results.rest.length != 1) {
    print('');
    printerr(red('${DartScript.self.basename} requires a single argument. '
        'Found: ${results.rest.join(',')}'));

    showUsage(parser);
    exit(1);
  }
  final pattern = results.rest[0];

  find(pattern, workingDirectory: workingDirectory, recursive: recursive)
      .forEach(print);

  if (verbose) {
    print('Verbose is on, completed find');
  }
}

void showUsage(ArgParser parser) {
  print('''

${green('Usage')}
${DartScript.self.basename} [options] <pattern> 
pattern - The glob search pattern to apply. e.g. *.txt. 
    On posix systems need to quote the pattern to stop bash expanding it into a file list.

${parser.usage}
''');
}
