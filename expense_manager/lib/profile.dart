import 'dart:typed_data';
import 'package:expense_manager/AccountScreen.dart';
import 'package:expense_manager/MYHOME.dart';
import 'package:expense_manager/SettingScreen.dart';
import 'package:expense_manager/export_data_screen.dart';
import 'package:expense_manager/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart'; // Import google_fonts package

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String profileName = "$Username";
  String profileEmail = "$Username@gmail.com";
  String profilePhone = '9356870559';
  Uint8List? _profileImage;
  
  void updateProfileInfo(String newName, String newEmail, String newPhone) {
    setState(() {
      profileName = newName;
      profileEmail = newEmail;
      profilePhone = newPhone;
    });
  }

  // Initialize the database
  Database? _database;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'profile_image.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(''' 
          CREATE TABLE profile_image (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            image BLOB
          )
        ''');
      },
    );

    await _loadProfileImage();
  }

  Future<void> _saveProfileImage(Uint8List image) async {
    if (_database != null) {
      await _database!.delete('profile_image'); // Clear any existing image
      await _database!.insert('profile_image', {'image': image});
    }
  }

  Future<void> _loadProfileImage() async {
    if (_database != null) {
      final result = await _database!.query('profile_image');
      if (result.isNotEmpty) {
        setState(() {
          _profileImage = result.first['image'] as Uint8List;
        });
      }
    }
  }

  Future<void> _deleteProfileImage() async {
    if (_database != null) {
      await _database!.delete('profile_image');
      setState(() {
        _profileImage = null;
      });
    }
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _profileImage = bytes;
      });
      await _saveProfileImage(bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.grey[600],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 42,
                            backgroundColor: const Color.fromARGB(255, 237, 206, 243),
                            child: GestureDetector(
                              onTap: _pickProfileImage, // Pick or update profile image
                              child: _profileImage != null
                                  ? ClipOval(
                                      child: Image.memory(
                                        _profileImage!,
                                        width: 84,
                                        height: 84,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.purple,
                                    ),
                            ),
                          ),
                        ),
                        if (_profileImage != null)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: _deleteProfileImage, // Delete profile image
                              child: const CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: 14,
                                child: Icon(Icons.delete, size: 16, color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      profileName, 
                      style: GoogleFonts.quicksand(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                    Text(
                      profileEmail, 
                      style: GoogleFonts.quicksand(
                        fontSize: 14, 
                        color: Colors.white
                      ),
                    ),
                    Text(
                      profilePhone, 
                      style: GoogleFonts.quicksand(
                        fontSize: 14, 
                        color: Colors.white
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ProfileListTile(
                      icon: Icons.account_box,
                      title: 'Account',
                      color: Colors.purple,
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AccountScreen(
                              currentName: profileName,
                              currentEmail: profileEmail,
                              currentPhone: profilePhone,
                            ),
                          ),
                        );
                        if (result != null) {
                          updateProfileInfo(result['name'], result['email'], result['phone']);
                        }
                      },
                    ),
                    Divider(color: Colors.grey[300]),
                    ProfileListTile(
                      icon: Icons.upload_file,
                      title: 'Export Data',
                      color: Colors.blueAccent,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context){
                          return ExportDataScreen();
                        }));
                      },
                    ),
                    Divider(color: Colors.grey[300]),
                    ProfileListTile(
                      icon: Icons.settings,
                      title: 'Settings',
                      color: Colors.green,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context){
                          return SettingsPage();
                        }));
                      },
                    ),
                    Divider(color: Colors.grey[300]),
                    ProfileListTile(
                      icon: Icons.logout,
                      title: 'Logout',
                      color: Colors.red,
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){
                          return WelcomeScreen();
                        }), (Route) {
                          return false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color color;

  const ProfileListTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: GoogleFonts.quicksand(),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
