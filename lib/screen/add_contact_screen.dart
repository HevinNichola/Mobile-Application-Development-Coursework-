import 'package:contact_buddy/db_helper/database_handler.dart';
import 'package:contact_buddy/model/contact.dart';
import 'package:contact_buddy/screen/home_page.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:contact_buddy/const/strings_const.dart';
import '../widget/custom_text_form_field.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {

  final _formKey = GlobalKey<FormState>();
  late DatabaseHandler handler;
  TextEditingController nameTextController= TextEditingController();
  TextEditingController contactnoTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController addressTextController = TextEditingController();
  late String imagePath;


  @override
  void initState(){
    super.initState();
    handler = DatabaseHandler();
    imagePath = '';

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
        title: Text(StringsConst.addContacts,
        style: const TextStyle(
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
        ),

      body: SingleChildScrollView(
         child: Padding(
           padding: const EdgeInsets.only(left: 20.0, right: 20.0),
           child : Form(
             key: _formKey,
             autovalidateMode: AutovalidateMode.onUserInteraction,
            child : Column(
             crossAxisAlignment: CrossAxisAlignment.center,
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
              const SizedBox(
              height: 44,
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
              height:28,
            ),

             CustomTextFormField(
              controller: nameTextController,
              textLabel: 'Name',
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

              CustomTextFormField(
              controller: contactnoTextController,
              textLabel: 'Contact Number',
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

              CustomTextFormField(
                controller: emailTextController,
                textLabel: 'Email',
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

              CustomTextFormField(
              controller: addressTextController,
              textLabel: 'Address',
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
                      Contact secondcontact = Contact(
                        name: nameTextController.text,
                        contactno: int.parse(contactnoTextController.text),
                        email: emailTextController.text,
                        image: imagePath,
                        address: addressTextController.text,

                      );
                      List<Contact> listOfContacts = [secondcontact];
                      handler.insertContact(listOfContacts);
                      setState(() {});
                    });
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF191970),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                ),
                 child: const Text(
                  "Add",
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

