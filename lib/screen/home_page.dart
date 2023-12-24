import 'dart:io';
import 'package:contact_buddy/db_helper/database_handler.dart';
import 'package:contact_buddy/screen/search_contact_screen.dart';
import 'package:contact_buddy/screen/update_contact_screen.dart';
import 'package:contact_buddy/screen/view_contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:contact_buddy/model/contact.dart';
import 'package:contact_buddy/screen/add_contact_screen.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late DatabaseHandler handler;

  @override
  void initState(){
    super.initState();
    handler = DatabaseHandler();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Buddy',
        style: TextStyle(
          fontSize: 23,
          color:Color(0xFFF5F9FF),
          fontWeight: FontWeight.bold,
        )
      ),
       backgroundColor: const Color(0xFF4149B3),
        automaticallyImplyLeading: false,
        centerTitle: true,
    ),
      body: FutureBuilder(
        future: handler.retrieveContacts(),
        builder: (BuildContext context, AsyncSnapshot<List<Contact>>snapshot){
          if(snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index){
                return Card(
                  color: const Color(0xFFF5F9FF),
                  child : InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ViewContactScreen(
                          contact: snapshot.data![index],
                        ),
                        ),
                      );
                    },

                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        height: 70,
                    child: Row(
                      children: [
                            const SizedBox(
                              width: 12,
                            ),
                            //Display the contact image
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: snapshot.data![index].image.isNotEmpty
                                ? FileImage(File(snapshot.data![index].image)) : Image.asset('assets/images/profileIcon.png').image,
                            ),
                            const SizedBox(
                              width: 25,
                            ),
                            Expanded(
                              child: Text(
                                snapshot.data![index].name,
                                style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ),

                        Container(
                          alignment: Alignment.centerRight,
                          child :Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(onPressed: () {
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => UpdateContactScreen(
                                    contact: snapshot.data![index],
                                  ),
                                  ),
                                ).then((result) {
                                  if(result != null && result){
                                    setState(() {

                                    });
                                  }
                                });
                              },
                                icon: const Icon(Icons.edit,
                                  color: Color(0xFF14144B),),
                              ),
                              IconButton(
                                onPressed: (){
                                  handler.deleteContact(snapshot.data![index].id!);
                                  setState(() {
                                    snapshot.data!
                                        .remove(snapshot.data![index]);
                                  });
                                },
                                icon: const Icon(Icons.delete,
                                  color: Color(0xFF14144B),),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ),
                  ),
                  ),
                );
              },
            );
          }
          else{
            return const Center(child: CircularProgressIndicator());
          }
          },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 63.0,
            height: 63.0,
          child : FloatingActionButton(
            heroTag: 'search',
            backgroundColor: const Color(0xFF191970),
            foregroundColor: Colors.white,
            child: const Icon(Icons.search),
            onPressed: (){
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SearchContactScreen()
              ),
              );
            },
          ),
          ),
          const SizedBox(height: 18.0),
          SizedBox(
            width: 63.0,
            height: 63.0,
           child : FloatingActionButton(
            heroTag: 'add',
              backgroundColor: const Color(0xFF191970),
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
              onPressed: (){
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddContactScreen()
                ),
              );
              },
          ),
          ),
        ],
      ),
    );
  }
}
