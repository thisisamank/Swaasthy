import 'package:codered/utils/constants/colors.dart';
import 'package:codered/utils/helpers/interactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'local_widgets/index.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        floatingActionButton: isKeyboardVisible(context)
            ? null
            : FloatingActionButton(
                backgroundColor: CodeRedColors.primary,
                onPressed: () {
                  Navigator.pushNamed(context, '/emergency');
                },
                child: Transform.translate(
                  offset: Offset(25, 0),
                  child: Transform(
                      transform:
                          Matrix4.rotationY((-2) * 3.142857142857143 / 2),
                      child: Icon(FontAwesome.ambulance)),
                ),
              ),
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 72),
            child: HomeAppBar()),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeGreetings(),
                  SizedBox(height: 20),
                  HomeSearch(),
                  SizedBox(height: 20),
                  HomeCardActions()
                ],
              )),
        ),
      ),
    );
  }
}
