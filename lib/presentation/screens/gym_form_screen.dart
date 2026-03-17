import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../l10n/app_localizations.dart';
import '../../core/di/injection_container.dart';
import '../../core/utils/validators.dart';
import '../../domain/usecases/gym_commands.dart';
import '../../domain/usecases/gym_queries.dart';
import '../cubits/gym_form/gym_form_cubit.dart';
import '../cubits/gym_form/gym_form_state.dart';

class GymFormScreen extends StatefulWidget {
  final int? gymId;

  const GymFormScreen({super.key, this.gymId});

  @override
  State<GymFormScreen> createState() => _GymFormScreenState();
}

class _GymFormScreenState extends State<GymFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _imageUrlController;

  late final TextEditingController _latitudeController;
  late final TextEditingController _longitudeController;
  late final TextEditingController _openingHoursController;

  final List<String> _selectedFacilities = [];

  final List<String> _availableFacilities = [
    'Pool',
    'Sauna',
    'Parking',
    'WiFi',
    'Lockers',
    'Yoga',
    'Meditation',
    'CrossFit',
    'Boxing',
    'Personal Training',
    'Juice Bar',
    'Weightlifting',
    'Spa',
    'Kids Area',
  ];

  bool get isEditMode => widget.gymId != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _descriptionController = TextEditingController();
    _imageUrlController = TextEditingController();

    _latitudeController = TextEditingController();
    _longitudeController = TextEditingController();
    _openingHoursController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();

    _latitudeController.dispose();
    _longitudeController.dispose();
    _openingHoursController.dispose();
    super.dispose();
  }

  void _populateForm(GymFormEditing state) {
    final gym = state.gym;
    if (gym != null) {
      _nameController.text = gym.name;
      _addressController.text = gym.address;
      _phoneController.text = gym.phoneNumber;
      _emailController.text = gym.email;
      _descriptionController.text = gym.description;
      _imageUrlController.text = gym.imageUrl;

      _latitudeController.text = gym.latitude.toString();
      _longitudeController.text = gym.longitude.toString();
      _openingHoursController.text = gym.openingHours;
      _selectedFacilities.clear();
      _selectedFacilities.addAll(gym.facilities);
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      setState(() {
        _imageUrlController.text = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) {
        final cubit = GymFormCubit(
          getGymById: sl<GetGymById>(),
          insertGym: sl<InsertGym>(),
          updateGym: sl<UpdateGym>(),
        );
        if (isEditMode) {
          cubit.initializeForEdit(widget.gymId!);
        } else {
          cubit.initializeForCreate();
        }
        return cubit;
      },
      child: BlocConsumer<GymFormCubit, GymFormState>(
        listener: (context, state) {
          if (state is GymFormEditing &&
              state.isEditMode &&
              state.gym != null) {
            _populateForm(state);
          }
          if (state is GymFormSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            context.pop(true);
          }
          if (state is GymFormError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(isEditMode ? l10n.editGym : l10n.addGym),
            ),
            body: state is GymFormSubmitting
                ? Center(
                    child: CircularProgressIndicator(
                      color: colorScheme.primary,
                    ),
                  )
                : _buildForm(context, colorScheme),
            bottomNavigationBar: _buildBottomBar(context, state, colorScheme),
          );
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context, ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(
            colorScheme,
            l10n.basicInformation,
            Icons.info_outline,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: l10n.gymName,
              prefixIcon: const Icon(Icons.fitness_center),
            ),
            validator: (value) =>
                Validators.validateMinLength(value, 3, fieldName: 'Name'),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(
              labelText: l10n.address,
              prefixIcon: const Icon(Icons.location_on),
            ),
            validator: (value) =>
                Validators.validateRequired(value, fieldName: 'Address'),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: l10n.description,
              prefixIcon: const Icon(Icons.description),
              alignLabelWithHint: true,
            ),
            validator: (value) => Validators.validateMinLength(
              value,
              10,
              fieldName: 'Description',
            ),
            maxLines: 3,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(
            colorScheme,
            l10n.contactInfo,
            Icons.contact_phone,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: l10n.phoneNumber,
              prefixIcon: const Icon(Icons.phone),
            ),
            validator: Validators.validatePhone,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: l10n.emailField,
              prefixIcon: const Icon(Icons.email),
            ),
            validator: Validators.validateEmail,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(colorScheme, l10n.details, Icons.details),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _imageUrlController,
                  decoration: InputDecoration(
                    labelText: l10n.imageUrl,
                    prefixIcon: const Icon(Icons.image),
                    hintText: 'https://example.com/image.jpg',
                  ),
                  validator: (value) => Validators.validateRequired(
                    value,
                    fieldName: 'Image URL',
                  ),
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: IconButton.filled(
                  onPressed: () => _pickImage(context),
                  icon: const Icon(Icons.photo_library),
                  tooltip: 'Pick from gallery',
                ),
              ),
            ],
          ),
          if (_imageUrlController.text.isNotEmpty &&
              _imageUrlController.text.startsWith('/')) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(_imageUrlController.text),
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ],
          const SizedBox(height: 16),
          TextFormField(
            controller: _openingHoursController,
            decoration: InputDecoration(
              labelText: l10n.openingHours,
              prefixIcon: const Icon(Icons.access_time),
              hintText: '6:00 AM - 10:00 PM',
            ),
            validator: (value) => Validators.validateRequired(
              value,
              fieldName: 'Opening Hours',
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _latitudeController,
                  decoration: InputDecoration(
                    labelText: l10n.latitude,
                    prefixIcon: const Icon(Icons.my_location),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _longitudeController,
                  decoration: InputDecoration(
                    labelText: l10n.longitude,
                    prefixIcon: const Icon(Icons.my_location),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  textInputAction: TextInputAction.done,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(colorScheme, l10n.facilities, Icons.category),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableFacilities.map((facility) {
              final isSelected = _selectedFacilities.contains(facility);
              return FilterChip(
                label: Text(
                  facility,
                  style: TextStyle(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedFacilities.add(facility);
                    } else {
                      _selectedFacilities.remove(facility);
                    }
                  });
                },
                selectedColor: colorScheme.primary.withValues(alpha: 0.2),
                checkmarkColor: colorScheme.primary,
                backgroundColor: colorScheme.surfaceContainerHighest,
              );
            }).toList(),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    ColorScheme colorScheme,
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
            fontSize: 13,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    GymFormState state,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        border: Border(
          top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
        ),
      ),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorScheme.primary, colorScheme.secondary],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: state is GymFormSubmitting
                  ? null
                  : () => _submitForm(context),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  AppLocalizations.of(context)!.save,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<GymFormCubit>().submitGym(
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        description: _descriptionController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),

        latitude: double.tryParse(_latitudeController.text.trim()) ?? 0,
        longitude: double.tryParse(_longitudeController.text.trim()) ?? 0,
        openingHours: _openingHoursController.text.trim(),
        facilities: _selectedFacilities,
      );
    }
  }
}
