import 'package:flutter/material.dart';
import '../models/game_board.dart';

class GameBoardWidget extends StatefulWidget {
  final GameBoard gameBoard;
  final Function(int, int, int, int) onTileSwap;

  const GameBoardWidget({
    super.key,
    required this.gameBoard,
    required this.onTileSwap,
  });

  @override
  State<GameBoardWidget> createState() => _GameBoardWidgetState();
}

class _GameBoardWidgetState extends State<GameBoardWidget> {
  int? _selectedRow;
  int? _selectedCol;

  Color _getTileColor(TileType type) {
    switch (type) {
      case TileType.red:
        return Colors.red;
      case TileType.blue:
        return Colors.blue;
      case TileType.green:
        return Colors.green;
      case TileType.yellow:
        return Colors.yellow;
      case TileType.purple:
        return Colors.purple;
      case TileType.orange:
        return Colors.orange;
    }
  }

  void _onTileTap(int row, int col) {
    if (_selectedRow == null || _selectedCol == null) {
      setState(() {
        _selectedRow = row;
        _selectedCol = col;
      });
    } else {
      if (_selectedRow == row && _selectedCol == col) {
        setState(() {
          _selectedRow = null;
          _selectedCol = null;
        });
      } else {
        widget.onTileSwap(_selectedRow!, _selectedCol!, row, col);
        setState(() {
          _selectedRow = null;
          _selectedCol = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final boardSize = screenWidth * 0.9;
    final tileSize = boardSize / widget.gameBoard.cols;

    return Container(
      width: boardSize,
      height: boardSize,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.gameBoard.cols,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
        ),
        itemCount: widget.gameBoard.rows * widget.gameBoard.cols,
        itemBuilder: (context, index) {
          final row = index ~/ widget.gameBoard.cols;
          final col = index % widget.gameBoard.cols;
          final tile = widget.gameBoard.board[row][col];

          if (tile == null) {
            return Container(color: Colors.grey.shade100);
          }

          final isSelected = _selectedRow == row && _selectedCol == col;

          return GestureDetector(
            onTap: () => _onTileTap(row, col),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.all(isSelected ? 0 : 4),
              decoration: BoxDecoration(
                color: _getTileColor(tile.type),
                borderRadius: BorderRadius.circular(8),
                border: isSelected
                    ? Border.all(color: Colors.black, width: 3)
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        )
                      ]
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
