import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/User.dart';
import '../../viewmodel/UserViewModel.dart';

class ModifierUserView extends StatelessWidget {
  final User user;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomUserController = TextEditingController();
  final TextEditingController _prenomUserController = TextEditingController();
  final TextEditingController _loginUserController = TextEditingController();
  final TextEditingController _roleUserController = TextEditingController();

  ModifierUserView({super.key, required this.user}) {
    _nomUserController.text = user.nomUser;
    _prenomUserController.text = user.prenomUser;
    _loginUserController.text = user.loginUser;
    _roleUserController.text = user.roleUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier l\'Utilisateur', style: TextStyle(color: Colors.white60)),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomUserController,
                decoration: const InputDecoration(labelText: 'Nom de l\'utilisateur'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le nom de l\'utilisateur';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _prenomUserController,
                decoration: const InputDecoration(labelText: 'Prénom de l\'utilisateur'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le prénom de l\'utilisateur';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _loginUserController,
                decoration: const InputDecoration(labelText: 'Login de l\'utilisateur'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le login de l\'utilisateur';
                  }
                  return null;
                },
              ),
            DropdownButtonFormField<String>(
              value: user.roleUser,
              decoration: const InputDecoration(labelText: 'Rôle de l\'utilisateur'),
              items: const [
                DropdownMenuItem(
                  value: 'admin',
                  child: Text('Admin'),
                ),
                DropdownMenuItem(
                  value: 'user',
                  child: Text('User'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  _roleUserController.text = value;
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez choisir le rôle de l\'utilisateur';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Provider.of<UserViewModel>(context, listen: false)
                      .mettreAjourUtilisateur(
                    user.idUser!,
                    _nomUserController.text,
                    _prenomUserController.text,
                    _loginUserController.text,
                    '',
                    _roleUserController.text,
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Mettre à jour'),
            ),
            ],
          )
        )
      )
    );
  }
















}