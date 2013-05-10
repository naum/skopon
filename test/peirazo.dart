#!/usr/bin/env dart

import 'package:unittest/unittest.dart';
import '../web/script/nawms.dart';

var sampleDocument = '''
Line 1.

Line 2.

Line 3.

    Line 3A.

Line 4.

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

>lorem ipsum...
>>inside the onion…
>da doy
>can be a **bright** tomorrow for __The Communitarian__

``10 PRINT`` 
``20 GOTO 10``

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
