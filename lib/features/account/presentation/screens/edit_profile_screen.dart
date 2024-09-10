import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/core/core.dart';
import 'package:music_app/features/account/presentation/presentation.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userPv = ref.read(userProvider);
    _nameController = TextEditingController(text: userPv.fullName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: () {
              if (_nameController.text.isEmpty) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: const Text('El nombre no puede estar vacío'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            context.pop();
                          },
                          child: const Text('Aceptar'),
                        ),
                      ],
                    );
                  },
                );
              }
              ref.read(userProvider.notifier).setFullName(_nameController.text);
              context.pop();
            },
            child: Text(
              'Guardar',
              style: getSubtitleStyle().copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.15),
            //Foto
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/imgs/music_3.jpg'),
            ),
            const SizedBox(height: 25),
            //Nombre
            SizedBox(
              width: size.width * 0.8,
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
