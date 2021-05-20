@Timeout(Duration(minutes: 10))
import 'package:dcli/dcli.dart' hide equals;
import 'package:test/test.dart';

import '../util/test_file_system.dart';

void main() {
  test('backup/restore good path', () async {
    final root = createTempDir();
    const filename = 'test.txt';
    final file = join(root, filename);
    final backupDir = join(root, '.bak');

    const content = 'Hellow World';
    file.write(content);

    backupFile(file);

    final backupFilename = '${join(backupDir, filename)}.bak';

    expect(exists(backupFilename), isTrue);
    expect(exists(file), isTrue);

    const secondline = 'Foo was here';

    file.append(secondline);

    expect(read(file).toList().join('\n').contains(secondline), isTrue);

    restoreFile(file);

    expect(read(file).toList().join('\n').contains(secondline), isFalse);

    expect(exists(backupFilename), isFalse);

    /// check .bak directory removed
    expect(exists(backupDir), isFalse);
  });

  test('restore missing backup', () async {
    final root = createTempDir();
    const filename = 'test.txt';
    final file = join(root, filename);

    const content = 'Hellow World';
    file.write(content);

    backupFile(file);

    final backupFilename = '${join(root, '.bak', filename)}.bak';

    // do a bad thing, delete the backup.
    delete(backupFilename);

    expect(() => restoreFile(file), throwsA(isA<RestoreFileException>()));
  });

  test('backup missing file', () async {
    final root = createTempDir();
    const filename = 'test.txt';
    final file = join(root, filename);

    const content = 'Hellow World';
    file.write(content);

    delete(file);

    expect(() => backupFile(file), throwsA(isA<BackupFileException>()));
  });

  test('Existing .bak directory', () async {
    final root = createTempDir();
    const filename = 'test.txt';
    final file = join(root, filename);

    const content = 'Hellow World';
    file.write(content);

    final backupPath = join(root, '.bak');
    createDir(backupPath);

    backupFile(file);

    final backupFilename = '${join(backupPath, filename)}.bak';

    expect(exists(backupFilename), isTrue);
    expect(exists(file), isTrue);

    const secondline = 'Foo was here';

    file.append(secondline);

    expect(read(file).toList().join('\n').contains(secondline), isTrue);

    restoreFile(file);

    expect(read(file).toList().join('\n').contains(secondline), isFalse);

    expect(exists(backupFilename), isFalse);
  });

  group('withFileProtection', () {
    test('single file absolute path that we delete', () {
      withTempDir((tempDir) {
        final tree = TestDirectoryTree(tempDir);

        withFileProtection([tree.bottomFiveTxt], () {
          delete(tree.bottomFiveTxt);
        });
        expect(exists(tree.bottomFiveTxt), isTrue);
      });
    });

    test('single file absolute path that we modify', () {
      withTempDir((tempDir) {
        final tree = TestDirectoryTree(tempDir);

        final pre = calculateHash(tree.bottomFiveTxt);

        withFileProtection([tree.bottomFiveTxt], () {
          final pre = calculateHash(tree.bottomFiveTxt);
          tree.bottomFiveTxt.append('some dummy data');
          final post = calculateHash(tree.bottomFiveTxt);
          expect(pre, isNot(equals(post)));
        });
        expect(exists(tree.bottomFiveTxt), isTrue);
        final post = calculateHash(tree.bottomFiveTxt);
        expect(pre, equals(post));
      });
    });

     test('single file relative path that we delete', () {
       final localDir = join(pwd, '.testing');
        final tree = TestDirectoryTree(localDir);

        withFileProtection([tree.bottomFiveTxt], () {
          delete(tree.bottomFiveTxt);
        });
        expect(exists(tree.bottomFiveTxt), isTrue);

        deleteDir(localDir);
      });
    });

  });
}
