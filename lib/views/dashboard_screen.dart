import 'package:enciphered_app/main.dart';
import 'package:enciphered_app/models/password.dart';
import 'package:enciphered_app/views/password_item.dart';
import 'package:enciphered_app/views/login_screen.dart';
import 'package:enciphered_app/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/password/password_modal.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  deletePasswordd(PasswordModel password) {
    setState(() {
      DatabaseHelper.instance.removePassword(password.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F2F),
        title: Text(
          'Lunacipher',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white70),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(showWelcomeSnackbar(context, 'teste'));
            },
            icon: Icon(Icons.data_object_sharp),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3A5BA0), Color(0xFF4C7DD1)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Suas Senhas',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Gerencie todas as suas senhas em um só lugar',
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: FutureBuilder(
              future: DatabaseHelper.instance.getPasswordsByUserId(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!.isEmpty
                      ? const Center(
                          child: Text(
                            'Você não tem nenhuma senha salva',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : ListView.separated(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            PasswordModel currentPassword = snapshot
                                .data![snapshot.data!.length - index - 1];
                            return Passworditem(
                              password: currentPassword,
                              deletePassword: () =>
                                  deletePasswordd(currentPassword),
                              index: index,
                              totalCount: snapshot.data!.length,
                            );
                          },
                          separatorBuilder: (context, index) => const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Divider(
                              height: 1,
                              thickness: 1,
                              color: Color.fromARGB(255, 133, 135, 146),
                            ),
                          ),
                        );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newPassword = await showDialog<PasswordModel>(
            context: context,
            builder: (context) => AddPasswordModal(),
          );

          if (newPassword != null) {
            await DatabaseHelper.instance.addPassword(
              newPassword,
              newPassword.platformPassword,
            );
            setState(() {});
          }
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
