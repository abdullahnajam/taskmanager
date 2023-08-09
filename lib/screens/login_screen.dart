import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:taskmanager/screens/subscribe_screen.dart';

import 'navigators/bottom_nav.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30,),
            Image.asset('assets/images/icon-round.png',height: 100,),
            const SizedBox(height: 20,),
            const Text('Task Manager',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: ()async{
                      /*final LoginResult loginResult = await FacebookAuth.instance.login(permissions: ['email', 'public_profile']);
                      print('login status ${loginResult.status}');
                      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

                      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential).then((value){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Subscribe()));

                      }).onError((error, stackTrace){
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.error,
                          text: error.toString(),
                        );
                      });*/
                    },
                    child: Card(
                      margin: const EdgeInsets.fromLTRB(20,20,20,0),
                      elevation: 2,
                      color: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Container(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/fb.png',height: 30,),
                            const SizedBox(width: 10,),
                            const Text('Sign In With Facebook',style: TextStyle(color: Colors.white,fontSize: 17),)
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: ()async{
                      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
                      GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

                      final credential =GoogleAuthProvider.credential(
                        accessToken: googleAuth.accessToken,
                        idToken: googleAuth.idToken,
                      );

                      await FirebaseAuth.instance.signInWithCredential(credential).then((value){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Subscribe()));

                      }).onError((error, stackTrace){
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.error,
                          text: error.toString(),
                        );
                      });

                    },
                    child: Card(
                      margin: const EdgeInsets.fromLTRB(20,20,20,0),
                      shape: RoundedRectangleBorder(
                        borderRadius:  BorderRadius.circular(7),
                      ),
                      elevation: 2,
                      child: Container(

                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/google.png',height: 30,),
                            const SizedBox(width: 10,),
                            const Text('Sign In With Google',style: TextStyle(color: Colors.grey,fontSize: 17),)
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: ()async{
                      final appleProvider = AppleAuthProvider();


                      await FirebaseAuth.instance.signInWithProvider(appleProvider).then((value){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Subscribe()));

                      }).onError((error, stackTrace){
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.error,
                          text: error.toString(),
                        );
                      });


                    },
                    child: Card(
                      margin: const EdgeInsets.fromLTRB(20,20,20,0),
                      shape: RoundedRectangleBorder(
                        borderRadius:  BorderRadius.circular(7),
                      ),
                      elevation: 2,
                      child: Container(

                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/apple.png',height: 30,),
                            const SizedBox(width: 10,),
                            const Text('Sign In With Apple',style: TextStyle(color: Colors.white,fontSize: 17),)
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: ()async{
                      try {
                        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
                        print('Login succeeds. ${token.accessToken}');
                      } catch (e) {
                        print('Login fails. $e');
                      }
                    },
                    child: Card(
                      margin: const EdgeInsets.fromLTRB(20,20,20,0),
                      shape: RoundedRectangleBorder(
                        borderRadius:  BorderRadius.circular(7),
                      ),
                      elevation: 2,
                      child: Container(

                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/kakao.png',height: 30,),
                            const SizedBox(width: 10,),
                            const Text('Sign In With Kakao',style: TextStyle(color: Colors.black,fontSize: 17),)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: InkWell(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Subscribe()));

                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Start Without Login',style: TextStyle(fontSize: 17),),
                    SizedBox(width: 10,),
                    Icon(Icons.arrow_forward,size: 25,)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}
