import 'package:flutter/material.dart';


Future fetchProfile() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:5000/api/match'));

}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final name = 'John Doe';
    final age = 25;

    return Column(
      children: [
        SizedBox(height: 10),
        Center(
          child: SizedBox(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Stack(children: [
                Container(
                    height: 300,
                    width: (MediaQuery.of(context).size.width.floor() - 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red,
                          spreadRadius: 60,
                          blurRadius: 10,
                          offset: Offset(0, 300),
                        ),
                      ],
                    )),
                Container(
                  height: 300,
                  width: (MediaQuery.of(context).size.width.floor() - 20),
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://picsum.photos/${MediaQuery.of(context).size.width.floor() - 20}/300'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          spreadRadius: 16.0,
                          blurRadius: 40.0,
                        ),
                        /*  BoxShadow(
                            color: Colors.white70,
                            spreadRadius: -5.0,
                            blurRadius: 20.0,
                            offset: Offset(0, -20),
                          ), */
                      ],
                    ),
                    child: Stack(children: [
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Row(
                            children: [
                              Container(
                                child: Text(' ${name} ',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 32.0,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top:9),
                                child: Text(' ${age} ',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24.0,
                                        )),
                              )
                            ],
                          ),
                        ),
                      )
                    ]),
                  ),
                  /* ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          'https://picsum.photos/${MediaQuery.of(context).size.width.floor() - 20}/300',
                          fit: BoxFit.cover,
                        ),
                      ) ,
                       Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Center(child: Text('ASADASDASD'))),  */
                )
              ]),
            ),
          ),
        )
      ],
    );
  }
}
