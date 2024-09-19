import 'dart:async';
import 'dart:math';
import 'package:esyearn/lib/firebase_auth.dart';
import 'package:esyearn/lib/globalAds.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  static const int _rows = 20;
  static const int _columns = 20;
  static const int _speed = 200;

  List<Offset> _snake = [Offset(10, 10)];
  Offset _food = Offset(5, 5);
  String _direction = 'right';
  Timer? _timer;
  bool _isGameOver = false;
  bool _hasSeenInstructions = false;
  bool _isPlaying = false;
  Operation operation = Operation();
  RewardedAd? _rewardedAd;
  int _rewardCount = 0;
  bool _isAdLoaded = false;
  int _pressCount = 0;
  bool _isButtonEnabled = true;

  @override
  void initState() {
    super.initState();
    loadAd();
    _loadRewardedAd();
  }

  void _showInstructions() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('How to Play'),
        content: Text(
          '''Swipe or Use Control the snake. Eat the red food to grow. Avoid hitting the walls or yourself!

How can you Earn?
Follow Instruction :
1) upto 30 point will credit  0.15
2) upto 50 point will credit  0.25
3) upto 100 point will credit 0.50
4) upto 200 point will credit 0.75
5) upto 500 point will credit 1.00
          ''',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _hasSeenInstructions = true;
                _startGame();
              });
            },
            child: Text('Start Game'),
          ),
        ],
      ),
    );
  }

  void _startGame() {
    _snake = [Offset(10, 10)];
    _direction = 'right';
    _generateFood();
    _isGameOver = false;
    _isPlaying = true;
    _timer = Timer.periodic(Duration(milliseconds: _speed), _updateGame);
  }

  void _generateFood() {
    Random random = Random();
    _food = Offset(
        random.nextInt(_columns).toDouble(), random.nextInt(_rows).toDouble());
  }

  void _updateGame(Timer timer) {
    if (!_isPlaying) return;

    setState(() {
      Offset newHead;
      switch (_direction) {
        case 'up':
          newHead = _snake.first.translate(0, -1);
          break;
        case 'down':
          newHead = _snake.first.translate(0, 1);
          break;
        case 'left':
          newHead = _snake.first.translate(-1, 0);
          break;
        case 'right':
          newHead = _snake.first.translate(1, 0);
          break;
        default:
          return;
      }

      if (_isCollision(newHead)) {
        _gameOver();
      } else {
        _snake.insert(0, newHead);
        if (newHead == _food) {
          _generateFood();
        } else {
          _snake.removeLast();
        }
      }
    });
  }

  bool _isCollision(Offset position) {
    if (position.dx < 0 ||
        position.dx >= _columns ||
        position.dy < 0 ||
        position.dy >= _rows ||
        _snake.contains(position)) {
      return true;
    }
    return false;
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', // Test ad unit ID
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('Rewarded ad loaded.');
          setState(() {
            _rewardedAd = ad;
            _isAdLoaded = true;
          });
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (RewardedAd ad) {
              print('Rewarded ad dismissed.');
              ad.dispose();
              _loadRewardedAd(); // Load a new ad when one is dismissed
            },
            onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
              print('Failed to show rewarded ad: $error');
              ad.dispose();
              _loadRewardedAd(); // Load a new ad when one fails to show
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Rewarded ad failed to load: $error');
          _isAdLoaded = false;
        },
      ),
    );
  }

  void _showRewardedAd() {
    if (_isButtonEnabled) {
      if (_isAdLoaded && _rewardedAd != null) {
        _rewardedAd!.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
            print('User earned reward: ${reward.amount} ${reward.type}');
            setState(() {});
          },
        );
        _rewardedAd = null;
        _isAdLoaded = false;
      } else {
        // Optionally, inform the user or set up a retry mechanism
      }
    } else {}
  }

  void _gameOver() {
    _showRewardedAd();
    _timer?.cancel();
    _isGameOver = true;
    _isPlaying = false;
    dynamic point = _snake.length - 1;
    if (point < 30) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Sorry'),
          content: Text('Not Enough Point For Get Balance '),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        ),
      );
    }
    if (point > 30) {
      operation.updateBlance(0.15);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Balance Added'),
          content: Text('you Get 0.15 Tk on Balance'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        ),
      );
    }
    if (point > 50) {
      operation.updateBlance(0.25);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Balance Added'),
          content: Text('you Get 0.25 Tk on Balance'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        ),
      );
    }
    if (point > 100) {
      operation.updateBlance(0.50);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Balance Added'),
          content: Text('you Get 0.50 Tk on Balance'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        ),
      );
    }
    if (point > 200) {
      operation.updateBlance(0.75);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Balance Added'),
          content: Text('you Get 0.75 Tk on Balance'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        ),
      );
    }
    if (point > 500) {
      operation.updateBlance(1.00);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Balance Added'),
          content: Text('you Get 1.00 Tk on Balance'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        ),
      );
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Game Over'),
        content: Text('Your score: ${_snake.length - 1}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();

              //  _startGame();
            },
            child: Text('Back'),
          ),
        ],
      ),
    );
    _showRewardedAd();
  }

  void _changeDirection(String newDirection) {
    if (_isGameOver || !_isPlaying) return;

    if ((_direction == 'up' && newDirection != 'down') ||
        (_direction == 'down' && newDirection != 'up') ||
        (_direction == 'left' && newDirection != 'right') ||
        (_direction == 'right' && newDirection != 'left')) {
      setState(() {
        _direction = newDirection;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Score: ${_snake.length - 1}',
            style: TextStyle(fontSize: 24),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.delta.dy > 0) {
                _changeDirection('down');
              } else if (details.delta.dy < 0) {
                _changeDirection('up');
              }
            },
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx > 0) {
                _changeDirection('right');
              } else if (details.delta.dx < 0) {
                _changeDirection('left');
              }
            },
            child: AspectRatio(
              aspectRatio: _columns / (_rows + 2),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _columns,
                ),
                itemCount: _columns * _rows,
                itemBuilder: (context, index) {
                  final x = index % _columns;
                  final y = (index / _columns).floor();

                  final isSnakeBody =
                      _snake.contains(Offset(x.toDouble(), y.toDouble()));
                  final isFood = _food == Offset(x.toDouble(), y.toDouble());

                  return Container(
                    margin: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: isSnakeBody
                          ? Colors.green
                          : isFood
                              ? Colors.red
                              : Colors.grey[800],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _changeDirection('up'),
                    child: Icon(Icons.arrow_upward),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => _changeDirection('left'),
                        child: Icon(Icons.arrow_back),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => _changeDirection('right'),
                        child: Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => _changeDirection('down'),
                    child: Icon(Icons.arrow_downward),
                  ),
                ],
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: _showInstructions,
          child: Text("Click To Play"),
        )
      ],
    );
  }
}
