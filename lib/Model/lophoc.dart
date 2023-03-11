import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LopHocScreen extends StatefulWidget {
  const LopHocScreen({Key? key}) : super(key: key);

  @override
  State<LopHocScreen> createState() => _LopHocScreenState();
}

//Id, Mã Lớp Học, Tên Lớp, Số Lượng Sinh Viên, Mã Giảng Viên
class _LopHocScreenState extends State<LopHocScreen> {
  final TextEditingController _IdLopHocController = TextEditingController();
  final TextEditingController _MaLopHocController = TextEditingController();
  final TextEditingController _TenLopController = TextEditingController();
  final TextEditingController _SoLuongSVController = TextEditingController();
  final TextEditingController _MaGVController = TextEditingController();

  final CollectionReference _lophoc = FirebaseFirestore.instance.collection('lophoc');

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _IdLopHocController.text = documentSnapshot['IDLH'];
      _MaLopHocController.text = documentSnapshot['MaLH'];
      _TenLopController.text = documentSnapshot['TenLH'];
      _SoLuongSVController.text = documentSnapshot['SLSV'];
      _MaGVController.text = documentSnapshot['MaGV'];
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
                    controller: _IdLopHocController,
                    decoration: const InputDecoration(labelText: 'ID Lop Hoc'),
                  ),
                  TextField(
                    controller: _MaLopHocController,
                    decoration: const InputDecoration(labelText: 'Ma Lop Hoc'),
                  ),
                  TextField(
                    controller: _TenLopController,
                    decoration: const InputDecoration(labelText: 'Ten Lop Hoc'),
                  ),
                  TextField(
                    controller: _SoLuongSVController,
                    decoration: const InputDecoration(labelText: 'So Luong Sinh Vien'),
                  ),
                  TextField(
                    controller: _MaGVController,
                    decoration: const InputDecoration(labelText: 'Ma Giang Vien'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final String? IDLH = _IdLopHocController.text;
                        final String? MaLH = _MaLopHocController.text;
                        final String? TenLH = _TenLopController.text;
                        final String? SLSV = _SoLuongSVController.text;
                        final String? MaGV = _MaGVController.text;

                        if (IDLH != null &&
                            MaLH != null &&
                            TenLH != null &&
                            SLSV != null &&
                            MaGV != null) {
                          _IdLopHocController.text = '';
                          _MaLopHocController.text = '';
                          _TenLopController.text = '';
                          _SoLuongSVController.text = '';
                          _MaGVController.text = '';

                          if (action == 'create') {
                            await _lophoc.add({
                              'IDLH': IDLH,
                              'MaLH': MaLH,
                              'TenLH': TenLH,
                              'SLSV': SLSV,
                              'MaGV': MaGV,
                            });
                          }

                          if (action == 'update') {
                            await _lophoc.doc(documentSnapshot!.id).update({
                              'IDLH': IDLH,
                              'MaLH': MaLH,
                              'TenLH': TenLH,
                              'SLSV': SLSV,
                              'MaSV': MaGV,
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
    await _lophoc.doc(productId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lop Hoc'),
      ),
      body: StreamBuilder(
        stream: _lophoc.snapshots(),
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
                              Text('IDLH: ' + documentSnapshot['IDLH']),
                            ],
                          ),
                        ),
                      ),
                      subtitle: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ma Lop Hoc: '+documentSnapshot['MaLH']),
                            Text('Ten Lop Hoc: '+documentSnapshot['TenLH']),
                            Text('So Luong Sinh Vien: '+documentSnapshot['SLSV']),
                            Text('Ma Giang Vien: '+documentSnapshot['MaGV']),
                          ],
                        ),
                      ),
                      trailing: SizedBox(
                        width: 100,
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
