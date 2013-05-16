library gabby;

import 'dart:io';
import 'dart:async';

jotdown(String m, [String logFile='../log/activity.log']) {
  var lf = new File(logFile);
  var p = generateMessagePrefix();
  lf.writeAsStringSync('${p} ${m}\n', mode: FileMode.APPEND);
}

String generateMessagePrefix() {
  var dt = new DateTime.now();
  var ra = Platform.environment['REMOTE_ADDR'];
  return '[${dt}] [${ra}]';
}
