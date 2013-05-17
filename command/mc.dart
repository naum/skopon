#!/usr/bin/env dart

import 'dart:io';
import 'dart:async';
import 'dart:json';
import 'dart:math';
import 'dart:crypto';

final ADMIN_STASH = '../data/admin.json';
final ARGV = new Options().arguments;
final ERROR_MISSING_ADMIN_NAME = 'No admin name entered!';
final PASS_SALT = 'Hell is hopelessness.';
final SCRIPT_NAME = new Options().script;

main() {
  var command;
  if (ARGV.length > 0) {
    command = ARGV[0];
  }
  if (command == 'addadmin') addAdmin();
  else if (command == 'changeadminpass') changeAdminPassword();
  else print('Unknown command!');
}

addAdmin() {
  if (ARGV.length < 2) {
    print('Missing admin name!');
    return null;
  }
  var adminStore, password, passtoken, username;
  var af = new File(ADMIN_STASH);
  if (af.existsSync()) {
    adminStore = parse(af.readAsStringSync());
  } else {
    adminStore = {};
  }
  if (adminStore.containsKey(ARGV[1])) {
    print('Admin already on file!');
    return null;
  } else {
    username = ARGV[1];
    password = generatePassword();
    passtoken = generateToken(username, password);
    adminStore[username] = { 'password': password, 'passtoken': passtoken };
    print('Username: ${username}, Password: ${password}, Passtoken: ${passtoken}');
    af.writeAsStringSync(stringify(adminStore));
  }
}

changeAdminPassword() {
  if (ARGV.length < 3) {
    print('Missing admin name and/or new password!');
    return null;
  }
  var adminStore;
  var af = new File(ADMIN_STASH);
  if (af.existsSync()) {
    adminStore = parse(af.readAsStringSync());
  } else {
    print('No admin store exists!');
    return null;
  }
  var username = ARGV[1];
  if (adminStore.containsKey(username)) {
    var password = ARGV[2];
    var passtoken = generateToken(username, password);
    adminStore[username] = { 'password': password, 'passtoken': passtoken };
    print('Username: ${username}, Password: ${password}, Passtoken: ${passtoken}');
    af.writeAsStringSync(stringify(adminStore));
  } else {
    print('Admin does not exist!');
  }
}

String generatePassword() {
  var df = new File('/usr/share/dict/words');
  var dw = df.readAsStringSync();
  var dwl = dw.split('\n');
  var reBonafide = new RegExp(r'^\w{2,6}$');
  dwl = dwl.where((e) => reBonafide.hasMatch(e)).toList();
  var pw = new StringBuffer();
  var rng = new Random();
  for (var i = 0; i < 3; i += 1) {
    var x = rng.nextInt(dwl.length);
    pw.write(dwl[x]);
  }
  return pw.toString();
}

String generateToken(String username, String password) {
  var sha1 = new SHA1();
  sha1.add('${PASS_SALT} ${username} ${password}'.codeUnits);
  return CryptoUtils.bytesToHex(sha1.close());
}
