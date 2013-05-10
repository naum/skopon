#!/usr/bin/env dart

import 'package:unittest/unittest.dart';
import '../web/script/nawms.dart';

var sampleDocument = '''
Line 1.

==== a comment ====

Line 2.

Line 3.

    Line 3A.

Line 4.


====
    10 PRINT
    20 GOTO 10
====

http://google.com
http://dartlang.org

!My grocery list

* peanut butter
* jelly
* bread
** rye
** white
* juice
** apple
** orange

!!what i must do today

# wash
# rinse
# dry

==== boo freaking hoo ====

>lorem ipsum...
>>inside the onion…
>da doy
>can be a **bright** tomorrow for _The Communitarian_

Watch *My Fair Lady* you may.

``10 PRINT`` 
``20 GOTO 10``

====
ESCAPE FROM ALCATRAZ
====

And she said ~Please_come_to_Boston!

''';

main() {
  test('wikilink', () {
    var wl = '~Page_One';
    var wlh = wl.replaceAllMapped(new RegExp(r'~(\w+)'), wikilink);
    expect(wlh, equals('<a href="/page/Page_One">Page One</a>'));
  });
  test('wikiToHtml', () {
    var outhtml = wikiToHtml(sampleDocument);
    print('outhtml:\n$outhtml');
  });
}
