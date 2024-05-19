import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

class Logger {
  final String _prefix;

  const Logger(this._prefix);

  void log(String content) {
    if (kReleaseMode) {
      return;
    }
    developer.log('$_prefix $content');
  }
}

/// This only show logs in debug / profile mode
void debugLog(String content) {
  if (kReleaseMode) {
    return;
  }
  developer.log(content);
}

mixin LoggerMixin {
  Logger get _logger => Logger('[${runtimeType.toString()}]');

  void log(String content) {
    _logger.log(content);
  }
}
