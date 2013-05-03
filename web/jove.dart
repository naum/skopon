#!/Users/george/dart2/dart-sdk/bin/dart

import 'dart:io';

var template = '''
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>skopon</title>
<link rel="stylesheet" href="/style/main.css">
</head>
<body>
<h1>{{PAGEHEADER}}</h1>
{{PAGEBODY}}
<footer>
{{PAGEFOOTER}}
</footer>
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
  print('Content-type: text/html\n\n');
}
