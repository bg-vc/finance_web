// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Vault`
  String get actionTitle0 {
    return Intl.message(
      'Vault',
      name: 'actionTitle0',
      desc: '',
      args: [],
    );
  }

  /// `Swap`
  String get actionTitle1 {
    return Intl.message(
      'Swap',
      name: 'actionTitle1',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get actionTitle2 {
    return Intl.message(
      'About',
      name: 'actionTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Connect Wallet`
  String get actionTitle3 {
    return Intl.message(
      'Connect Wallet',
      name: 'actionTitle3',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get vaultBalance {
    return Intl.message(
      'Balance',
      name: 'vaultBalance',
      desc: '',
      args: [],
    );
  }

  /// `Deposited`
  String get vaultDeposited {
    return Intl.message(
      'Deposited',
      name: 'vaultDeposited',
      desc: '',
      args: [],
    );
  }

  /// `APY`
  String get vaultApy {
    return Intl.message(
      'APY',
      name: 'vaultApy',
      desc: '',
      args: [],
    );
  }

  /// `Deposit`
  String get vaultDeposit {
    return Intl.message(
      'Deposit',
      name: 'vaultDeposit',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw`
  String get vaultWithdraw {
    return Intl.message(
      'Withdraw',
      name: 'vaultWithdraw',
      desc: '',
      args: [],
    );
  }

  /// `Harvest`
  String get vaultHarvest {
    return Intl.message(
      'Harvest',
      name: 'vaultHarvest',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}