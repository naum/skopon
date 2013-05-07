import 'dart:html';
import 'dart:async';

var pageboard = query('#pageboard');

main() {
  var pagename = determineDesiredPage();
  if (! pagename.isEmpty) {
    displayPage(pagename);
  } else {
    pageboard.innerHtml = '<p>MIA</p>';
  }
}

String determineDesiredPage() {
  var pagepath = window.location.pathname;
  if (pagepath == '/') {
    return 'Page_One';
  } else {
    print('pagepath: $pagepath');
    var reWikiPath = new RegExp(r'\/wiki\/(.*)');
    var m = reWikiPath.firstMatch(pagepath);
    if (m is Match && m.groupCount > 0) {
      return m.group(1);
    } else {
      return '';
    }
  }
}

displayPage(pn) {
  var u = '/page/${pn}';
  var req = HttpRequest.getString(u).then((resptext) {
    pageboard.innerHtml = resptext;
  }, onError: (e) {
    pageboard.innerHtml = '<h2 class="error">NOT FOUND!</h2>';
  });
}
