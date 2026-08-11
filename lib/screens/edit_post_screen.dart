import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/services/post_services.dart';
import 'package:social_media_app/services/image_services.dart';

class EditPostScreen extends StatefulWidget {
  final Post post;

  const EditPostScreen({
    super.key,
    required this.post,
  });

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  File? selectedImage;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.post.title,
    );

    _descriptionController = TextEditingController(
      text: widget.post.description,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Future<void> updatePost() async {
    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      isUpdating = true;
    });

    String imageUrl = widget.post.imageUrl;

    if (selectedImage != null) {
      imageUrl = await ImageServices.uploadImage(
        image: selectedImage!,
        apiKey: '99fecb79a682139d934ae76e00582ea5',
      );
    }

    final result = await PostServices.updatePost(
      postId: widget.post.postId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      imageUrl: imageUrl,
    );

    if (!mounted) return;

    if (result == 'success') {
      Navigator.pop(context);
    } else {
      setState(() {
        isUpdating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Post'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                prefixIcon: Icon(Icons.title),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Description',
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: pickImage,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white30,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: selectedImage != null
                      ? Image.file(
                          selectedImage!,
                          fit: BoxFit.cover,
                        )
                      : widget.post.imageUrl.isNotEmpty
                          ? Image.network(
                              widget.post.imageUrl,
                              fit: BoxFit.cover,
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate,
                                  size: 50,
                                ),
                                SizedBox(height: 10),
                                Text('Add an image'),
                              ],
                            ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isUpdating ? null : updatePost,
                child: isUpdating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}