#!/Users/george/dart2/dart-sdk/bin/dart

import 'dart:io';

main() {
  outputHeaders();
  displayEnvironment();
}

displayEnvironment() {
  var sk = Platform.environment.keys.toList();
  sk.sort();
  for (var k in sk) {
      print('$k: ${Platform.environment[k]}<br>\n');
  };
}

outputHeaders() {
  print('Content-type: text/html\n\n');
}
