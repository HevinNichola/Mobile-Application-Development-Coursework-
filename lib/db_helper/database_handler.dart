import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:contact_buddy/model/contact.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'contact.db'),
      onCreate: (database, version) async {
        await database.execute(
          "Create TABLE contacts(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, contactno INTEGER NOT NULL, email TEXT NOT NULL, image TEXT, address TEXT NOT NULL) ",
        );
      },
      version: 2,
      );
  }

  // insert query
  Future<int> insertContact(List<Contact> contacts) async{
    int result = 0;
    final Database db = await initializeDB();
    for(var contact in contacts) {
      result = await db.insert('contacts', contact.toMap());
    }
    return result;
  }

 // retrieve contact
  Future<List<Contact>> retrieveContacts() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('contacts');
    return queryResult.map((e) => Contact.fromMap(e)).toList();
  }

  // update contact
   Future<void> updateContact(Contact contact) async {
    final db = await initializeDB();
    await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
   }

   // delete contact
   Future<void> deleteContact (int id) async{
    final db = await initializeDB();
    await db.delete(
      'contacts',
      where: "id = ?",
      whereArgs: [id],
    );
   }

   // search contact
   Future<List<Contact>> searchContacts(String query) async {
    final db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query(
      'contacts',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
    );
    return queryResult.map((e) => Contact.fromMap(e)).toList();
   }

}