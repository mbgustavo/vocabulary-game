// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Juego de Vocabulario';

  @override
  String get appLoading => 'Cargando...';

  @override
  String get homeWelcome => '¡Bienvenido a Juego de Vocabulario!';

  @override
  String homeYouAreLearning(String language) {
    return 'Estás aprendiendo $language';
  }

  @override
  String get homeStartGame => 'Comenzar juego';

  @override
  String get homeVocabularyTooSmall =>
      'Necesitas al menos 5 palabras para comenzar un juego';

  @override
  String get homeLanguages => 'Idiomas de aprendizaje';

  @override
  String get homeVocabulary => 'Vocabulario';

  @override
  String get languagesTitle => 'Idiomas de aprendizaje';

  @override
  String get languagesAdd => 'Agregar idioma';

  @override
  String get languagesSelect => 'Seleccionar idioma de aprendizaje';

  @override
  String languagesCurrent(String language) {
    return 'Actual: $language';
  }

  @override
  String get vocabularyTitle => 'Vocabulario';

  @override
  String get vocabularyAddWord => 'Agregar palabra';

  @override
  String get vocabularyNoWords =>
      'Sin palabras aún. ¡Agrega algunas para comenzar!';

  @override
  String get vocabularyDeleteConfirm =>
      '¿Estás seguro de que deseas eliminar esta palabra?';

  @override
  String get vocabularyDelete => 'Eliminar';

  @override
  String get vocabularyCancel => 'Cancelar';

  @override
  String get gameSelectTitle => 'Seleccionar juego';

  @override
  String get gameSelectGameMode => 'Selecciona un modo de juego:';

  @override
  String get gameDifficultyEasy => 'Fácil';

  @override
  String get gameDifficultyMedium => 'Medio';

  @override
  String get gameDifficultyHard => 'Difícil';

  @override
  String get gameDifficultyRandom => 'Aleatorio';

  @override
  String get gameConnectWords => 'Conectar palabras';

  @override
  String get gameMultipleChoice => 'Opción múltiple';

  @override
  String get gameWriteWords => 'Escribir palabras';

  @override
  String get connectionGameTitle => 'Juego de Conexión';

  @override
  String get multipleChoiceGameTitle => 'Juego de Opción Múltiple';

  @override
  String get writeGameTitle => 'Juego de Escritura';

  @override
  String get gameFromTranslations => 'de traducciones';

  @override
  String get gameAnyGameMode => 'Cualquier modo de juego';

  @override
  String get gameFlashcards => 'Tarjetas de memoria';

  @override
  String get gameTyping => 'Escritura';

  @override
  String get gamePlayButton => 'Jugar';

  @override
  String get gameBack => 'Atrás';

  @override
  String gameScore(int score) {
    return 'Puntuación: $score';
  }

  @override
  String get gameCompleted => '¡Juego completado!';

  @override
  String gameFinalScore(int score) {
    return 'Puntuación final: $score';
  }

  @override
  String get dataTitle => 'Administrar datos';

  @override
  String get dataTooltip => 'Menú de datos';

  @override
  String get dataExport => 'Exportar vocabulario';

  @override
  String get dataImport => 'Importar vocabulario';

  @override
  String get dataClear => 'Borrar todos los datos';

  @override
  String get dataClearConfirm =>
      'Esto eliminará todos tus datos. Esta acción no se puede deshacer.';

  @override
  String get newWordTitle => 'Agregar nueva palabra';

  @override
  String get newWordInputLabel => 'Palabra en idioma de aprendizaje';

  @override
  String get newWordTranslationLabel => 'Traducción en tu idioma';

  @override
  String get newWordExamplesLabel => 'Ejemplos (opcional)';

  @override
  String get newWordWord => 'Palabra';

  @override
  String get newWordTranslation => 'Traducción';

  @override
  String get newWordExample => 'Ejemplo (opcional)';

  @override
  String get newWordSave => 'Guardar';

  @override
  String get fluencyLevel => 'Nivel de fluidez';

  @override
  String get fluencyLevelHelper =>
      'Las palabras con niveles de fluidez más bajos aparecerán más a menudo en los juegos.';

  @override
  String validationCharacterRange(int minLength, int maxLength) {
    return 'Debe tener entre $minLength y $maxLength caracteres.';
  }

  @override
  String get errorTitle => 'Error';

  @override
  String get errorLoadingData => 'Error al cargar datos';

  @override
  String get errorSavingData => 'Error al guardar datos';

  @override
  String get successTitle => 'Éxito';

  @override
  String get successWordAdded => 'Palabra agregada exitosamente';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonDelete => 'Eliminar';

  @override
  String get commonSave => 'Guardar';

  @override
  String get commonNext => 'Siguiente';

  @override
  String get commonPlayAgain => 'Jugar de nuevo';

  @override
  String get commonRestore => 'Restaurar';

  @override
  String get allLanguages => 'Todos los idiomas';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get deleteLanguageTitle => 'Eliminar idioma';

  @override
  String get deleteWordTitle => 'Eliminar palabra';

  @override
  String get incorrectMatch => '¡Coincidencia incorrecta! Intenta de nuevo.';

  @override
  String get vocabularyEmptyMessage => 'Sin palabras en este vocabulario.';

  @override
  String get saveLanguage => 'Guardar idioma';

  @override
  String get restoreDefaults => 'Restaurar valores predeterminados';

  @override
  String get confirmRestore => 'Confirmar restauración';

  @override
  String get gameWriteInstruction => 'Escribe la traducción de la palabra:';

  @override
  String get gameAnswerLabel => 'Tu respuesta';

  @override
  String get gameSubmit => 'Enviar';

  @override
  String get gameCompleteMessage => '¡Felicitaciones! ¡Completaste el juego!';

  @override
  String deleteLanguageConfirm(String language) {
    return '¿Estás seguro de que deseas eliminar $language y su vocabulario? Esta acción no se puede deshacer.';
  }

  @override
  String deleteWordConfirm(String word) {
    return '¿Estás seguro de que deseas eliminar la palabra $word? Esta acción no se puede deshacer.';
  }

  @override
  String get noWordsInVocabulary => 'Sin palabras en este vocabulario.';

  @override
  String get dataManageTitle => 'Administra tus datos de vocabulario';

  @override
  String get dataSaveBackupTitle => 'Guardar copia de seguridad';

  @override
  String get dataSaveBackupSubtitle =>
      'Guarda tu vocabulario y idiomas actuales';

  @override
  String get dataRestoreBackupTitle => 'Restaurar copia de seguridad';

  @override
  String get dataRestoreBackupSubtitle =>
      'Restaura desde una copia de seguridad guardada anteriormente';

  @override
  String get dataRestoreDefaultsTitle => 'Restaurar valores predeterminados';

  @override
  String get dataRestoreDefaultsSubtitle =>
      'Restablece los valores predeterminados y borra todos los datos';

  @override
  String get dataSaveFileDialogTitle =>
      'Guardar copia de seguridad de vocabulario';

  @override
  String dataSaveSuccessMessage(String filename) {
    return 'Copia de seguridad guardada exitosamente en: $filename';
  }

  @override
  String dataSaveErrorMessage(String error) {
    return 'Error al guardar la copia de seguridad: $error';
  }

  @override
  String get dataRestoreFileDialogTitle =>
      'Selecciona el archivo de copia de seguridad para restaurar';

  @override
  String dataRestoreErrorMessage(String error) {
    return 'Error al restaurar la copia de seguridad: $error';
  }

  @override
  String get dataRestoreDefaultsConfirmMessage =>
      'Esto eliminará todos tus datos de vocabulario e idiomas, devolviendo la aplicación a su estado inicial. Puedes crear una copia de seguridad primero si deseas guardar tus datos actuales. Esta acción no se puede deshacer.\n\n¿Estás seguro de que deseas continuar?';

  @override
  String get dataRestoreDefaultsSuccessMessage =>
      'Se restauraron exitosamente los valores predeterminados';

  @override
  String dataRestoreDefaultsErrorMessage(String error) {
    return 'Error al restaurar los valores predeterminados: $error';
  }

  @override
  String get dataConfirmRestoreTitle => 'Confirmar restauración';

  @override
  String get dataConfirmRestoreMessage =>
      'Esto reemplazará todos tus datos actuales con los datos de la copia de seguridad. Esta acción no se puede deshacer.\n\n¿Estás seguro de que deseas continuar?';

  @override
  String get dataRestoreSuccessMessage =>
      'Copia de seguridad restaurada exitosamente';

  @override
  String get dataRestoreDefaultsButton => 'Restaurar valores predeterminados';

  @override
  String get dataRestoreButton => 'Restaurar';
}
