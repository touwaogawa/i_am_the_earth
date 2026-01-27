// Language enumeration
enum Language {
  JAPANESE,
  ENGLISH
}

// Language Manager class to handle all UI text localization
class LanguageManager {
  private Language currentLanguage;
  
  LanguageManager() {
    // Default to Japanese
    currentLanguage = Language.JAPANESE;
  }
  
  Language getCurrentLanguage() {
    return currentLanguage;
  }
  
  void setLanguage(Language lang) {
    currentLanguage = lang;
  }
  
  void toggleLanguage() {
    if (currentLanguage == Language.JAPANESE) {
      currentLanguage = Language.ENGLISH;
    } else {
      currentLanguage = Language.JAPANESE;
    }
  }
  
  // Get localized text by key
  String getText(String key) {
    if (currentLanguage == Language.JAPANESE) {
      return getJapaneseText(key);
    } else {
      return getEnglishText(key);
    }
  }
  
  // Japanese text strings
  private String getJapaneseText(String key) {
    switch (key) {
      // Title screen
      case "GAME_TITLE":
        return "私が地球だ";
      case "PLAYER_JOINED":
        return " [X] - 参加済み！";
      case "PLAYER_JOIN_PROMPT":
        return " [X] - 押して参加";
      case "START_INSTRUCTION":
        return "スペースキーでスタート！";
      case "MIN_PLAYERS_REQUIRED":
        return "最低2人のプレイヤーが必要です";
      case "SPACE_KEY_BUBBLE":
        return "このスペースは宇宙の\nスペースではなく、\nキーボードのスペースです。";
      case "LANGUAGE_TOGGLE":
        return "EN";
      
      // In-game HUD
      case "PLAYERS_ALIVE":
        return "生存プレイヤー: ";
      case "SOUND_TOGGLE":
        return "B: サウンド切替";
      
      // Game over screen
      case "PLAYER_WINS":
        return "プレイヤー %d の勝利！";
      case "DRAW":
        return "引き分け！";
      case "RESTART_INSTRUCTION":
        return "Rキーで再スタート";
      
      // Celestial bodies
      case "SUN":
        return "太陽";
      case "VENUS":
        return "金星";
      case "MERCURY":
        return "水星";
      case "EARTH":
        return "地球 P%d";
      
      default:
        return key;
    }
  }
  
  // English text strings
  private String getEnglishText(String key) {
    switch (key) {
      // Title screen
      case "GAME_TITLE":
        return "I am the Earth";
      case "PLAYER_JOINED":
        return " [X] - Joined!";
      case "PLAYER_JOIN_PROMPT":
        return " [X] - Press to join";
      case "START_INSTRUCTION":
        return "Press SPACE to Start!";
      case "MIN_PLAYERS_REQUIRED":
        return "At least 2 players required";
      case "SPACE_KEY_BUBBLE":
        return "This space is not the space\nin the universe, but the\nspace on the keyboard.";
      case "LANGUAGE_TOGGLE":
        return "JP";
      
      // In-game HUD
      case "PLAYERS_ALIVE":
        return "Players alive: ";
      case "SOUND_TOGGLE":
        return "B: Toggle Sound";
      
      // Game over screen
      case "PLAYER_WINS":
        return "Player %d Wins!";
      case "DRAW":
        return "Draw!";
      case "RESTART_INSTRUCTION":
        return "Press R to Restart";
      
      // Celestial bodies
      case "SUN":
        return "Sun";
      case "VENUS":
        return "Venus";
      case "MERCURY":
        return "Mercury";
      case "EARTH":
        return "Earth P%d";
      
      default:
        return key;
    }
  }
}
