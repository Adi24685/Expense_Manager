import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:google_fonts/google_fonts.dart'; // Import the google_fonts package

class ImagePickerPage extends StatefulWidget {
  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _pickedImage; // Holds the image picked by the user
  Database? _database;

  @override
  void initState() {
    super.initState();
    _initializeDatabase(); // Initialize the SQLite database when the app starts
  }

  // Initialize SQLite database
  Future<void> _initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'images.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(''' 
          CREATE TABLE images (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            image BLOB NOT NULL
          )
        ''');
      },
    );
  }

  // Save the picked image to the SQLite database
  Future<void> _saveImageToDatabase(Uint8List imageBytes) async {
    if (_database == null) {
      throw Exception("Database not initialized");
    }
    await _database!.insert('images', {'image': imageBytes});
  }

  // Pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final imageBytes = await image.readAsBytes();
      setState(() {
        _pickedImage = imageBytes; // Update the UI to display the selected image
      });
    }
  }

  // Save the image to the database and show a confirmation
 

  @override
  Widget build(BuildContext context) {
     Future<void> _saveImage() async {
    if (_pickedImage != null) {
      await _saveImageToDatabase(_pickedImage!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image saved successfully!')),
      );

      setState(() {
        _pickedImage = null; // Reset the picked image after saving
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image to save!')),
      );
    }
  }
    return Scaffold(
      appBar: AppBar(title:const  Text('Pick and Save Image')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the picked image or a placeholder icon
            GestureDetector(
              onTap: _pickImage, // Pick an image when tapped
              child: _pickedImage != null
                  ? Image.memory(
                      _pickedImage!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    )
                  : Column(
                      children: [
                        Container(
                          width: 150,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(75),
                          ),
                          child: Text(
                            "        Select Image",
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(75),
                          ),
                          child: Icon(Icons.image, size: 60, color: Colors.grey),
                        ),
                      ],
                    ),
            ),
            SizedBox(height: 20),

            // Show the "Save" button only if an image is picked
            if (_pickedImage != null)
              ElevatedButton(
                onPressed: _saveImage, // Save the image when pressed
                child: Text(
                  'Save Image',
                  style: GoogleFonts.quicksand(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _database?.close(); // Close the database connection when the widget is disposed
    super.dispose();
  }
}
