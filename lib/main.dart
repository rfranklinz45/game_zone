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

class AppUser {
  String name = '';
  String pass = '';
  int hlScore = 0;
  int flipitScore = 0;
  int TTTScore = 0;

  AppUser(String n, String p, [int hl = 0, int f = 0, int t = 0]) {
    name = n;
    pass = p;
    hlScore = hl;
    flipitScore = f;
    TTTScore = t;
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
  AppUser robert = AppUser("Robert", "letmein");
  AppUser admin = AppUser("admin", "login");
  AppUser gamer = AppUser("Gamer", "password", 100, 100, 100);
  late List<AppUser> accounts = [robert, admin, gamer];

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
              const SizedBox(height: 10),
              //login button updates the username and password entries
              //for now, does not perform authentication, just moves to the next screen
              MaterialButton(
                onPressed: () {
                  bool validated = false;
                  for (int i = 0; i < accounts.length; i++) {
                    if (_usernameController.text == accounts[i].name &&
                        _passwordController.text == accounts[i].pass) {
                      validated = true;
                    }
                  }
                  if (validated) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  }
                },
                color: Colors.red,
                child: const Text('Login'),
              ),
              const SizedBox(height: 30),
              //new users button creates a new account
              MaterialButton(
                color: Colors.white,
                onPressed: () {
                  accounts.add(AppUser(
                      _usernameController.text, _passwordController.text));
                },
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
              const SizedBox(height: 10),
              MaterialButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HighLowPage()));
                },
                color: Colors.purple,
                child: const Text('High Low'),
              ),
              const SizedBox(height: 10),
              MaterialButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FlipItPage()));
                },
                color: Colors.purple,
                child: const Text('Flip It!'),
              ),
              const SizedBox(height: 10),

              //user scores button
              // MaterialButton(
              //   onPressed: () {
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => Placeholder()));
              //   },
              //   color: Colors.blue,
              //   child: const Text('View your scores'),
              // ),
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
  List<String> tttGrid = ['', '', '', '', '', '', '', '', ''];
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
        if (!winState && tttBoxes < 9) {
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
    } else if (tttGrid[3] == tttGrid[4] &&
        tttGrid[4] == tttGrid[5] &&
        tttGrid[5] != '') {
      _awardWin(tttGrid[3]);
    } else if (tttGrid[6] == tttGrid[7] &&
        tttGrid[7] == tttGrid[8] &&
        tttGrid[8] != '') {
      _awardWin(tttGrid[6]);
    } else if (tttGrid[0] == tttGrid[3] &&
        tttGrid[3] == tttGrid[6] &&
        tttGrid[6] != '') {
      _awardWin(tttGrid[0]);
    } else if (tttGrid[1] == tttGrid[4] &&
        tttGrid[4] == tttGrid[7] &&
        tttGrid[7] != '') {
      _awardWin(tttGrid[1]);
    } else if (tttGrid[2] == tttGrid[5] &&
        tttGrid[5] == tttGrid[8] &&
        tttGrid[8] != '') {
      _awardWin(tttGrid[2]);
    } else if (tttGrid[0] == tttGrid[4] &&
        tttGrid[4] == tttGrid[8] &&
        tttGrid[8] != '') {
      _awardWin(tttGrid[0]);
    } else if (tttGrid[2] == tttGrid[4] &&
        tttGrid[4] == tttGrid[6] &&
        tttGrid[6] != '') {
      _awardWin(tttGrid[2]);
    } else if (tttBoxes == 9) {
      print("game was a draw!");
      winState = true;
      _clearGrid();
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
  var hlWins = 0;
  bool roll = false;
  var die = 4;

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
              Text("Wins: $hlWins",
                  style: const TextStyle(
                    color: Colors.purple,
                    fontSize: 20,
                  )),
              const Text("4, 5, and 6 WIN!",
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 30,
                  )),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Image.asset('media/graphics/die$die.png'),
              ),
              MaterialButton(
                onPressed: () {
                  if (roll == false) {
                    setState(() {
                      //rollDie(1);
                      die = Random().nextInt(6) + 1;
                      if (die > 3) {
                        hlWins++;
                      }
                    });
                  }
                },
                color: Colors.amber,
                child: const Text('Roll The Die!'),
              ),
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
