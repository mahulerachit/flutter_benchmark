enum BenchmarkReportFormat {
  jsonFile,
  plainString,
  html,
}

extension BenchmarkReportFormatExtension on BenchmarkReportFormat {
  String get getValue {
    switch (this) {
      case BenchmarkReportFormat.jsonFile:
        return 'json';

      case BenchmarkReportFormat.plainString:
        return 'txt';

      case BenchmarkReportFormat.html:
        return 'html';
    }
  }
}
