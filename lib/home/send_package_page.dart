import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_constants.dart';

// Models spécifiques à cette page
class FormFieldData {
  final String label;
  final String? placeholder;
  final String? value;
  final FormFieldType type;
  final bool isRequired;
  final int? maxLength;
  final List<String>? dropdownOptions;
  final Function(String)? onChanged;
  final VoidCallback? onTap;

  FormFieldData({
    required this.label,
    this.placeholder,
    this.value,
    required this.type,
    this.isRequired = false,
    this.maxLength,
    this.dropdownOptions,
    this.onChanged,
    this.onTap,
  });
}

class ModalData {
  final IconData icon;
  final String title;
  final String description;
  final String primaryButtonText;
  final String? secondaryButtonText;
  final VoidCallback onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;

  const ModalData({
    required this.icon,
    required this.title,
    required this.description,
    required this.primaryButtonText,
    this.secondaryButtonText,
    required this.onPrimaryPressed,
    this.onSecondaryPressed,
  });
}

class ToggleFieldData {
  final String title;
  final String? subtitle;
  final bool value;
  final bool hasInfoIcon;
  final Function(bool)? onChanged;

  ToggleFieldData({
    required this.title,
    this.subtitle,
    required this.value,
    this.hasInfoIcon = false,
    this.onChanged,
  });
}

enum FormFieldType { text, dropdown, counter, multiline, imagePicker }

class SendPackagePage extends StatefulWidget {
  const SendPackagePage({Key? key}) : super(key: key);

  @override
  State<SendPackagePage> createState() => _SendPackagePageState();
}

