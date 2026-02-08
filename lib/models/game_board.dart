import 'dart:math';

enum TileType { red, blue, green, yellow, purple, orange }

class Tile {
  final TileType type;
  final int row;
  final int col;
  bool isMatched = false;
  
  Tile({required this.type, required this.row, required this.col});
  
  Tile copyWith({TileType? type, int? row, int? col, bool? isMatched}) {
    return Tile(
      type: type ?? this.type,
      row: row ?? this.row,
      col: col ?? this.col,
    )..isMatched = isMatched ?? this.isMatched;
  }
}

class GameBoard {
  final int rows;
  final int cols;
  final int level;
  late List<List<Tile?>> board;
  final Random _random = Random();
  
  int score = 0;
  int movesLeft;
  int targetScore;
  
  GameBoard({
    required this.level,
    this.rows = 8,
    this.cols = 8,
  }) : movesLeft = _calculateMoves(level),
       targetScore = _calculateTargetScore(level) {
    _initializeBoard();
  }
  
  static int _calculateMoves(int level) {
    // Decrease moves as level increases
    return max(15, 30 - level);
  }
  
  static int _calculateTargetScore(int level) {
    // Increase target score as level increases
    return 100 + (level * 50);
  }
  
  void _initializeBoard() {
    board = List.generate(
      rows,
      (row) => List.generate(
        cols,
        (col) => Tile(
          type: _randomTileType(),
          row: row,
          col: col,
        ),
      ),
    );
    
    // Remove initial matches
    while (_hasMatches()) {
      _removeMatches();
      _fillEmptySpaces();
    }
  }
  
  TileType _randomTileType() {
    final types = TileType.values;
    // Reduce available colors for higher levels to increase difficulty
    final availableTypes = level > 10 ? types.length : min(4 + (level ~/ 2), types.length);
    return types[_random.nextInt(availableTypes)];
  }
  
  bool canSwap(int row1, int col1, int row2, int col2) {
    // Check if tiles are adjacent
    if ((row1 == row2 && (col1 - col2).abs() == 1) ||
        (col1 == col2 && (row1 - row2).abs() == 1)) {
      return true;
    }
    return false;
  }
  
  bool swapTiles(int row1, int col1, int row2, int col2) {
    if (!canSwap(row1, col1, row2, col2)) return false;
    
    // Swap tiles
    final temp = board[row1][col1];
    board[row1][col1] = board[row2][col2];
    board[row2][col2] = temp;
    
    // Update positions
    if (board[row1][col1] != null) {
      board[row1][col1] = board[row1][col1]!.copyWith(row: row1, col: col1);
    }
    if (board[row2][col2] != null) {
      board[row2][col2] = board[row2][col2]!.copyWith(row: row2, col: col2);
    }
    
    // Check if swap creates matches
    if (_hasMatches()) {
      movesLeft--;
      return true;
    } else {
      // Swap back if no matches
      final temp2 = board[row1][col1];
      board[row1][col1] = board[row2][col2];
      board[row2][col2] = temp2;
      
      if (board[row1][col1] != null) {
        board[row1][col1] = board[row1][col1]!.copyWith(row: row1, col: col1);
      }
      if (board[row2][col2] != null) {
        board[row2][col2] = board[row2][col2]!.copyWith(row: row2, col: col2);
      }
      return false;
    }
  }
  
  bool _hasMatches() {
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        if (board[row][col] == null) continue;
        
        // Check horizontal matches
        if (col <= cols - 3) {
          if (board[row][col]!.type == board[row][col + 1]?.type &&
              board[row][col]!.type == board[row][col + 2]?.type) {
            return true;
          }
        }
        
        // Check vertical matches
        if (row <= rows - 3) {
          if (board[row][col]!.type == board[row + 1][col]?.type &&
              board[row][col]!.type == board[row + 2][col]?.type) {
            return true;
          }
        }
      }
    }
    return false;
  }
  
  int processMatches() {
    int matchCount = 0;
    
    while (_hasMatches()) {
      matchCount += _removeMatches();
      _fillEmptySpaces();
    }
    
    return matchCount;
  }
  
  int _removeMatches() {
    List<List<bool>> toRemove = List.generate(rows, (_) => List.filled(cols, false));
    int matchCount = 0;
    
    // Mark horizontal matches
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col <= cols - 3; col++) {
        if (board[row][col] == null) continue;
        
        int matchLength = 1;
        while (col + matchLength < cols &&
               board[row][col + matchLength]?.type == board[row][col]!.type) {
          matchLength++;
        }
        
        if (matchLength >= 3) {
          for (int i = 0; i < matchLength; i++) {
            toRemove[row][col + i] = true;
          }
        }
      }
    }
    
    // Mark vertical matches
    for (int col = 0; col < cols; col++) {
      for (int row = 0; row <= rows - 3; row++) {
        if (board[row][col] == null) continue;
        
        int matchLength = 1;
        while (row + matchLength < rows &&
               board[row + matchLength][col]?.type == board[row][col]!.type) {
          matchLength++;
        }
        
        if (matchLength >= 3) {
          for (int i = 0; i < matchLength; i++) {
            toRemove[row + i][col] = true;
          }
        }
      }
    }
    
    // Remove marked tiles
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        if (toRemove[row][col]) {
          board[row][col] = null;
          matchCount++;
          score += 10;
        }
      }
    }
    
    return matchCount;
  }
  
  void _fillEmptySpaces() {
    // Drop existing tiles
    for (int col = 0; col < cols; col++) {
      int emptyRow = rows - 1;
      for (int row = rows - 1; row >= 0; row--) {
        if (board[row][col] != null) {
          if (row != emptyRow) {
            board[emptyRow][col] = board[row][col]!.copyWith(row: emptyRow, col: col);
            board[row][col] = null;
          }
          emptyRow--;
        }
      }
    }
    
    // Fill from top
    for (int col = 0; col < cols; col++) {
      for (int row = 0; row < rows; row++) {
        if (board[row][col] == null) {
          board[row][col] = Tile(
            type: _randomTileType(),
            row: row,
            col: col,
          );
        }
      }
    }
  }
  
  bool isLevelComplete() {
    return score >= targetScore;
  }
  
  bool isLevelFailed() {
    return movesLeft <= 0 && score < targetScore;
  }
}
