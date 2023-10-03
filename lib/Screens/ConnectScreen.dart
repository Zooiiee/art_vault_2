import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'LoginScreen.dart';

class ConnectScreen extends StatelessWidget {
  const ConnectScreen({Key?key}):super(key:key);

  @override
  Widget build(BuildContext context){
    var height= MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color(0xFFEAD2A8),
        body:Container(

          child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image:  AssetImage('assets/hands.jpeg'),
                    fit: BoxFit.cover,
                  )
              ) ,

              padding: EdgeInsets.all(30),
              child:Column(

                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:[
                    Lottie.asset(
                      'assets/painting.json',
                      height: 270.0,
                      repeat: true,
                      reverse: false,
                      animate: true,
                    ),
                    SizedBox(
                      height: 120,
                    ),
                    Column(

                      children:[
                        Text("Connect with Art",style:TextStyle(fontSize: 42,color: const Color(0xFF52412E),fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Sign Up or Login to Dive into the World of ArtVault",style:TextStyle(fontSize: 20,color: const Color(0xFF52412E)),textAlign: TextAlign.center,),],
                    ),//Be inspired every day with art you'll love


                    SizedBox(
                      height: 1,
                    ),
                    Row(
                      children: [
                        Expanded(child: ElevatedButton(
                            onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context)=> AuthScreen(isSignUp: false)));
                               },
                            child: Text("LOGIN",style: TextStyle(fontSize: 17),),
                            style:ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(),
                              side: BorderSide(color:Colors.black),
                              backgroundColor:  const Color(0xFF52412E),
                              foregroundColor: const Color(0xFFEAD2A8),
                              padding: EdgeInsets.symmetric(vertical: 15),
                            )
                        )),
                        const SizedBox(width:10),
                        Expanded(child:ElevatedButton(
                              onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context)=> AuthScreen(isSignUp: true)));
                              },
                            child: Text("SIGN UP",style: TextStyle(fontSize: 17),),
                            style:ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(),
                              side: BorderSide(color:Colors.black),
                              backgroundColor:  const Color(0xFFEAD2A8),
                              foregroundColor: const Color(0xFF52412E),
                              padding: EdgeInsets.symmetric(vertical: 15),
                            )
                        )),

                      ],
                    )

                  ]
              )
          ),
        )
    );

  }
}