import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Localized strings have keys and values for all supported locales',
      () async {
    final locales = ['en_US', 'pt_BR'];
    final supportedLocales = locales.map((e) => Locale(e)).toList();
    final localizations =
        await Future.wait(supportedLocales.map((locale) async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final jsonString =
          await rootBundle.loadString('lib/i18n/${locale.languageCode}.json');
      return Map<String, dynamic>.from(json.decode(jsonString));
    }));

    final allKeys = localizations.expand((m) => m.keys).toSet().toList();
    for (int i = 0; i < supportedLocales.length; i++) {
      final locale = supportedLocales[i];
      final localization = localizations[i];
      for (var key in allKeys) {
        final value = localization[key];
        expect(value, isNotNull,
            reason:
                'Value for key "$key" in locale "${locale.languageCode}" is missing');
        expect(value, isNotEmpty,
            reason:
                'Value for key "$key" in locale "${locale.languageCode}" is empty');
        expect(value, isNot(equals(key)),
            reason:
                'Value for key "$key" in locale "${locale.languageCode}" is equal to the key');
      }
    }
  });
}
