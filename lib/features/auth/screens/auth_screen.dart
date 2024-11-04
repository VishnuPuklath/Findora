import 'package:alak/common/widgets/custom_button.dart';
import 'package:alak/common/widgets/custom_textfield.dart';
import 'package:alak/constants/global_variables.dart';
import 'package:alak/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';

enum Auth { signin, signup }

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  Auth _auth = Auth.signup;
  final _signUpKey = GlobalKey<FormState>();
  final _signInKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  void signUp() {
    authService.signupUser(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        context: context);
  }

  void signIn() {
    authService.signin(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundCOlor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              'Welcome to Findora',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            ListTile(
              tileColor: _auth == Auth.signup
                  ? GlobalVariables.backgroundColor
                  : GlobalVariables.greyBackgroundCOlor,
              title: const Text(
                'Create Account',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Radio(
                  activeColor: GlobalVariables.secondaryColor,
                  value: Auth.signup,
                  groupValue: _auth,
                  onChanged: (value) {
                    setState(() {
                      _auth = value!;
                    });
                  }),
            ),
            if (_auth == Auth.signup)
              Container(
                color: GlobalVariables.backgroundColor,
                padding: const EdgeInsets.all(8),
                child: Form(
                    key: _signUpKey,
                    child: Column(
                      children: [
                        CustomTextfield(
                          hintText: 'Name',
                          controller: _nameController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextfield(
                          hintText: 'Email',
                          controller: _emailController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextfield(
                          hintText: 'Password',
                          controller: _passwordController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomButton(
                            text: 'SignUp',
                            onTap: () {
                              if (_signUpKey.currentState!.validate()) {
                                signUp();
                              }
                            })
                      ],
                    )),
              ),
            ListTile(
              tileColor: _auth == Auth.signin
                  ? GlobalVariables.backgroundColor
                  : GlobalVariables.greyBackgroundCOlor,
              title: const Text(
                'Sign-In ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Radio(
                  activeColor: GlobalVariables.secondaryColor,
                  value: Auth.signin,
                  groupValue: _auth,
                  onChanged: (value) {
                    setState(() {
                      _auth = value!;
                    });
                  }),
            ),
            if (_auth == Auth.signin)
              Container(
                color: GlobalVariables.backgroundColor,
                padding: const EdgeInsets.all(8),
                child: Form(
                    key: _signInKey,
                    child: Column(
                      children: [
                        CustomTextfield(
                          hintText: 'Email',
                          controller: _emailController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextfield(
                          hintText: 'Password',
                          controller: _passwordController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomButton(
                            text: 'SignIn',
                            onTap: () {
                              signIn();
                            })
                      ],
                    )),
              ),
          ],
        ),
      ),
    ));
  }
}
