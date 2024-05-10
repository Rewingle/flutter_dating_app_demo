import 'package:flutter/material.dart';
import 'package:flutter_empty/widgets/big_text.dart';
import 'package:flutter_empty/widgets/info_card.dart';

/* Future fetchProfile() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:5000/api/match'));

}
 */
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final name = 'John Doe';
    final age = 25;

    return Column(
      children: [
        Align(alignment: Alignment.centerLeft,child: Padding(padding: EdgeInsets.only(left: 20),child: BigText(text: 'Welcome back'))),
        SizedBox(height: 10),
        Center(
          child: SizedBox(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Stack(children: [
              
                Container(
                  height: 250,
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
                          spreadRadius: 32.0,
                          blurRadius: 40.0,
                        ),
                  
                      ],
                    ),
                    child: Stack(children: [
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Row(
                            children: [
                              Text(' ${name} ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.bold)),
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
            
                )
              ]),
            ),
          ),
        )
      ],
    );
  }
}
