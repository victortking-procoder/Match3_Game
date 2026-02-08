import 'package:flutter/material.dart';
import 'dart:async';
import '../models/game_board.dart';
import '../models/game_state.dart';
import '../services/ad_manager.dart';
import '../widgets/game_board_widget.dart';
import '../widgets/lives_display.dart';
import '../widgets/game_info.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameState _gameState = GameState();
  final AdManager _adManager = AdManager();
  late GameBoard _gameBoard;
  Timer? _lifeTimer;
  bool _isLoading = true;
  bool _isFirstGame = true; // Track if it's the first game

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    await _gameState.loadGameState();
    _gameBoard = GameBoard(level: _gameState.currentLevel);
    
    _adManager.loadRewardedAd(onAdLoaded: () {
      print('Rewarded ad loaded and ready');
    });
    _adManager.loadInterstitialAd(onAdLoaded: () {
      print('Interstitial ad loaded and ready');
    });
    
    _startLifeTimer();
    
    setState(() {
      _isLoading = false;
    });
  }

  void _startLifeTimer() {
    _lifeTimer?.cancel();
    _lifeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _lifeTimer?.cancel();
    _adManager.dispose();
    super.dispose();
  }

  void _onTileSwap(int row1, int col1, int row2, int col2) {
    if (_gameBoard.swapTiles(row1, col1, row2, col2)) {
      setState(() {});
      
      Future.delayed(const Duration(milliseconds: 300), () {
        final matchCount = _gameBoard.processMatches();
        setState(() {});
        
        if (_gameBoard.isLevelComplete()) {
          _onLevelComplete();
        } else if (_gameBoard.isLevelFailed()) {
          _onLevelFailed();
        }
      });
    }
  }

  void _onLevelComplete() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Level Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Score: ${_gameBoard.score}'),
            const SizedBox(height: 20),
            const Text('Watch an ad to earn 50 coins?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _proceedToNextLevel();
            },
            child: const Text('Skip'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showRewardedAdForCoins();
            },
            child: const Text('Watch Ad'),
          ),
        ],
      ),
    );
  }

  void _showRewardedAdForCoins() {
    if (!_adManager.isRewardedAdReady) {
      // Ad not ready, proceed without coins
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ad not ready yet. Proceeding to next level...'),
          duration: Duration(seconds: 2),
        ),
      );
      _proceedToNextLevel();
      return;
    }
    
    _adManager.showRewardedAd(
      onRewarded: () async {
        await _gameState.addCoins(50);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🎉 +50 Coins!'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      onAdDismissed: () {
        _proceedToNextLevel();
      },
    );
  }

  Future<void> _proceedToNextLevel() async {
    await _gameState.completeLevel();
    
    _adManager.showInterstitialAd(
      onAdDismissed: () {
        // Lose a life for playing the next level
        if (_gameState.lives > 0) {
          _gameState.loseLife();
          setState(() {
            _gameBoard = GameBoard(level: _gameState.currentLevel);
          });
        } else {
          _showOutOfLivesDialog();
        }
      },
    );
  }

  void _onLevelFailed() {
    // Life was already lost when starting the level
    
    if (!mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Level Failed'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Score: ${_gameBoard.score}/${_gameBoard.targetScore}'),
            const SizedBox(height: 20),
            const Text('Watch an ad to replay?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _gameBoard = GameBoard(level: _gameState.currentLevel);
              });
            },
            child: const Text('New Game'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showRewardedAdForReplay();
            },
            child: const Text('Watch Ad'),
          ),
        ],
      ),
    );
  }

  void _showRewardedAdForReplay() {
    if (!_adManager.isRewardedAdReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ad not ready yet. Starting new game...'),
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        _gameBoard = GameBoard(level: _gameState.currentLevel);
      });
      return;
    }
    
    _adManager.showRewardedAd(
      onRewarded: () async {
        await _gameState.addLife();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('❤️ +1 Life! Replaying level...'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );
          setState(() {
            _gameBoard = GameBoard(level: _gameState.currentLevel);
          });
        }
      },
      onAdDismissed: () {
        setState(() {
          _gameBoard = GameBoard(level: _gameState.currentLevel);
        });
      },
    );
  }

  void _showOutOfLivesDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Out of Lives'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Watch an ad to get 1 extra life?'),
            const SizedBox(height: 10),
            Text('Or wait for: ${_formatDuration(_gameState.getTimeUntilNextLife())}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Wait'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showRewardedAdForLife();
            },
            child: const Text('Watch Ad'),
          ),
        ],
      ),
    );
  }

  void _showRewardedAdForLife() {
    if (!_adManager.isRewardedAdReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ad not ready yet. Please wait...'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    
    _adManager.showRewardedAd(
      onRewarded: () async {
        await _gameState.addLife();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('❤️ +1 Life!'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );
          setState(() {});
        }
      },
      onAdDismissed: () {
        setState(() {});
      },
    );
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return '0m';
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}m ${seconds}s';
  }

  void _startNewGame() {
    if (_gameState.lives <= 0) {
      _showOutOfLivesDialog();
      return;
    }
    
    // Don't lose a life on the very first game, but lose on subsequent games
    if (!_isFirstGame) {
      _gameState.loseLife();
    } else {
      _isFirstGame = false; // No longer the first game
    }
    
    setState(() {
      _gameBoard = GameBoard(level: _gameState.currentLevel);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Match 3 Game'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: LivesDisplay(
                lives: _gameState.lives,
                maxLives: GameState.maxLives,
                timeUntilNextLife: _gameState.getTimeUntilNextLife(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GameInfo(
                level: _gameState.currentLevel,
                score: _gameBoard.score,
                targetScore: _gameBoard.targetScore,
                movesLeft: _gameBoard.movesLeft,
                coins: _gameState.coins,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: GameBoardWidget(
                  gameBoard: _gameBoard,
                  onTileSwap: _onTileSwap,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _gameState.lives > 0 ? _startNewGame : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  _gameState.lives > 0 ? 'New Game' : 'Out of Lives',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
