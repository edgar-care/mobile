import 'package:flutter/material.dart';

class Slot extends StatefulWidget {
  const Slot({Key? key}) : super(key: key);

 @override
  // ignore: library_private_types_in_public_api
  _SlotState createState() => _SlotState();
}

class _SlotState extends State<Slot> {
  @override
  Widget build(BuildContext context) {
    return Column(
            children: [
              Container(
                key: const ValueKey("Header"),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), 
                    child: Row (
                      children: [
                        Image.asset("assets/images/logo/edgar-high-five.png", height: 40, width: 37,),
                        const SizedBox(width: 16,),
                        const Text("Mon Agenda", style: TextStyle(fontSize: 20, fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: Colors.white),),
                    ]
                  ),
                ),
              ),
            ],
    );
  }
}