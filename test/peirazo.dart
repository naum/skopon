#!/usr/bin/env dart

import 'package:unittest/unittest.dart';
import '../web/script/nawms.dart';

main() {
  test('wikilink', () {
    var wl = '~Page_One';
    var wlh = wl.replaceAllMapped(new RegExp(r'~(\w+)'), wikilink);
    expect(wlh, equals('<a href="/page/Page_One">Page One</a>'));
  });
}
