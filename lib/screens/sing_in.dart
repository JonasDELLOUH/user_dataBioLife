import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:particles_flutter/particles_flutter.dart';
import 'package:user_data/screens/sing_up.dart';

import '../models/member.dart';
import '../services/auth.dart';
import '../services/database.dart';
import '../widgets/widgets.dart';
import 'home_screen.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();

  late String email, password;
  bool _isLoading = false;

  final authInstance = FirebaseAuth.instance;

  AuthService authService = AuthService();
  DatabaseService databaseService = DatabaseService();
  late MemberModel memberModel;

  signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      authService.signInWithEmailAndPassword(email, password).then((value) {
        memberModel = MemberModel(value.memberUid);
        _isLoading = false;
        databaseService.addMember(memberModel.memberUid);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      memberKey: memberModel.memberUid,
                    )));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                Center(
                  child: Container(
                    key: UniqueKey(),
                    child: Center(
                      child: CircularParticle(
                        // key: UniqueKey(),
                        awayRadius: 80,
                        numberOfParticles: 200,
                        speedOfParticles: 1,
                        height: screenHeight,
                        width: screenWidth,
                        onTapAnimation: true,
                        particleColor: Colors.white.withAlpha(150),
                        awayAnimationDuration: Duration(milliseconds: 600),
                        maxParticleSize: 8,
                        isRandSize: true,
                        isRandomColor: true,
                        randColorList: [
                          Colors.red.withAlpha(210),
                          Colors.white.withAlpha(210),
                          Colors.yellow.withAlpha(210),
                          Colors.green.withAlpha(210)
                        ],
                        awayAnimationCurve: Curves.easeInOutBack,
                        enableHover: true,
                        hoverColor: Colors.white,
                        hoverRadius: 90,
                        connectDots: true, //not recommended
                      ),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const Spacer(),
                        TextFormField(
                          validator: (val) {
                            return val!.isEmpty
                                ? "Veuillez entrer votre mail"
                                : null;
                          },
                          decoration: const InputDecoration(hintText: "Email"),
                          onChanged: (val) {
                            email = val;
                          },
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        TextFormField(
                          obscureText: true,
                          validator: (val) {
                            return val!.isEmpty
                                ? "Veuillez entrer votre mot de passe"
                                : null;
                          },
                          decoration:
                              const InputDecoration(hintText: "Mot de passe"),
                          onChanged: (val) {
                            password = val;
                          },
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        GestureDetector(
                          onTap: () {
                            signIn();
                          },
                          child: blueButton(
                              context: context, label: "Se Connecter"),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Vous n'avez pas de compte?  ",
                              style: TextStyle(fontSize: 15.5),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignUp()));
                                },
                                child: const Text("S'inscrire",
                                    style: TextStyle(
                                        fontSize: 15.5,
                                        decoration: TextDecoration.underline)))
                          ],
                        ),
                        const SizedBox(
                          height: 80,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
