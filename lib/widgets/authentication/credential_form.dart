import 'package:chat_app_firebase/widgets/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebaseAuth = FirebaseAuth.instance;

class CredentialForm extends StatefulWidget {
  const CredentialForm({super.key});

  @override
  State<CredentialForm> createState() => _CredentialFormState();
}

class _CredentialFormState extends State<CredentialForm> {
  final _form = GlobalKey<FormState>();

  bool _isLogin = true;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  String _email = "";
  String _password = "";

  void togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void toggleFormState() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _setLoadingState(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  void _onSubmit() async {
    if(_isLoading) {
      return;
    }
    _setLoadingState(true);
    final isValid = _form.currentState!.validate();

    if(!isValid) {
      return;
    }

    _form.currentState!.save();


    try {
      UserCredential userCredential;
      if(_isLogin) {
        userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: _email, password: _password);
      }
      else {
        userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: _email, password: _password);
      }
    }
    on FirebaseAuthException catch(error) {
      String message = "Authentication Failed";

      switch(error.code) {
        case 'user-not-found':
        case 'invalid-credential':
        case 'wrong-password':
          message = 'Invalid E-Mail or Password';
          break;
        case 'email-already-in-use':
          message = 'E-Mail Already in use';
          break;
      }

      if(context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    }
    finally {
      _setLoadingState(false);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/chat.png", width: 150,),
          const SizedBox(height: 8,),
          Card(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    Text("Welcome!", style: Theme.of(context).textTheme.titleLarge,),
                    const SizedBox(height: 8,),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        label: Text("E-Mail"),
                        suffixIcon: Icon(Icons.email),
                        helperText: ""
                      ),
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        if(value == null || value.trim().isEmpty || !value.contains("@")) {
                          return "Please Enter Valid E-Mail address";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                    ),
                    const SizedBox(height: 8,),
                    TextFormField(
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        label: const Text("Password"),
                        suffixIcon: IconButton(onPressed: togglePasswordVisibility, icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility)),
                        helperText: ""
                      ),
                      validator: (value) {
                        if (value == null || value.trim().length < 6) {
                          return 'Password must be at least 6 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                    ),
                    const SizedBox(height: 8,),
                    ElevatedButton(
                      onPressed: _onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.onSecondary
                      ), 
                      child: _isLoading ? const Loader() : Text(_isLogin ? "Login" : "Signup"),
                    ),
                    // const SizedBox(height: 8,),
                    TextButton(onPressed: toggleFormState, child: Text(_isLogin ? "Don't have an account? signup" : "Already have an account? Login"))
                  ],
                ),
              )
            ),
          ),
        ]
      ),
    );
  }
}
