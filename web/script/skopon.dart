import 'dart:html';
import 'dart:async';
import 'dart:json';
import 'nawms.dart';

var pageboard = query('#pageboard');

main() {
  var pagename = determineDesiredPage();
  displayPage(pagename);
}

createEditForm(String pn) {
  var hipx = (window.innerHeight * 1) ~/ 2;
  var h = new HeadingElement.h3();
  h.text = 'Edit ${pn.replaceAll('_', ' ')}';
  pageboard.children.add(h);
  var taArticle = new TextAreaElement()
    ..id = 'article'
    ..name = 'article';
  taArticle.classes.add('article-edit');
  taArticle.style.height = '${hipx}px';
  var buSaveArticle = new ButtonInputElement()
    ..id = 'save'
    ..value = 'save';
  pageboard.children.add(taArticle);
  pageboard.children.add(buSaveArticle);
  buSaveArticle.onClick.listen((e) => postArticle());
}

String determineDesiredPage() {
  var pagepath = window.location.pathname;
  if (pagepath == '/') {
    return 'Page_One';
  } else {
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
    createEditForm(pn);
  });
}

postArticle() {
  print('inside postArticle...');
}
