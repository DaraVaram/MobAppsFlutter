import 'package:flutter/material.dart';
import './musiclibrary.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});


  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String username = '';
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose(){
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
          const Text(
            'Login Screen',
          ),
      ),
      body: Center(
        child: _buildLoginForm(),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child:
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Enter your username...',
                ),
                validator: (text) => text!.isEmpty ? 'Enter a username' : null,


              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Enter your Email...'
                ),
                validator: (text) {
                  if (text!.isEmpty) {
                    return 'Enter a valid email.'; //shows underneath
                  }
                  final regex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
                  if (!regex.hasMatch(text)) {
                    return 'Enter a valid email';//shows underneath
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Enter your password...",
                ),
                validator: (text) {
                  if (text!.isEmpty || text != 'password123') {
                    return 'Enter a valid password'; //shows underneath
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                  onPressed: _validate,
                  child: const Text(
                    'Log in',
                  )
              )
            ],
          ),
        )
    );
  }

  void _validate()
  {
    final form = _formKey.currentState;
    if(form?.validate() == false){
      return;
    }

    final username = _usernameController.text;
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => Library(username: username))
    );

  }
}