class _SendPackagePageState extends State<SendPackagePage> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = <String, TextEditingController>{};

  // Form state
  String _selectedPackageType = '';
  int _selectedWeightIndex = 0; // Index de l'intervalle de poids sélectionné
  bool _isStandardSize = false;
  bool _isContentConfirmed = false;

  // Intervalles de poids prédéfinis
  static const List<String> _weightIntervals = [
    '1-2 kg',
    '2-3 kg',
    '3-4 kg',
    '4-5 kg',
    '5-6 kg',
    '6-7 kg',
    '7-8 kg',
    '8-9 kg',
    '9-10 kg',
    '10-11 kg',
    '11-12 kg',
    '12-13 kg',
    '13-14 kg',
    '14-15 kg',
    '15-16 kg',
    '16-17 kg',
    '17-18 kg',
    '18-19 kg',
    '19-20 kg',
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _initializeControllers() {
    final fields = ['departure', 'destination', 'packageType', 'description'];
    for (String field in fields) {
      _controllers[field] = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildForm()),
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.horizontalPaddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.surface,
                    ),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'J\'envoie un colis',
                    style: GoogleFonts.roboto(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.surface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Entrez votre destination et explorez la liste des\nvoyageurs.',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: AppColors.surface.withOpacity(0.9),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.horizontalPaddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._getLocationFields().map(_buildFormField),
            const SizedBox(height: AppSizes.verticalSpacingLarge),
            _buildSectionTitle('Colis'),
            ..._getPackageFields().map(_buildFormField),
            const SizedBox(height: AppSizes.verticalSpacingLarge),
            _buildSectionTitle('Photo du colis'),
            _buildImagePicker(),
            const SizedBox(height: AppSizes.verticalSpacingLarge),
            ..._getToggleFields().map(_buildToggleField),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.verticalSpacing),
      child: Text(
        title,
        style: GoogleFonts.roboto(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildFormField(FormFieldData field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.verticalSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (field.type != FormFieldType.counter) ...[
            Text(
              field.label,
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
          ],
          _buildFieldInput(field),
        ],
      ),
    );
  }

  Widget _buildFieldInput(FormFieldData field) {
    switch (field.type) {
      case FormFieldType.text:
        return _buildTextField(field);
      case FormFieldType.dropdown:
        return _buildDropdownField(field);
      case FormFieldType.counter:
        return _buildCounterField(field);
      case FormFieldType.multiline:
        return _buildMultilineField(field);
      case FormFieldType.imagePicker:
        return _buildImagePicker();
    }
  }

  Widget _buildTextField(FormFieldData field) {
    return Container(
      height: AppSizes.actionButtonHeight,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: AppColors.divider),
      ),
      child: TextField(
        controller: _controllers[field.label.toLowerCase()],
        decoration: InputDecoration(
          hintText: field.placeholder,
          hintStyle: GoogleFonts.roboto(color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          suffixIcon:
              field.onTap != null
                  ? Icon(Icons.close, color: AppColors.error, size: 20)
                  : null,
        ),
        style: GoogleFonts.roboto(fontSize: 16, color: AppColors.textPrimary),
        onChanged: field.onChanged,
        readOnly: field.onTap != null,
        onTap: field.onTap,
      ),
    );
  }

  Widget _buildDropdownField(FormFieldData field) {
    return Container(
      height: AppSizes.actionButtonHeight,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: AppColors.divider),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: field.value?.isNotEmpty == true ? field.value : null,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              field.placeholder ?? field.label,
              style: GoogleFonts.roboto(color: AppColors.textSecondary),
            ),
          ),
          isExpanded: true,
          icon: const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.keyboard_arrow_down),
          ),
          items:
              field.dropdownOptions?.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      option,
                      style: GoogleFonts.roboto(fontSize: 16),
                    ),
                  ),
                );
              }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null && field.onChanged != null) {
              field.onChanged!(newValue);
            }
          },
        ),
      ),
    );
  }

  Widget _buildCounterField(FormFieldData field) {
    return Container(
      height: AppSizes.actionButtonHeight,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                field.label,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          _buildCounterButton(
            Icons.remove,
            _canDecrement,
            () => _decrementWeight(),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _weightIntervals[_selectedWeightIndex],
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          _buildCounterButton(
            Icons.add,
            _canIncrement,
            () => _incrementWeight(),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton(
    IconData icon,
    bool isEnabled,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isEnabled ? AppColors.primary : AppColors.divider,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.surface, size: 18),
      ),
    );
  }

  Widget _buildMultilineField(FormFieldData field) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: AppColors.divider),
      ),
      child: TextField(
        controller: _controllers['description'],
        maxLines: null,
        maxLength: field.maxLength,
        decoration: InputDecoration(
          hintText: field.placeholder,
          hintStyle: GoogleFonts.roboto(color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          counterStyle: GoogleFonts.roboto(color: AppColors.textSecondary),
        ),
        style: GoogleFonts.roboto(fontSize: 16, color: AppColors.textPrimary),
        onChanged: field.onChanged,
      ),
    );
  }

  Widget _buildImagePicker() {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: AppColors.divider, style: BorderStyle.solid),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate_outlined,
            size: 32,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 8),
          Text(
            'Ajouter une photo',
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleField(ToggleFieldData field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.verticalSpacing),
      child: Row(
        children: [
          Switch(
            value: field.value,
            onChanged: field.onChanged,
            activeColor: AppColors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field.title,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (field.subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    field.subtitle!,
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (field.hasInfoIcon)
            Icon(Icons.info_outline, size: 20, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.horizontalPaddingLarge),
      child: SizedBox(
        width: double.infinity,
        height: AppSizes.actionButtonHeight,
        child: ElevatedButton(
          onPressed: _handleNextStep,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.surface,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            ),
          ),
          child: Text(
            'Passer à l\'étape suivante',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModal(ModalData modalData) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSizes.horizontalPaddingLarge,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildModalIcon(modalData.icon),
              const SizedBox(height: 20),
              _buildModalTitle(modalData.title),
              const SizedBox(height: 12),
              _buildModalDescription(modalData.description),
              const SizedBox(height: 32),
              _buildModalButtons(modalData),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModalIcon(IconData icon) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 32, color: AppColors.primary),
    );
  }

  Widget _buildModalTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: GoogleFonts.roboto(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildModalDescription(String description) {
    return Text(
      description,
      textAlign: TextAlign.center,
      style: GoogleFonts.roboto(
        fontSize: 14,
        color: AppColors.textSecondary,
        height: 1.4,
      ),
    );
  }

  Widget _buildModalButtons(ModalData modalData) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: AppSizes.actionButtonHeight,
          child: ElevatedButton(
            onPressed: modalData.onPrimaryPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.surface,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              ),
            ),
            child: Text(
              modalData.primaryButtonText,
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        if (modalData.secondaryButtonText != null) ...[
          const SizedBox(height: 12),
          TextButton(
            onPressed:
                modalData.onSecondaryPressed ?? () => Navigator.pop(context),
            child: Text(
              modalData.secondaryButtonText!,
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  // Data Configuration
  List<FormFieldData> _getLocationFields() {
    return [
      FormFieldData(
        label: 'Départ',
        placeholder: 'Ville de départ',
        type: FormFieldType.text,
        onTap: () => _handleLocationTap('departure'),
        onChanged: (value) => setState(() {}),
      ),
      FormFieldData(
        label: 'Destination',
        placeholder: 'Ville de destination',
        type: FormFieldType.text,
        onTap: () => _handleLocationTap('destination'),
        onChanged: (value) => setState(() {}),
      ),
    ];
  }

  List<FormFieldData> _getPackageFields() {
    return [
      FormFieldData(
        label: 'Type de colis',
        placeholder: 'Type de colis',
        type: FormFieldType.dropdown,
        value: _selectedPackageType,
        dropdownOptions: ['Documents', 'Vêtements', 'Électronique', 'Autre'],
        onChanged: (value) => setState(() => _selectedPackageType = value),
      ),
      FormFieldData(label: 'Poids du colis', type: FormFieldType.counter),
      FormFieldData(
        label: 'Description du colis',
        placeholder: 'Description du colis',
        type: FormFieldType.multiline,
        maxLength: 150,
        onChanged: (value) => setState(() {}),
      ),
    ];
  }

  List<ToggleFieldData> _getToggleFields() {
    return [
      ToggleFieldData(
        title: 'Mon colis est de taille standard*',
        subtitle: 'Somme des 3 côtés = moins d\'1m70',
        value: _isStandardSize,
        hasInfoIcon: true,
        onChanged: (value) => setState(() => _isStandardSize = value),
      ),
      ToggleFieldData(
        title:
            'Je confirme que ce colis ne contient pas de produits interdits et/ou dangereux*',
        value: _isContentConfirmed,
        hasInfoIcon: true,
        onChanged: (value) => setState(() => _isContentConfirmed = value),
      ),
    ];
  }

  // Action Handlers
  void _handleLocationTap(String locationType) {
    print('Location tap: $locationType');
    // Implémentez la sélection de localisation
  }

  // Getters pour vérifier si les boutons sont activés
  bool get _canIncrement => _selectedWeightIndex < _weightIntervals.length - 1;
  bool get _canDecrement => _selectedWeightIndex > 0;

  void _incrementWeight() {
    if (_canIncrement) {
      setState(() => _selectedWeightIndex++);
    }
  }

  void _decrementWeight() {
    if (_canDecrement) {
      setState(() => _selectedWeightIndex--);
    }
  }

  void _handleNextStep() {
    if (_formKey.currentState?.validate() ?? false) {
      _showVerificationModal();
    }
  }

  void _showVerificationModal() {
    final modalData = ModalData(
      icon: Icons.security,
      title: 'Vérification d\'identité requise',
      description:
          'Pour assurer la sécurité de tous les utilisateurs, nous devons vérifier votre identité. Cette procédure est rapide et sécurisée.',
      primaryButtonText: 'Vérifier mon identité',
      secondaryButtonText: 'Plus tard',
      onPrimaryPressed: _handleVerifyIdentity,
      onSecondaryPressed: _handleSkipVerification,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildModal(modalData),
    );
  }

  void _handleVerifyIdentity() {
    Navigator.pop(context);
    print('Proceeding to identity verification');
    // Implémentez la navigation vers la vérification d'identité
  }

  void _handleSkipVerification() {
    Navigator.pop(context);
    print('Skipping verification for now');
    // Implémentez la logique pour passer la vérification
  }
}
