import 'dart:io';

import '../settings.dart';
import 'ask.dart' as a;
import 'dshell_function.dart';
import 'is.dart';

///
/// Deletes the file at [path].
///
/// If the file does not exists a DeleteException is thrown.
///
/// ```dart
/// delete("/tmp/test.fred", ask = true);
/// ```
///
/// If [ask] is true then the user is prompted to confirm the file deletion.
/// The default value for [ask] is false.
///
/// If the [path] is a directory a DeleteException is thrown.
void delete(String path, {bool ask = false}) =>
    _Delete().delete(path, ask: ask);

class _Delete extends DShellFunction {
  void delete(String path, {bool ask}) {
    Settings().verbose('delete:  ${absolute(path)} ask: $ask');

    if (!exists(path)) {
      throw DeleteException('The path ${absolute(path)} does not exists.');
    }

    if (isDirectory(path)) {
      throw DeleteException('The path ${absolute(path)} is a directory.');
    }

    var remove = true;
    if (ask) {
      remove = false;
      var response =
          a.ask("delete: Delete the regular file '${absolute(path)}'? y/N");
      var yes = response;
      if (yes == 'y') {
        remove = true;
      }
    }

    if (remove == true) {
      try {
        File(path).deleteSync();
      }
      // ignore: avoid_catches_without_on_clauses
      catch (e) {
        throw DeleteException(
            'An error occured deleting ${absolute(path)}. Error: $e');
      }
    }
  }
}

/// Thrown when the [delete] function encounters an error
class DeleteException extends DShellFunctionException {
  /// Thrown when the [delete] function encounters an error
  DeleteException(String reason) : super(reason);
}
