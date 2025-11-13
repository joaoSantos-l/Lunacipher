import 'package:enciphered_app/models/password.dart';
import 'package:enciphered_app/services/session_manager.dart';
import 'package:enciphered_app/widgets/password/password_item.dart';
import 'package:enciphered_app/services/database_helper.dart';
import 'package:enciphered_app/widgets/components/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/password/password_modal.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _searchQuery = '';

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
          Row(
            children: [
              IconButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/profile'),
                icon: Icon(Icons.person),
              ),
              SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.exit_to_app, color: Colors.redAccent),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Fazer Logout'),
                      content: const Text(
                        'Tem certeza que deseja fazer logout?',
                      ),
                      actions: [
                        TextButton(
                          child: const Text('Cancelar'),
                          onPressed: () => Navigator.pop(context, false),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          child: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () => Navigator.pop(context, true),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    SessionManager.logout();
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
              ),
              SizedBox(width: 10),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
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
                SizedBox(height: 20),
                SearchBarWidget(
                  onSearch: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },

                  onClear: () {
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: FutureBuilder(
              future: DatabaseHelper.instance.getPasswordsByUserId(
                filter: _searchQuery,
              ),
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
                            PasswordModel currentPassword =
                                snapshot.data![index];
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
