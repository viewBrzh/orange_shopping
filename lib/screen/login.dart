import 'package:flutter/material.dart';
import 'package:orange_shopping/assets/dataKeeper.dart';
import 'package:orange_shopping/screen/homeScreen.dart';
import 'package:orange_shopping/assets/user.dart';
import 'package:orange_shopping/assets/apiUrl.dart';
import 'dart:convert';
import 'sign_up.dart';
import 'change_pass.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  List<User> usersList = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

    @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> getCurrentUser(String username) async {
    for (int i = 0; i < usersList.length; i++) {
      if (usersList[i].username == username){
        currentUser = usersList[i];
      }
    }
  }

  Future<void> fetchUsers() async {
    try {
      final userResponse = await http.get(Uri.parse('${apiUrl}users'));

      if (userResponse.statusCode == 200 ) {
        final List<dynamic> usersData = json.decode(userResponse.body);

        List<User> users = usersData.map((item) => User.fromJson(item)).toList();

        setState(() {
          usersList = users;
        });
      } else {
        throw Exception('Failed to fetch users');
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
  }


  Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('${apiUrl}login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final token = json.decode(response.body)['token'];
      getCurrentUser(username);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text('Invalid username or password. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
  }
  Future<void> checkUsernameExists(String username, String password) async {
    final response = await http.post(
      Uri.parse('${apiUrl}login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final token = json.decode(response.body)['token'];
      getCurrentUser(username);
      int usId = currentUser.id;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangePassScreen(currentUserId: usId),
        ),
      );
    } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text('Invalid username or password. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(
          color: Color(0xFFE5750E), // Color for the text (229, 117, 14)
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Center( // Wrap the Image widget with Center
              child: Image(
                image: AssetImage('lib/images/logo.png'),
                width: 200, // Set the width to 100 pixels (adjust as needed)
                height: 200, // Set the height to 100 pixels (adjust as needed)
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Sign in',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  labelText: 'User Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  labelText: 'Password',
                ),
              ),
            ),
            
            TextButton(
              onPressed: () {
                final String username = nameController.text;
                final String password = passwordController.text;

                // Check if the username exists
                checkUsernameExists(username, password);

              },
              child: const Text('Change Password'),
            ),
            Center(
              
              child: ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(90, 50)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0), // Adjust the radius as needed
                    ),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Color(0xFFE5750E), // Color for the text (229, 117, 14)
                  ),
                ),
                
                onPressed: () {
                  final String username = nameController.text;
                  final String password = passwordController.text;
                  login(username, password); // Call the login function
                },
              ),
            ),
            Row(
              children: <Widget>[
                const Text('Does not have an account?'),
                TextButton(
                  child: const Text(
                    'Sign up',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    //signup screen
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUp(),
                    )
                    );
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
        ),
      ),
    );
  }
}
