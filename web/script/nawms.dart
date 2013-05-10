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
  return '<pre><code>${escblock[n]}</code></pre>\n';
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
  var reHeading = new RegExp(r'^(!{1,4})(.*)$');
  var reStrong = new RegExp(r'\*\*(.*?)\*\*');
  var reEmphasis = new RegExp(r'\_\_(.*?)\_\_');
  var reMonospace = new RegExp(r'\`\`(.*?)\`\`');
  var reWikiLink = new RegExp(r'\~(\w+)');
  for (var line in tex.split('\n')) {
    num depth = 0;
    if (reBlankLine.hasMatch(line)) continue;
    if (reBulletListItem.hasMatch(line)) {
      line = line.replaceAllMapped(reBulletListItem, (m) {
        depth = m.group(1).length;
        return '<li>${m.group(2).trim()}</li>';
      });
      hout.write(emit('ul', depth));
    } else if (reEnumeratedListItem.hasMatch(line)) {
      line = line.replaceAllMapped(reEnumeratedListItem, (m) {
        depth = m.group(1).length;
        return '<li>${m.group(2).trim()}</li>';
      });
      hout.write(emit('ol', depth));
    } else if (reBlockquote.hasMatch(line)) {
      line = line.replaceAllMapped(reBlockquote, (m) {
        depth = m.group(1).length ~/ 4;
        return '<p>${m.group(3)}</p>';
      });
      hout.write(emit('blockquote', depth));
    } else if (reDefinitionList.hasMatch(line)) {
      line = line.replaceAllMapped(reDefinitionList, (m) {
        depth = int.parse(m.group(1));
        return '<dt>${m.group(2)}</dt><dd>${m.group(4)}</dd>';
      });
      hout.write(emit('dl', depth));
    } else if (reHorizontalRule.hasMatch(line)) {
      line = line.replaceAllMapped(reHorizontalRule, (m) => '<hr>\n');
      hout.write(emit('eots', 0));
    } else if (reHeading.hasMatch(line)) {
      line = line.replaceAllMapped(reHeading, (m) {
        var h = 'h${m.group(1).length + 2}';
        return '<$h>${m.group(2)}</$h>\n';
      });
      hout.write(emit('eots', 0));
    } else {
      line = '<p>$line</p>';
      hout.write(emit('eots', 0));
    }
    line = line.replaceAllMapped(reStrong, (m) => '<strong>${m.group(1)}</strong>');
    line = line.replaceAllMapped(reEmphasis, (m) => '<em>${m.group(1)}</em>');
    line = line.replaceAllMapped(reMonospace, (m) => '<tt>${m.group(1)}</tt>');
    line = line.replaceAllMapped(reWikiLink, wikilink);
    hout.write('${line}\n');
  }
  hout.write(emit('eots', 0));
  return hout.toString();
}

String unixfyEol(String s) {
  return (s.contains('\n')) ? s.replaceAll('\r', '') : s.replaceAll('\r', '\n');
}

String wikilink(Match m) {
  var page = m.group(1);
  var pagedesc = page.replaceAll('_', ' ');
  return '<a href="/page/${page}">$pagedesc</a>';
}
