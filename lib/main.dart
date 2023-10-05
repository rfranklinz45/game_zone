import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();

  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30),
              const Text('The Game Zone',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 10),
              //username entry field
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                  hintText: 'my username',
                  icon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 10),
              //password entry field (obscured)
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'my password',
                  icon: Icon(Icons.lock),
                ),
              ),
              //login button updates the username and password entries
              //for now, does not perform authentication, just moves to the next screen
              MaterialButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                color: Colors.red,
                child: const Text('Login'),
              ),
              const SizedBox(height: 30),
              //new users button (does nothing currently)
              MaterialButton(
                color: Colors.white,
                onPressed: () {},
                child: const Text('Create account'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Center(child: Text("The Game Zone")),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              //game selection buttons
              MaterialButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TTTPage()));
                },
                color: Colors.purple,
                child: const Text('Tic Tac Toe'),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HighLowPage()));
                },
                color: Colors.purple,
                child: const Text('High Low'),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FlipItPage()));
                },
                color: Colors.purple,
                child: const Text('Flip It!'),
              ),

              //user scores button
              MaterialButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Placeholder()));
                },
                color: Colors.blue,
                child: const Text('View your scores'),
              ),
              //logout button returns to login screen
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                color: Colors.red,
                child: const Text('Logout'),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class TTTPage extends StatefulWidget {
  TTTPage({super.key});

  @override
  State<TTTPage> createState() => _TTTPageState();
}

class _TTTPageState extends State<TTTPage> {
  //2d array to hold the Xs and Os
  List<String> tttGrid = ['0', '1', '2', '3', '4', '5', '6', '7', '8'];
  //how many of the boxes have been filled also used to determine X or Os turn
  var tttBoxes = 0;
  //games won by player
  var tttWins = 0;
  //which symbol is player using?
  String playerSymbol = 'X';
  //has the game been won?
  bool winState = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Center(child: Text("Tic Tac Toe")),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text("Wins: $tttWins",
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontSize: 20,
                  )),
              //board clearing button for testing purposes ONLY
              MaterialButton(
                onPressed: () {
                  _clearGrid();
                },
                color: Colors.red,
                child: const Text('Clear Board'),
              ),
              Expanded(
                child: GridView.builder(
                    itemCount: 9,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          _squarePressed(index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.purple)),
                          child: Center(
                            child: Text(
                              tttGrid[index],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 50),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _squarePressed(int index) {
    setState(() {
      if (tttGrid[index] == '') {
        if (tttBoxes % 2 == 0) {
          tttGrid[index] = 'X';
          tttBoxes++;
        } else if (tttBoxes % 2 == 1) {
          tttGrid[index] = 'O';
          tttBoxes++;
        }
        _tttWinCheck();

        //after user moves, if the game hasn't been won already, computer gets to pick a random unfilled square next
        if (!winState) {
          while (tttGrid[index] != '') {
            index = Random().nextInt(9);
          }
          if (tttBoxes % 2 == 0) {
            tttGrid[index] = 'X';
            tttBoxes++;
          } else if (tttBoxes % 2 == 1) {
            tttGrid[index] = 'O';
            tttBoxes++;
          }
          _tttWinCheck();
        }
        winState = false;
      }
    });
  }

  //checks for a win after each square gets filled
  void _tttWinCheck() {
    if (tttGrid[0] == tttGrid[1] &&
        tttGrid[1] == tttGrid[2] &&
        tttGrid[2] != '') {
      _awardWin(tttGrid[0]);
    }
    if (tttGrid[3] == tttGrid[4] &&
        tttGrid[4] == tttGrid[5] &&
        tttGrid[5] != '') {
      _awardWin(tttGrid[3]);
    }
    if (tttGrid[6] == tttGrid[7] &&
        tttGrid[7] == tttGrid[8] &&
        tttGrid[8] != '') {
      _awardWin(tttGrid[6]);
    }
    if (tttGrid[0] == tttGrid[3] &&
        tttGrid[3] == tttGrid[6] &&
        tttGrid[6] != '') {
      _awardWin(tttGrid[0]);
    }
    if (tttGrid[1] == tttGrid[4] &&
        tttGrid[4] == tttGrid[7] &&
        tttGrid[7] != '') {
      _awardWin(tttGrid[1]);
    }
    if (tttGrid[2] == tttGrid[5] &&
        tttGrid[5] == tttGrid[8] &&
        tttGrid[8] != '') {
      _awardWin(tttGrid[2]);
    }
    if (tttGrid[0] == tttGrid[4] &&
        tttGrid[4] == tttGrid[8] &&
        tttGrid[8] != '') {
      _awardWin(tttGrid[0]);
    }
    if (tttGrid[2] == tttGrid[4] &&
        tttGrid[4] == tttGrid[6] &&
        tttGrid[6] != '') {
      _awardWin(tttGrid[2]);
    }
  }

  void _awardWin(String winningPlayer) {
    print("$winningPlayer won the game!");
    if (winningPlayer == playerSymbol) {
      tttWins++;
    }
    winState = true;
    _clearGrid();
  }

  //clears the grid of all entries
  void _clearGrid() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        tttGrid[i] = '';
      }
    });

    tttBoxes = 0;
  }
}

class HighLowPage extends StatefulWidget {
  HighLowPage({super.key});

  @override
  State<HighLowPage> createState() => _HighLowPageState();
}

class _HighLowPageState extends State<HighLowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Center(child: Text("High Low")),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text("welcome to High Low"),
            ],
          ),
        ),
      ),
    );
  }
}

class FlipItPage extends StatefulWidget {
  FlipItPage({super.key});

  @override
  State<FlipItPage> createState() => _FlipItPageState();
}

class _FlipItPageState extends State<FlipItPage> {
  bool showHeads = false;
  bool showTails = false;
  bool flipping = false;
  bool win = false;
  bool lose = false;
  var score = 0;
  var flip = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Center(child: Text("Flip It!")),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text("Wins: $score",
                  style: const TextStyle(
                    color: Colors.purple,
                    fontSize: 20,
                  )),
              Image.asset('media/graphics/flipit.png'),
              //heads or tails buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: () {
                      if (flipping == false) {
                        setState(() {
                          flipCoin(0);
                        });
                      }
                    },
                    color: Colors.green,
                    child: const Text('HEADS'),
                  ),
                  //heads or tails buttons
                  MaterialButton(
                    onPressed: () {
                      if (flipping == false) {
                        setState(() {
                          flipCoin(1);
                        });
                      }
                    },
                    color: Colors.amber,
                    child: const Text('TAILS'),
                  ),
                ],
              ),
              flipping
                  ? Image.asset('media/graphics/coin.gif')
                  : showHeads
                      ? Image.asset('media/graphics/heads.png')
                      : showTails
                          ? Image.asset('media/graphics/tails.png')
                          : const SizedBox(height: 0),
              win
                  ? const Text('You called it!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ))
                  : lose
                      ? const Text('Whoops...',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ))
                      : const SizedBox(height: 0),
            ],
          ),
        ),
      ),
    );
  }

  void flipCoin(int called) {
    flipping = true;
    showHeads = false;
    showTails = false;
    win = false;
    lose = false;
    Timer(const Duration(seconds: 1), () {
      setState(() {
        flipping = false;
        flip = Random().nextInt(2);
        if (flip == 0) {
          showHeads = true;
          showTails = false;
        } else {
          showTails = true;
          showHeads = false;
        }
        if (flip == called) {
          win = true;
          score++;
        } else {
          lose = true;
        }
      });
    });
  }
}
