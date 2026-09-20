import 'dart:io';

void main() {
  final assetsDir = Directory('assets');
  if (!assetsDir.existsSync()) {
    print('❌ Không tìm thấy thư mục assets/');
    return;
  }

  final files =
      assetsDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => !_shouldIgnore(file.path))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  final sb = StringBuffer();
  sb.writeln('# Project Assets Structure\n');
  sb.writeln(
    'File này tự động sinh ra để phục vụ AI context / documentation.\n',
  );
  sb.writeln('## Thư mục & File (`assets/`)\n');
  sb.writeln('```text');

  for (final file in files) {
    final relativePath = file.path.replaceAll('\\', '/');
    sb.writeln(relativePath);
  }
  sb.writeln('```\n');

  sb.writeln('## Danh sách hằng số & Đường dẫn\n');
  sb.writeln('| File Name | Path | Extension |');
  sb.writeln('| --- | --- | --- |');

  for (final file in files) {
    final path = file.path.replaceAll('\\', '/');
    final fileName = path.split('/').last;
    final ext = fileName.contains('.') ? fileName.split('.').last : '';
    sb.writeln('| `$fileName` | `$path` | `$ext` |');
  }

  final outputFile = File('ASSETS_STRUCTURE.md');
  outputFile.writeAsStringSync(sb.toString());

  print('✅ Đã tạo thành công file Markdown tại: ${outputFile.path}');
}

bool _shouldIgnore(String path) {
  final normalized = path.replaceAll('\\', '/');
  return normalized.contains('__MACOSX') ||
      normalized.split('/').any((part) => part.startsWith('.'));
}
