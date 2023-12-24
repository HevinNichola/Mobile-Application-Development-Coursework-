import 'package:flutter/material.dart';
import 'dart:io';
import 'package:contact_buddy/db_helper/database_handler.dart';
import 'package:contact_buddy/screen/home_page.dart';
import 'package:contact_buddy/model/contact.dart';
import 'package:image_picker/image_picker.dart';


class UpdateContactScreen extends StatefulWidget {
  final Contact contact;

  const UpdateContactScreen({Key? key,required this.contact}) : super(key: key);

  @override
  State<UpdateContactScreen> createState() => _UpdateContactScreenState();
}

class _UpdateContactScreenState extends State<UpdateContactScreen> {

  final _formKey = GlobalKey<FormState>();
  late DatabaseHandler handler;
  late TextEditingController nameTextController;
  late TextEditingController contactnoTextController;
  late TextEditingController emailTextController;
  late TextEditingController addressTextController;
  late String imagePath;


  @override
  void initState(){
    super.initState();
    handler = DatabaseHandler();
    nameTextController = TextEditingController(text: widget.contact.name);
    contactnoTextController = TextEditingController(text: widget.contact.contactno.toString());
    emailTextController = TextEditingController(text: widget.contact.email);
    addressTextController = TextEditingController(text: widget.contact.address);
    imagePath = widget.contact.image;

  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedfile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedfile != null){
      setState(() {
        imagePath = pickedfile.path;

      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : const Text(
          'Update Contact',
          style: TextStyle(
            color: Color(0xFFF5F9FF),
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF4149B3),
        leading:  IconButton(
          icon: const Icon(Icons.arrow_back,
            color: Color(0xFFF5F9FF),
            size: 20,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()),
            );
            },
         ),
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 44,
                ),
                GestureDetector(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 58,
                    backgroundColor: const Color(0xFFEAF3FF),
                    backgroundImage:
                    imagePath.isNotEmpty ? FileImage(File(imagePath)) : null,
                    child: imagePath.isEmpty ? const Icon(Icons.add_a_photo, size:25,):null,
                  ),
                ),
                const SizedBox(
                  height: 28,
                ), const SizedBox(
                  height:28,
                ),

                TextFormField(
                  controller: nameTextController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color:Color(0xFF4149B3))
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:Color(0xFF708090)),
                    ),
                  ),
                  validator: (name){

                    if(name == null || name.isEmpty){
                      return 'Name is required';

                    }
                    RegExp nameRegExp = RegExp(r'^[a-zA-Z ]+$');
                    if( !nameRegExp.hasMatch(name)){
                      return 'Only letters are allowed';
                    }

                    if(name.length < 3) {
                      return 'Name must have least 3 characters long';

                    }
                    if(name.length > 30){
                      return 'Name cant be longer than 30 characters';
                    }

                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),

                TextFormField(
                  controller: contactnoTextController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Number',
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color:Color(0xFF4149B3))
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF708090)),
                    ),
                  ),
                  validator: (contactNumber){
                    if(contactNumber == null || contactNumber.isEmpty){
                      return 'Contact number is required';
                    }
                    RegExp phoneRegExp = RegExp(r'^[0-9]{10}$');
                    if (!phoneRegExp.hasMatch(contactNumber)){
                      return 'Invalid phone number. please enter 10 digit without spaces or special characters';
                    }
                    if(contactNumber[0] != '0') {
                      return 'Phone number must start with the digit 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),

                TextFormField(
                    controller: emailTextController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color:Color(0xFF4149B3))
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color:Color(0xFF708090)),
                      ),
                    ),
                    validator: (email){
                      if(email ==  null || email.isEmpty){
                        return 'Email is required';
                      }
                      RegExp emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
                      if(!emailRegExp.hasMatch(email)){
                        return ' Invalid email format';
                      }
                      return null;
                    }
                ),
                const SizedBox(

                  height: 20,
                ),

                TextFormField(
                  controller: addressTextController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF4149B3))
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color:Color(0xFF708090))
                    ),
                  ),
                  validator: (address){
                    if(address == null || address.isEmpty){
                      return 'Address is required';
                    }
                    if(address.length < 5){
                      return 'Address must be least 5 characters ';
                    }
                    return null;

                  },
                ),
                const SizedBox(
                  height: 29,
                ),

             SizedBox(
               width: 290.0,
               height: 63.0,
               child: ElevatedButton(
                 onPressed: () {
                   if (_formKey.currentState?.validate() ?? false) {
                     handler.initializeDB().whenComplete(() async {
                       Contact updatedContact = Contact(
                         id: widget.contact.id,
                         name: nameTextController.text,
                         contactno: int.parse(contactnoTextController.text),
                         email: emailTextController.text,
                         image: imagePath,
                         address: addressTextController.text,
                       );
                       await handler.updateContact(updatedContact);
                       setState((){});
                     });
                     Navigator.pop(context,true);
                   }
                   },
                 style: ElevatedButton.styleFrom(
                   backgroundColor: const Color(0xFF191970),
                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(15)
                   ),
                 ),
                 child: const Text(
                   "Update",
                   style: TextStyle(
                     color: Colors.white,
                     fontWeight: FontWeight.bold,
                     fontSize: 21,
                   ),
                 ),
               ),
               ),
              ],
             ),
          ),
        ),
      ),
    );
  }
}
