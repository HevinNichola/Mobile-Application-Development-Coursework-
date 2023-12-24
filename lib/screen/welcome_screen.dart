import 'home_page.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(2.0),
          decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const SizedBox(height:90),

                  Image.asset('assets/images/logo.png',
                  width: 170.0,
                  height:170.0,
                  fit: BoxFit.cover
                  ),

                  const SizedBox(height:15),

                   const Text(
                    "Contact Buddy",
                     style: TextStyle(
                       fontWeight: FontWeight.bold,
                       fontSize: 34,
                       color:Color(0xFF000B99),
                     ),
                  ),
                  const SizedBox(height:6),

                  const Text(
                    "Manage Your Contacts Quickly and Easily!",
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color:Colors.black87,

                    ),
                  ),
                  const SizedBox(height:50.0),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF001b43),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      minimumSize: const Size(220, 62
                      ),
                    ),

                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        color: Colors.white,
                          fontWeight: FontWeight.bold,
                         fontSize: 21,
                      ),

                    ),
                  ),
                ],

              )
            ],
          ),

        ),
      );
  }
}
