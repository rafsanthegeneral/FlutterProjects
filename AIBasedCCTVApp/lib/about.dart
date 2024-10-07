import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 255, 253, 253),
      ),
      backgroundColor: Color.fromARGB(255, 255, 253, 253),
      body: Container(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 60),
              child: ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, Colors.transparent],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                blendMode: BlendMode.dstIn,
                child: Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Image.asset(
                    'images/cctv.png',
                    height: 400,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.55),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Hello I am',
                    style: TextStyle(
                        color: Color.fromARGB(255, 17, 16, 16), fontSize: 30),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Groupe No 3',
                      style: TextStyle(
                          color: Color.fromARGB(255, 17, 16, 16),
                          fontSize: 40)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Development Our Project',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Valo Basa '),
                              content: Text('Onek Valo basa Sir Apner Jonno '),
                            );
                          },
                        );
                      },
                      child: Text('Like Us Project'),
                      style: TextButton.styleFrom(
                        foregroundColor: Color.fromARGB(255, 235, 230, 230), backgroundColor:
                            Color.fromARGB(255, 8, 8, 8), // Background Color
                      ),
                    ),
                    width: 120,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            FontAwesomeIcons.instagram,
                            color: Color.fromARGB(255, 22, 18, 18),
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            FontAwesomeIcons.linkedin,
                            color: Color.fromARGB(255, 7, 6, 6),
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            FontAwesomeIcons.github,
                            color: Color.fromARGB(255, 10, 10, 10),
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            FontAwesomeIcons.twitter,
                            color: Color.fromARGB(255, 14, 12, 12),
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            FontAwesomeIcons.facebook,
                            color: Color.fromARGB(255, 15, 11, 11),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
