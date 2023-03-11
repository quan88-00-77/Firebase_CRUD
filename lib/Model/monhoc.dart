import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MonHocScreen extends StatefulWidget {
  const MonHocScreen({Key? key}) : super(key: key);

  @override
  State<MonHocScreen> createState() => _MonHocScreenState();
}

class _MonHocScreenState extends State<MonHocScreen> {
  final TextEditingController _IdMonHocController = TextEditingController();
  final TextEditingController _MaMonHocController = TextEditingController();
  final TextEditingController _TenMonHocController = TextEditingController();
  final TextEditingController _MoTaController = TextEditingController();

  final CollectionReference _monhoc =
  FirebaseFirestore.instance.collection('monhoc');

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _IdMonHocController.text = documentSnapshot['IDMH'];
      _MaMonHocController.text = documentSnapshot['MaMH'];
      _TenMonHocController.text = documentSnapshot['TenMH'];
      _MoTaController.text = documentSnapshot['MoTa'];
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _IdMonHocController,
                    decoration: const InputDecoration(labelText: 'IDMH'),
                  ),
                  TextField(
                    controller: _MaMonHocController,
                    decoration: const InputDecoration(labelText: 'MaMH'),
                  ),
                  TextField(
                    controller: _TenMonHocController,
                    decoration: const InputDecoration(labelText: 'TenMH'),
                  ),
                  TextField(
                    controller: _MoTaController,
                    decoration: const InputDecoration(labelText: 'MoTa'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final String? IDMH = _IdMonHocController.text;
                        final String? MaMH = _MaMonHocController.text;
                        final String? TenMH = _TenMonHocController.text;
                        final String? MoTa = _MoTaController.text;
                        if (IDMH != null &&
                            MaMH != null &&
                            TenMH != null &&
                            MoTa != null) {
                          _IdMonHocController.text = '';
                          _MaMonHocController.text = '';
                          _TenMonHocController.text = '';
                          _MoTaController.text = '';

                          if (action == 'create') {
                            await _monhoc.add({
                              'IDMH': IDMH,
                              'MaMH': MaMH,
                              'TenMH': TenMH,
                              'MoTa': MoTa,
                            });
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Successfully')));
                          }

                          if (action == 'update') {
                            await _monhoc.doc(documentSnapshot!.id).update({
                              'IDMH': IDMH,
                              'MaMH': MaMH,
                              'TenMH': TenMH,
                              'MoTa': MoTa,
                            });
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Successfully')));
                          }
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(action == 'create' ? 'Create' : 'Update'))
                ],
              ),
            ),
          );
        });
  }

  Future<void> _deleteProduct(String productId) async {
    await _monhoc.doc(productId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Hoc'),
      ),
      body: StreamBuilder(
        stream: _monhoc.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if(streamSnapshot.hasData){
            return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index){
                  final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];

                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: SingleChildScrollView(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('IDMH: ' + documentSnapshot['IDMH']),
                            ],
                          ),
                        ),
                      ),
                      subtitle: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ma Mon Hoc: '+documentSnapshot['MaMH']),
                            Text('Ten Mon Hoc: '+documentSnapshot['TenMH']),
                            Text('Mo Ta: '+documentSnapshot['MoTa']),
                          ],
                        ),
                      ),
                      trailing: SizedBox(
                        width: 100  ,
                        child: Row(
                          children: [
                            // Press this button to edit a single product
                            IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    _createOrUpdate(documentSnapshot)),
                            // This icon button is used to delete a single product
                            IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () =>
                                    _deleteProduct(documentSnapshot.id)),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
