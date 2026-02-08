import 'package:shared_preferences.dart';

class GameState {
  static const int maxLives = 5;
  static const Duration lifeRegenerationDuration = Duration(hours: 1);
  
  int _lives = maxLives;
  int _coins = 0;
  int _currentLevel = 1;
  DateTime? _lastLifeLostTime;
  
  int get lives => _lives;
  int get coins => _coins;
  int get currentLevel => _currentLevel;
  
  Future<void> loadGameState() async {
    final prefs = await SharedPreferences.getInstance();
    _lives = prefs.getInt('lives') ?? maxLives;
    _coins = prefs.getInt('coins') ?? 0;
    _currentLevel = prefs.getInt('currentLevel') ?? 1;
    
    final lastLostString = prefs.getString('lastLifeLostTime');
    if (lastLostString != null) {
      _lastLifeLostTime = DateTime.parse(lastLostString);
      _regenerateLives();
    }
  }
  
  Future<void> _saveGameState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lives', _lives);
    await prefs.setInt('coins', _coins);
    await prefs.setInt('currentLevel', _currentLevel);
    if (_lastLifeLostTime != null) {
      await prefs.setString('lastLifeLostTime', _lastLifeLostTime!.toIso8601String());
    }
  }
  
  void _regenerateLives() {
    if (_lastLifeLostTime == null || _lives >= maxLives) return;
    
    final now = DateTime.now();
    final timePassed = now.difference(_lastLifeLostTime!);
    final livesToAdd = timePassed.inHours;
    
    if (livesToAdd > 0) {
      _lives = (_lives + livesToAdd).clamp(0, maxLives);
      if (_lives >= maxLives) {
        _lastLifeLostTime = null;
      } else {
        _lastLifeLostTime = _lastLifeLostTime!.add(Duration(hours: livesToAdd));
      }
      _saveGameState();
    }
  }
  
  Future<void> loseLife() async {
    if (_lives > 0) {
      _lives--;
      if (_lastLifeLostTime == null && _lives < maxLives) {
        _lastLifeLostTime = DateTime.now();
      }
      await _saveGameState();
    }
  }
  
  Future<void> addLife() async {
    if (_lives < maxLives) {
      _lives++;
      if (_lives >= maxLives) {
        _lastLifeLostTime = null;
      }
      await _saveGameState();
    }
  }
  
  Future<void> addCoins(int amount) async {
    _coins += amount;
    await _saveGameState();
  }
  
  Future<void> spendCoins(int amount) async {
    _coins = (_coins - amount).clamp(0, _coins);
    await _saveGameState();
  }
  
  Future<void> completeLevel() async {
    _currentLevel++;
    await _saveGameState();
  }
  
  Duration? getTimeUntilNextLife() {
    if (_lives >= maxLives || _lastLifeLostTime == null) return null;
    
    final nextLifeTime = _lastLifeLostTime!.add(lifeRegenerationDuration);
    final now = DateTime.now();
    
    if (nextLifeTime.isAfter(now)) {
      return nextLifeTime.difference(now);
    }
    return null;
  }
}
