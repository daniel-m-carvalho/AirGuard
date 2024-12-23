import 'package:air_guard/view_ models/auth_view_model.dart';
import 'package:air_guard/views/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  void showErrorToast(String? message) {
    if (message != null && message.isNotEmpty) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 211, 17, 17),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: NavBar(
        // Bold Text with on pressed function
        mainItem: TextButton.icon(
          onPressed: () {
            // Navigate to home view
          },
          icon: const Icon(Icons.shield, color: Colors.black),
          label: const Text(
            'AirGuard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        additionalItems: [
          if (authViewModel.isLoggedIn) ...[
            TextButton.icon(
              onPressed: () {
                authViewModel.navigateToSearch(context);
              },
              icon: const Icon(Icons.search, color: Colors.black),
              label: const Text('Search Air Quality',
                  style: TextStyle(color: Colors.black)),
            ),
            TextButton.icon(
              onPressed: () {
                authViewModel.logout();
                showErrorToast(authViewModel.errorMessage);
              },
              icon: const Icon(Icons.logout_outlined, color: Colors.black),
              label:
                  const Text('Logout', style: TextStyle(color: Colors.black)),
            ),
          ] else
            TextButton.icon(
              onPressed: () {
                _showLoginDialog(context, authViewModel);
              },
              icon: const Icon(Icons.person, color: Colors.black),
              label: const Text('Login', style: TextStyle(color: Colors.black)),
            ),
        ],
      ),
      body: Container(
        decoration:
            BoxDecoration(color: const Color.fromARGB(255, 122, 135, 230)),
        child: Column(
          children: [
            if (authViewModel.isLoggedIn)
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Image.asset('assets/hello.gif', width: 150, height: 150),
                ),
              ),
            SizedBox(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: authViewModel.isLoggedIn
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Welcome to AirGuard',
                              style: const TextStyle(
                                  fontSize: 50, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            Text('Hello, ${authViewModel.user?.name}!',
                                style: const TextStyle(fontSize: 25)),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Welcome to AirGuard',
                              style: TextStyle(
                                  fontSize: 50, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            const Text('Login to continue',
                                style: TextStyle(fontSize: 25)),
                          ],
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLoginDialog(BuildContext context, AuthViewModel authViewModel) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    bool showPassword = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Login'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                      ),
                    ),
                    obscureText: !showPassword,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      _showRegisterDialog(context, authViewModel);
                    },
                    child: const Text(
                      "Don't have an account? Register",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    authViewModel.login(
                        usernameController.text, passwordController.text);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Login'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showRegisterDialog(BuildContext context, AuthViewModel authViewModel) {
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    bool isProfessional = false;
    bool showPassword = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Register'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                      ),
                    ),
                    obscureText: !showPassword,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isProfessional,
                        onChanged: (bool? value) {
                          setState(() {
                            isProfessional = value ?? false;
                          });
                        },
                      ),
                      const Text('Register as Professional'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      _showLoginDialog(context, authViewModel);
                    },
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    authViewModel.register(
                      usernameController.text,
                      emailController.text,
                      passwordController.text,
                      isProfessional ? 'professional' : 'citizen',
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Register'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
