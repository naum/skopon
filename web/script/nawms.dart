library nawms;

final ESCMARK = new String.fromCharCode(949);
final LINKMARK = new String.fromCharCode(955);

List codestack = [];
List escblock = [];
List extlink = [];

String emit(String htag, num depth) {
  var tout = new StringBuffer();
  if (depth > codestack.length) {
    while (codestack.length < depth) {
      codestack.add(htag);
      tout.write('<${htag}>\n');
    }
  }
  if (depth < codestack.length) {
    while (codestack.length > depth) {
      tout.write('</${codestack.removeLast()}>\n');
    }
  }
  if (depth > 0 && depth == codestack.length && htag != codestack[codestack.length - 1]) {
    tout.write('</${codestack[depth - 1]}>\n');
    tout.write('<${htag}>\n');
    codestack[depth - 1] = htag;
  }
  return tout.toString();
}

String escapeBlock(Match m) {
  escblock.add(m.group(1));
  return '${ESCMARK}${escblock.length}${ESCMARK}';
}

String escapeHtmlSpecialChars(String s) {
  return s.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;');
}

String externalLink(Match m) {
  extlink.add(m.group(1));
  return '${LINKMARK}${extlink.length}${LINKMARK}';
}

String fillEscapeBlock(Match m) {
  var n = int.parse(m.group(1)) - 1;
  return '<pre>${escblock[n]}</pre>\n';
}

String fillExternalLink(Match m) {
  var n = int.parse(m.group(1)) - 1;
  return '<a href="${extlink[n]}">${extlink[n]}</a>';
}

String wikiToHtml(String tex) {
  var hout = new StringBuffer();
  tex = unixfyEol(tex);
  tex = escapeHtmlSpecialChars(tex);
  var reBlankLine = new RegExp(r'^\s*$');
  var reBulletListItem = new RegExp(r'^(\*+)(.*)$');
  var reEnumeratedListItem = new RegExp(r'^(\#+)(.*)$');
  var reBlockquote = new RegExp(r'^((\&gt\;)+)(.*)$');
  var reDefinitionList = new RegExp(r'^(:+)(.+?):( +)(.*)$');
  var reHorizontalRule = new RegExp(r'^----*(.*)$');
  var reHeading = new RegExp(r'^!{1,4}(.*)$'
  for (var line in tex.split('\n')) {
    var depth = 0;
    if (reBlankLine.hasMatch(line)) continue;
    if (reBulletListItem.hasMatch(line)) {
      line = line.replaceAllMapped(reBulletListItem, (m) {
        depth = m.group(1).length;
        return '<li>${m.group(2)}</li>';
      });
      hout.write(emit('ul', depth));
    } else if (reEnumeratedListItem.hasMatch(line)) {
      line = line.replaceAllMapped(reEnumeratedListItem, (m) {
        depth = m.group(1).length;
        return '<li>${m.group(2)}</li>';
      });
      hout.write(emit('ol', depth));
    } else if (reBlockquote.hasMatch(line)) {
      line = line.replaceAllMapped(reBlockquote, (m) {
        depth = int.parse(m.group(1)) / 4;
        return '<p>${m.group(2)}</p>';
      });
      hout.write(emit('blockquote', depth));
    } else if (reDefinitionList.hasMatch(line)) {
    } else if (reHorizontalRule.hasMatch(line)) {
    } else if (reHeading.hasMatch(line)) {
    } else {
      line = '<p>$line</p>';
      hout.write(emit('eots', 0));
    }
  }
}

String unixfyEol(String s) {
  return (s.contains('\n')) ? s.replaceAll('\r', '') : s.replaceAll('\r', '\n');
}
