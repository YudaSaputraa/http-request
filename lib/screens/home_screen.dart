import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'add_user_screen.dart';
import 'edit_user_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: Consumer<UserProvider>(
        // ini adalah pasangan dari ChangeNotifier, fungsinya adalah mendengarkan perubahan yang ada di UserProvider
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userProvider.users.isEmpty) {
            return const Center(child: Text('No users found'));
          }

          return ListView.builder(
            itemCount: userProvider.users.length,
            itemBuilder: (context, index) {
              final user = userProvider.users[index];
              return Dismissible(
                key: Key(user.id?.toString() ?? ''),
                direction: DismissDirection.horizontal,
                background: Container(
                  color: Colors.blue,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  child: const Icon(Icons.edit, color: Colors.white),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    return await showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Delete User'),
                            content: const Text(
                              'Are you sure you want to delete this user?',
                            ),
                            actions: [
                              TextButton(
                                onPressed:
                                    () => Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed:
                                    () => Navigator.of(context).pop(true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                    );
                  }
                  return true;
                },
                onDismissed: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    try {
                      await Provider.of<UserProvider>(
                        context,
                        listen: false,
                      ).deleteUser(user.id?.toString() ?? '');
                      if (context.mounted) {
                        // ngecek widget masih aktif atau ga, kalo engga maka snackbar ga akan muncul
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('User deleted successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Failed to delete user: ${e.toString()}',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  } else if (direction == DismissDirection.startToEnd) {
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditUserScreen(user: user),
                        ),
                      );
                    }
                  }
                },
                child: ListTile(
                  title: Text(user.name ?? 'No Name'),
                  subtitle: Text('${user.email ?? 'No Email'} - ${user.gender ?? 'No Gender'}'),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddUserScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 