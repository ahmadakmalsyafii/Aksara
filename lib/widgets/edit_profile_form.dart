// lib/views/profile/widgets/edit_profile_form.dart

import 'package:flutter/material.dart';

class EditProfileForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController classController;
  final TextEditingController majorController;
  final TextEditingController dobController;

  const EditProfileForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.classController,
    required this.majorController,
    required this.dobController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          _buildTextField(label: "Nama Lengkap", controller: nameController),
          _buildTextField(label: "E-mail", controller: emailController, readOnly: true),
          _buildTextField(label: "Kelas", controller: classController),
          _buildTextField(label: "Peminatan", controller: majorController),
          _buildDateField(context),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            decoration: InputDecoration(
              hintText: label,
              suffixIcon: readOnly ? null : const Icon(Icons.edit_outlined, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            validator: (value) {
              if (!readOnly && (value == null || value.isEmpty)) {
                return '$label tidak boleh kosong';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }


  Widget _buildDateField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Tanggal Lahir", style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextFormField(
            controller: dobController,
            readOnly: true,
            decoration: InputDecoration(
              hintText: "Masukkan tanggal lahirmu",
              suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                dobController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
              }
            },
          ),
        ],
      ),
    );
  }
}