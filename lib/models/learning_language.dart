class Language {
  final String name;
  final String icon;
  final String value;

  Language(this.name, this.icon)
    : value = name.toLowerCase().replaceAll(' ', '-');
}
