#!/usr/local/bin/dart

import 'dart:io';
import 'dart:async';
import 'dart:json';
import 'dart:uri';
import 'dart:crypto';
import 'gabby.dart';

final ADMIN_STASH = '../data/admin.json';
final PASS_SALT = 'Hell is hopelessness.';

final notFoundMessage = '''
Page missing!
''';

var postInput;

final routeChart = {
  'dumpenv': displayEnvironment,
  'save': saveArticle,
  'signin': signin,
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

List fetchPassToken(String u, String p) {
  var af = new File(ADMIN_STASH);
  var pt = generateToken(u, p);
  var lot = [];
  adminStore = parse(af.readAsStringSync());
  for (var a in adminStore) {
    lot.add(a.passtoken);
  }
  if (lot.contains(pt)) {
    return [true, pt];
  } else {
    return [false, null];
  }
}

String generateToken(String username, String password) {
  var sha1 = new SHA1();
  sha1.add('${PASS_SALT} ${username} ${password}'.codeUnits);
  return CryptoUtils.bytesToHex(sha1.close());
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
  if (Platform.environment['REQUEST_METHOD'] == 'POST') {
    stdin.listen((e) {
      postInput = new String.fromCharCodes(e);
      var jo = parse(decodeUriComponent(postInput));
      var pn = jo['title'];
      try {
        var pf = new File('page/${pn}');
        pf.writeAsStringSync(jo['article']);
        print(stringify({'isOK': true}));
      } on FileIOException {
        jotdown('error writing page file: ${pn}');
        print(stringify({'isOK': false}));
      }
    });
  }
}

showTime() {
  var t = new DateTime.now();
  print(t);
}

signin() {
  if (Platform.environment['REQUEST_METHOD'] == 'POST') {
    stdin.listen((e) {
      postInput = new String.fromCharCodes(e);
      var jo = parse(decodeUriComponent(postInput));
      var tokinfo = fetchPassToken(jo['username'], jo['password']);
      if (tokinfo[0]) {
        print(stringify({'isOK': true, 'passtoken': tokinfo[1]}));
      } else {
        print(stringify({'isOK': false, 'passtoken': null}));
      }
    });
  }
}
