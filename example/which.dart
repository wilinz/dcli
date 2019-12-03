#! /usr/bin/env dshell
/*
@pubspec.yaml
name: which.dart
dependencies:
  dshell: ^1.0.0
*/

import 'dart:io';
import 'package:dshell/dshell.dart';
import 'package:path/path.dart' as p;
import 'package:args/args.dart';

/// which appname
void main(List<String> args) {
  ArgParser parser = ArgParser();
  parser..addFlag('verbose', abbr: 'v', defaultsTo: false, negatable: false);

  ArgResults results = parser.parse(args);

  bool verbose = results['verbose'] as bool;

  if (results.rest.length != 1) {
    print(red("You must pass the name of the executable to search for."));
    print(green("Usage:"));
    print(green("   which ${parser.usage}<exe>"));
    exit(1);
  }

  String command = results.rest[0];
  String home = env("HOME");

  List<String> paths = env("PATH").split(":");

  for (String path in paths) {
    if (path.startsWith("~")) {
      path = path.replaceAll("~", home);
    }
    if (verbose) {
      print("Searching: ${p.canonicalize(path)}");
    }
    if (exists(p.join(path, command))) {
      print(red("Found at: ${p.canonicalize(p.join(path, command))}"));
    }
  }
}
