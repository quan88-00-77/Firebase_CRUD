import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GiangVienScreen extends StatefulWidget {
  const GiangVienScreen({Key? key}) : super(key: key);

  @override
  State<GiangVienScreen> createState() => _GiangVienScreenState();
}

class _GiangVienScreenState extends State<GiangVienScreen> {
  final TextEditingController _IdGiangVienController = TextEditingController();
  final TextEditingController _MaGiangVienController = TextEditingController();
  final TextEditingController _HoTenController = TextEditingController();
  final TextEditingController _DiaChiController = TextEditingController();
  final TextEditingController _SDTController = TextEditingController();

  final CollectionReference _giangvien =
  FirebaseFirestore.instance.collection('giangvien');

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _IdGiangVienController.text = documentSnapshot['IDGV'];
      _MaGiangVienController.text = documentSnapshot['MaGV'];
      _HoTenController.text = documentSnapshot['HoTen'];
      _DiaChiController.text = documentSnapshot['DiaChi'];
      _SDTController.text = documentSnapshot['SDT'];
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
                    controller: _IdGiangVienController,
                    decoration: const InputDecoration(labelText: 'IDGV'),
                  ),
                  TextField(
                    controller: _MaGiangVienController,
                    decoration: const InputDecoration(labelText: 'MaGV'),
                  ),
                  TextField(
                    controller: _HoTenController,
                    decoration: const InputDecoration(labelText: 'HoTen'),
                  ),
                  TextField(
                    controller: _DiaChiController,
                    decoration: const InputDecoration(labelText: 'DiaChi'),
                  ),
                  TextField(
                    controller: _SDTController,
                    decoration: const InputDecoration(labelText: 'SDT'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final String? IDGV = _IdGiangVienController.text;
                        final String? MaGV = _MaGiangVienController.text;
                        final String? HoTen = _HoTenController.text;
                        final String? DiaChi = _DiaChiController.text;
                        final String? SDT = _SDTController.text;

                        if (IDGV != null &&
                            MaGV != null &&
                            HoTen != null &&
                            DiaChi != null &&
                            SDT != null) {
                          _IdGiangVienController.text = '';
                          _MaGiangVienController.text = '';
                          _HoTenController.text = '';
                          _DiaChiController.text = '';
                          _SDTController.text = '';

                          if (action == 'create') {
                            await _giangvien.add({
                              'IDGV': IDGV,
                              'MaGV': MaGV,
                              'HoTen': HoTen,
                              'DiaChi': DiaChi,
                              'SDT': SDT,
                            });
                          }

                          if (action == 'update') {
                            await _giangvien.doc(documentSnapshot!.id).update({
                              'IDGV': IDGV,
                              'MaGV': MaGV,
                              'HoTen': HoTen,
                              'DiaChi': DiaChi,
                              'SDT': SDT,
                            });
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
    await _giangvien.doc(productId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giang Vien'),
      ),
      body: StreamBuilder(
        stream: _giangvien.snapshots(),
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
                              Text('IDGV: ' + documentSnapshot['IDGV']),
                            ],
                          ),
                        ),
                      ),
                      subtitle: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ho va Ten: '+documentSnapshot['HoTen']),
                            Text('Ma Giang Vien: '+documentSnapshot['MaGV']),
                            Text('Dia Chi: '+documentSnapshot['DiaChi']),
                            Text('SDT: '+documentSnapshot['SDT']),
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
