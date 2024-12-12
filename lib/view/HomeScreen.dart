import 'package:bibliotheque/view/viewLivre/LivreListView.dart';
import 'package:bibliotheque/view/viewLivre/ModifierLivreView.dart';
import 'package:bibliotheque/view/viewUser/LoginView.dart';
import 'package:bibliotheque/view/viewUser/UserListView.dart';
import 'package:bibliotheque/viewmodel/UserViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/AuteurViewModel.dart';
import '../viewmodel/LivreViewModel.dart';

import 'viewAuteur/AuteurListView.dart';
import 'viewLivre/AjouterLivreView.dart';


class HomeScreen extends StatefulWidget {
  final String userName;
  final String userRole;

  const HomeScreen({super.key, required this.userName, required this.userRole});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() { // Appelé une seule fois lors de la création du widget
    super.initState();
    final livreViewModel = Provider.of<LivreViewModel>(context, listen: false);
    livreViewModel.chargerLivres();

    Future.microtask(() {
      final livreViewModel = Provider.of<LivreViewModel>(context, listen: false);
      livreViewModel.chargerLivres();
      final auteurViewModel = Provider.of<AuteurViewModel>(context, listen: false);
      auteurViewModel.chargerAuteurs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final livreViewModel = Provider.of<LivreViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bibliothèque Numérique'),
        backgroundColor: Colors.cyan,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.cyan,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.userRole == 'admin')
            ListTile(
              leading: const Icon(Icons.add, color: Colors.deepPurpleAccent),
              title: Text('Ajouter un Livre'),
              onTap: () {
                Navigator.pop(context); // Ferme le tiroir (Drawer)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AjouterLivreView(userName: widget.userName, userRole: widget.userRole)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.list, color: Colors.deepPurpleAccent),
              title: Text(widget.userRole == 'admin' ? 'Gérer les Auteurs' : 'Voir les Auteurs'),
              onTap: () {
                Navigator.pop(context); // Ferme le tiroir (Drawer)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AuteurListView(userName: widget.userName, userRole: widget.userRole)),
                );
              },
            ),
            if (widget.userRole == 'admin')
            ListTile(
              leading: const Icon(Icons.list, color: Colors.deepPurpleAccent),
              title: Text('Gérer les Utilisateurs'),
              onTap: () {
                Navigator.pop(context); // Ferme le tiroir (Drawer)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserListView(userName: widget.userName, userRole: widget.userRole)),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(child: LivreListView(userName: widget.userName, userRole: widget.userRole)),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.lightBlue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Connecté en tant que : ',
                        style: const TextStyle(fontSize: 16),
                      ),
                      TextSpan(
                        text: '${widget.userName}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    await Provider.of<UserViewModel>(context, listen: false).logout();

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginView()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                      'Se déconnecter',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                  ),

                )
              ]
            ),
          )
        ],
      )
    );
  }
}

