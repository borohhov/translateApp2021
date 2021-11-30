class Translation {
  String originalText;
  String originalLanguage;
  String translatedText = "";
  String targetLanguage;
  Translation(this.originalText, this.originalLanguage,
      this.targetLanguage);


  Translation.fromJson(Map<String, dynamic> json)
      : originalText = json['originalText'],
        originalLanguage = json['originalLanguage'],
        translatedText = json['translatedText'],
        targetLanguage = json['targetLanguage'];

  Map<String, dynamic> toJson() => {
    'targetLanguage': targetLanguage,
    'originalLanguage': originalLanguage,
    'translatedText': translatedText,
    'targetLanguage': targetLanguage
  };
}