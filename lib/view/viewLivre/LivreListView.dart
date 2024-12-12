import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/LivreViewModel.dart';
import '../widget/CustomCard.dart';
import 'AjouterLivreView.dart';
import 'ModifierLivreView.dart';

class LivreListView extends StatefulWidget {
  final String userName;
  final String userRole;

  const LivreListView({
    super.key,
    required this.userName,
    required this.userRole
   });

  @override
  _LivreListViewState createState() => _LivreListViewState();
}

class _LivreListViewState extends State<LivreListView> {
  @override
  void initState() {
    super.initState();
    // Charger les livres seulement au démarrage
    final livreViewModel = Provider.of<LivreViewModel>(context, listen: false);
    livreViewModel.chargerLivres();
  }

  @override
  Widget build(BuildContext context) {
    final livreViewModel = Provider.of<LivreViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Livres'),
        actions: [
          if (widget.userRole == 'admin')
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AjouterLivreView(userName: widget.userName, userRole: widget.userRole),
                ),
              );
            },
          ),
        ],
      ),
      body: livreViewModel.livres.isEmpty
          ? const Center(child: Text('Aucun livre disponible.'))
          : ListView.builder(
        itemCount: livreViewModel.livres.length,
        itemBuilder: (context, index) {
          final livre = livreViewModel.livres[index];
          return CustomCard(
            title: livre.nomLivre,
            subtitle: 'Auteur: ${livre.auteur.nomAuteur}',
            displayJacket: true,
            jacketPath: livre.jacketPath,
            userRole: widget.userRole,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ModifierLivreView(livre: livre),
                ),
              );
            },
            onDelete: (){
              livreViewModel.supprimerLivre(livre.idLivre!);
            },
          );
        },
      ),
    );
  }
}
