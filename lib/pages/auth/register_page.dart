

import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  bool _isLoading=false;
  AuthService authService= AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(backgroundColor: Theme.of(context).primaryColor),
      body: _isLoading  ? Center(child: CircularProgressIndicator(color:Theme.of(context)
          .primaryColor,),):
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Groupie",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Create your account now to chat and explore",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Image.asset("assets/logiin.jpg"),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      labelText: "Fullname",
                      prefixIcon: Icon(
                        Icons.account_circle,
                        color: Theme.of(context).primaryColor,
                      )),
                  onChanged: (value) {
                    setState(() {
                      fullName = value;
                    });
                  },
                  validator: (value) {
                    if(value!.isNotEmpty){
                      return null;
                    }
                    else{
                      return "Name cannot be empty";
                    }
                  },
                ),
                const SizedBox(height: 15,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      labelText: "Email",
                      prefixIcon: Icon(
                        Icons.email,
                        color: Theme.of(context).primaryColor,
                      )),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  validator: (value) {
                    return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value!)
                        ? null
                        : "Please enter a valid  email";
                  },
                ),


                const SizedBox(height: 15),
                TextFormField(
                    obscureText: true,
                    decoration: textInputDecoration.copyWith(
                        labelText: "Password",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).primaryColor,
                        )),
                    validator: (value) {
                      if (value!.length < 6) {
                        return "Password must be at least 6 character";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    }),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      register();
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text.rich(TextSpan(
                  text: "Already have an account? ",
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  children: <TextSpan>[
                    TextSpan(
                        text: "Login now",
                        style: const TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            nextScreen(context, const LoginPage());
                          }),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  register() async{
    if(formKey.currentState!.validate()){
      setState(() {
        _isLoading=true;
      });
      await authService.registerUserWithEmailandPassword(
          fullName, email, password).then((value) async{
            if(value==true){
              //saving the shared preference state
              await HelperFunctions.saveUserLoggedInStatus(true);
              await HelperFunctions.saveUserEmailSF(email);
              await HelperFunctions.saveUserNameSF(fullName);
              nextScreenReplace(context, const HomePage());
              

            }
            else{
              showSnackbar(context, Colors.red, value);
              setState(() {
                _isLoading=false;
              });
            }
      });
    }
  }
}
