import 'dart:io';

void main() async {
  final projectDir = Directory.current;
  final outputFile = File('PROJECT_CONTEXT.md');
  final buffer = StringBuffer();

  buffer.writeln('# Project Context for AI Study');
  buffer.writeln('\n---\n');

  // 1. Cấu trúc thư mục lib/
  buffer.writeln('## Directory Structure (`lib/`)\n');
  buffer.writeln('```');
  final libDir = Directory('${projectDir.path}/lib');
  if (libDir.existsSync()) {
    buffer.writeln('lib/');
    _buildTree(libDir, buffer, '');
  }
  buffer.writeln('```\n');

  // 2. Nội dung file pubspec.yaml
  final pubspecFile = File('${projectDir.path}/pubspec.yaml');
  if (pubspecFile.existsSync()) {
    buffer.writeln('## `pubspec.yaml`');
    buffer.writeln('```yaml');
    buffer.writeln(pubspecFile.readAsStringSync().trim());
    buffer.writeln('```\n');
  }

  // 3. Nội dung tất cả các file .dart trong lib/
  buffer.writeln('## Source Code\n');
  if (libDir.existsSync()) {
    final files =
        libDir
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'))
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));

    for (final file in files) {
      final relativePath = file.path.replaceFirst(
        '${projectDir.path}${Platform.pathSeparator}',
        '',
      );

      buffer.writeln('### `$relativePath`');
      buffer.writeln('```dart');
      buffer.writeln(file.readAsStringSync().trim());
      buffer.writeln('```\n');
    }
  }

  await outputFile.writeAsString(buffer.toString());
  print('✅ Đã tạo thành công file: ${outputFile.path}');
}

void _buildTree(Directory dir, StringBuffer buffer, String indent) {
  final entities = dir.listSync()
    ..sort((a, b) {
      if (a is Directory && b is File) return -1;
      if (a is File && b is Directory) return 1;
      return a.path.compareTo(b.path);
    });

  for (var i = 0; i < entities.length; i++) {
    final entity = entities[i];
    final isLast = i == entities.length - 1;
    final name = entity.path.split(Platform.pathSeparator).last;
    final prefix = isLast ? '└── ' : '├── ';

    buffer.writeln('$indent$prefix$name');

    if (entity is Directory) {
      final childIndent = indent + (isLast ? '    ' : '│   ');
      _buildTree(entity, buffer, childIndent);
    }
  }
}
