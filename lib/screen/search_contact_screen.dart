import 'package:contact_buddy/db_helper/database_handler.dart';
import 'package:contact_buddy/screen/home_page.dart';
import 'package:contact_buddy/screen/update_contact_screen.dart';
import 'package:contact_buddy/screen/view_contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:contact_buddy/model/contact.dart';
import 'dart:io';

class SearchContactScreen extends StatefulWidget {
  const SearchContactScreen({Key? key}) : super(key: key);

  @override
  State<SearchContactScreen> createState() => _SearchContactScreenState();
}

class _SearchContactScreenState extends State<SearchContactScreen> {

  final TextEditingController searchController = TextEditingController();
  final DatabaseHandler handler = DatabaseHandler();
  late Future<List<Contact>> searchResults;

  @override
  void initState(){
    super.initState();
    searchResults = handler.retrieveContacts();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Contacts',
          style: TextStyle(
            color: Color(0xFFF5F9FF),
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF4149B3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color(0xFFF5F9FF),
              size: 20),
          onPressed: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),

      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: (query) {
                updateSearchResults();
              },
              decoration: InputDecoration(
                hintText: 'Search',

                prefixIcon: const Icon(Icons.search, color: Color(0xFF14144B)),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                       icon: const Icon(Icons.clear, color: Colors.black),
                       onPressed: () {
                         searchController.clear();
                         updateSearchResults();
                         },
                ) : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Color(0xFF708090))
                ),
              ),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(child: FutureBuilder(
                future: searchResults,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  else if (!snapshot.hasData ||
                      (snapshot.data as List<Contact>).isEmpty) {
                    return const Center(child: Text('No results found'));
                  }
                  else {
                    return ListView.builder(
                      itemCount: (snapshot.data as List<Contact>).length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: const Color(0xFFF5F9FF),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context,
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
                                     width:12,
                                   ),
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
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.end,
                                       children: [
                                         IconButton(onPressed: () {
                                           Navigator.push(context,
                                           MaterialPageRoute(builder: (context) => UpdateContactScreen(
                                               contact: snapshot.data![index],
                                           ),
                                           ),
                                           ).then((result){
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
                                         )
                                       ],
                                     ),
                                   )
                                 ],
                               )
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }
            ),
            ),
          ],
        ),
      ),
    );
  }
    void updateSearchResults(){
      setState(() {
        searchResults = handler.searchContacts(searchController.text);
      });
    }
}
