#!/usr/local/bin/dart

import 'dart:io';
import 'dart:json';
import 'gabby.dart';

final notFoundMessage = '''
Page missing!
''';

final routeChart = {
  'dumpenv': displayEnvironment,
  'save': saveArticle,
  'time': showTime,
};

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
  List parg = parsePathArg();
  outputHeaders();
  jotdown('hola!');
  if (routeChart.containsKey(parg[0])) {
    routeChart[parg[0]]();
  } else {
    displayMissingPageMessage();
  }
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
  render(template, pagebind);
}

displayMissingPageMessage() {
  var pb = { 'PAGEHEADER': '404', 'PAGEBODY': notFoundMessage };
  render(template, pb);
}

outputHeaders() {
  print('Content-type: text/html\n');
}

List parsePathArg() {
  var ruri = Platform.environment['REQUEST_URI'].substring(1);
  return ruri.split('/');
}

String render(String t, Map pb) {
  var reTS = new RegExp(r'\{\{(\w+)\}\}');
  var pout = template.replaceAllMapped(reTS, (m) {
    var tv = m.group(1);
    return (pb.containsKey(tv)) ? pb[tv] : '';
  }); 
  print(pout);
}

saveArticle() {
}

showTime() {
  var t = new DateTime.now();
  print(t);
}
