import 'dart:convert';
import 'package:easy_authenticator/model/totp.dart';
import 'package:flutter/material.dart';
import 'package:otp/otp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TOTPProvider with ChangeNotifier {
  List<TOTP> _accounts = [];
  double _progress = 0;
  double _second = 0;
  bool _isDarkMode = false;

  List<TOTP> get accounts => _accounts;

  double get progress => _progress;

  double get second => _second;

  bool get isDarkMode => _isDarkMode;

  TOTPProvider() {
    _loadPreferences();
    _loadAccounts();
    _generateTOTPs();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  void _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  void _loadAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final List<dynamic> jsonData =
        json.decode(prefs.getString('accounts') ?? '[]');
    _accounts = jsonData
        .map((e) => TOTP(
              accountName: e['account'],
              secret: e['secret'],
              totp: e['totp'],
            ))
        .toList();
    notifyListeners();
  }

  void _saveAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'accounts',
        json.encode(_accounts
            .map((e) => {
                  'account': e.accountName,
                  'secret': e.secret,
                })
            .toList()));
  }

  void _generateTOTPs() {
    for (var account in _accounts) {
      account.totp = OTP.generateTOTPCodeString(
          account.secret, DateTime.now().millisecondsSinceEpoch,
          interval: 30, algorithm: Algorithm.SHA1, isGoogle: true);
    }
    notifyListeners();

    _updateProgress();

    Future.delayed(const Duration(seconds: 1), _generateTOTPs);
  }

  void _updateProgress() {
    final time = DateTime.now().millisecondsSinceEpoch / 1000;
    _progress = (time % 30) / 30;
    _second = time % 30;
    notifyListeners();
  }

  void addAccount(String accountName, String secret) {
    _accounts.add(TOTP(accountName: accountName, secret: secret));
    _saveAccounts();
    _generateTOTPs();
  }

  void renameAccount(String id, String newName) {
    final account = _accounts.firstWhere((account) => account.id == id);
    account.accountName = newName;
    _saveAccounts();
    notifyListeners();
  }

  void deleteAccount(String id) {
    _accounts.removeWhere((account) => account.id == id);
    _saveAccounts();
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    _savePreferences();
    notifyListeners();
  }

  ColorScheme getColorScheme() {
    return ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: _isDarkMode ? Brightness.dark : Brightness.light,
    );
  }
}
