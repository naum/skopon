import 'dart:html';
import 'dart:async';
import 'dart:json';
import 'dart:uri';
import 'nawms.dart';

var pageboard = query('#pageboard');
var pagecommandbar = query('#pagecommandbar');
var pagename;
var wikibody = '';

main() {
  pagename = determineDesiredPage();
  fetchPage(pagename);
}

createEditForm(String pn) {
  pagecommandbar.children.clear();
  pageboard.children.clear();
  var hipx = (window.innerHeight * 1) ~/ 2;
  var h = new HeadingElement.h3();
  h.text = 'Edit ${pn.replaceAll('_', ' ')}';
  pageboard.children.add(h);
  var taArticle = new TextAreaElement()
    ..id = 'article'
    ..name = 'article'
    ..value = wikibody;
  taArticle.classes.add('article-edit');
  taArticle.style.height = '${hipx}px';
  var buSaveArticle = new ButtonElement()
    ..id = 'save'
    ..text = 'Save';
  pageboard.children.add(taArticle);
  pagecommandbar.children.add(buSaveArticle);
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

displayPage() {
  var h = '<h3>${pagename.replaceAll('_', ' ')}</h3>';
  pageboard.children.clear();
  pageboard.innerHtml = h + wikiToHtml(wikibody);
  pagecommandbar.children.clear();
  var buEditArticle = new ButtonElement()
    ..id = 'edit'
    ..text = 'Edit';
  pagecommandbar.children.add(buEditArticle);
  buEditArticle.onClick.listen((e) => createEditForm(pagename));
}

fetchPage(pn) {
  pagename = pn;
  var u = '/page/${pn}';
  var req = HttpRequest.getString(u).then((resptext) {
    wikibody = resptext;
    displayPage();
  }).catchError((e) {
    wikibody = '';
    createEditForm(pn);
  });
}

postArticle() {
  var articleBody = query('#article').value;
  wikibody = query('#article').value;
  Map jo = {
    'title': pagename,
    'article': articleBody
  };
  var postdata = encodeUriComponent(stringify(jo));
  HttpRequest.request('/save', method: 'POST', sendData: postdata).then((r) {
    var rstat = parse(r.response);
    if (rstat['isOK']) {
      displayPage();
    } else {
      window.alert('There was a problem with saving this page!');
    }
  }).catchError((e) {
    print('error: ${e}');
  });
}
