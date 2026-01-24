import 'dart:ui';

enum LanguageEnum {
  english('en', 'English', 'English', Locale('en', 'US')),
  hindi('hi', 'हिन्दी', 'Hindi', Locale('hi', 'IN'));

  const LanguageEnum(this.code, this.nativeName, this.englishName, this.locale);

  final String code;
  final String nativeName;
  final String englishName;
  final Locale locale;

  static LanguageEnum fromCode(final String code) {
    return LanguageEnum.values.firstWhere(
      (final LanguageEnum language) => language.code == code,
      orElse: () => LanguageEnum.english,
    );
  }
}
