#!/usr/local/bin/dart

import 'dart:io';

var template = '''
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<link href="http://fonts.googleapis.com/css?family=Questrial" rel="stylesheet" type="text/css">
<title>skopon</title>
<link rel="stylesheet" href="/style/main.css">
</head>
<body>
<h1>{{PAGEHEADER}}</h1>
{{PAGEBODY}}
<footer>
{{PAGEFOOTER}}
</footer>
<script src="/script/jove.js"></script>
</body>
</html>
''';

main() {
  outputHeaders();
  displayEnvironment();
}

displayEnvironment() {
  var sb = new StringBuffer();
  var sk = Platform.environment.keys.toList();
  sk.sort();
  for (var k in sk) {
      sb.write('$k: ${Platform.environment[k]}<br>\n');
  };
  var pagebind = {
    'PAGEHEADER': 'Platform.environment',
    'PAGEBODY': sb.toString()
  };
  var reTS = new RegExp(r'\{\{(\w+)\}\}');
  var pbody = template.replaceAllMapped(reTS, (m) {
    var tv = m.group(1);
    return (pagebind.containsKey(tv)) ? pagebind[tv] : '';
  }); 
  print(pbody);
}

outputHeaders() {
  print('Content-type: text/html\n');
}
