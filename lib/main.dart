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
                      MaterialPageRoute(builder: (context) => Placeholder()));
                },
                color: Colors.purple,
                child: const Text('Tic Tac Toe'),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Placeholder()));
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
