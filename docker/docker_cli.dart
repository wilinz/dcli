#! /usr/bin/env dshell
import 'package:dshell/dshell.dart';

/// dshell script generated by:
/// dshell create docker_cli.dart
///
/// See
/// https://pub.dev/packages/dshell#-installing-tab-
///
/// For details on installing dshell.
///

void main(List<String> args) {
  var parser = ArgParser();
  parser.addFlag('runOnly', abbr: 'r', defaultsTo: false);

  var results = parser.parse(args);
  var runOnly = results['runOnly'] as bool;

  if (!runOnly) {
    // mount the local dshell files from ..
    'sudo docker build -f ./docker_cli.df -t dshell:docker_cli ..'.run;
  }

  'sudo docker run -it dshell:docker_cli /bin/bash'.run;
}
