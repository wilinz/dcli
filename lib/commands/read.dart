import 'dart:convert';
import 'dart:io';

import 'package:dshell/util/dshell_exception.dart';
import 'package:dshell/util/for_each.dart';

import 'package:dshell/util/stack_trace_impl.dart';
import 'package:dshell/util/waitForEx.dart';

import 'command.dart';
import 'is.dart';
import 'settings.dart';
import '../util/log.dart';

/// Reads lines from the file at [path].
///
/// [delim] sets the line delimiter which defaults to newline
///
/// If the file does not exists then a ReadException is thrown.
///
ForEach read(String path, {String delim = "\n"}) =>
    Read().read(path, delim: delim);

/// Read lines from stdin
ForEach readStdin() => Read().readStdin();

class Read extends Command {
  ForEach read(String path, {String delim}) {
    File sourceFile = File(path);

    if (Settings().debug_on) {
      Log.d("read: ${absolute(path)}, delim: ${delim}");
    }

    if (!exists(path)) {
      throw ReadException("The file at ${absolute(path)} does not exists");
    }

    ForEach forEach = ForEach();

    waitForEx<void>(sourceFile
        .openRead()
        .transform(utf8.decoder)
        .transform(LineSplitter())
        .forEach((line) {
      forEach.addToStdout(line);
    }));

    forEach.close();

    return forEach;
  }

  ForEach readStdin() {
    if (Settings().debug_on) {
      Log.d("readStdin");
    }

    ForEach forEach = ForEach();
    String line;

    while ((line = stdin.readLineSync()) != null) {
      forEach.addToStdout(line);
    }

    forEach.close();

    return forEach;
  }
}

class ReadException extends CommandException {
  ReadException(String reason, [StackTraceImpl stacktrace])
      : super(reason, stacktrace);

  @override
  DShellException copyWith(StackTraceImpl stackTrace) {
    return ReadException(message, stackTrace);
  }
}
