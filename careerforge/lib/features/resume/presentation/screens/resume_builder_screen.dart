import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../data/models/resume_model.dart';
import '../../data/models/education_model.dart';
import '../../data/models/experience_model.dart';
import '../../providers/resume_provider.dart';
import '../widgets/education_form.dart';
import '../widgets/experience_form.dart';
import '../widgets/skills_input.dart';

class ResumeBuilderScreen extends StatefulWidget {
  final ResumeModel? resume;

  const ResumeBuilderScreen({super.key, this.resume});

  @override
  State<ResumeBuilderScreen> createState() => _ResumeBuilderScreenState();
}

class _ResumeBuilderScreenState extends State<ResumeBuilderScreen> {
  int _currentStep = 0;
  final _basicInfoFormKey = GlobalKey<FormState>();

  late TextEditingController _profileNameController;
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _summaryController;

  List<ExperienceModel> _experiences = [];
  List<EducationModel> _education = [];
  List<String> _skills = [];

  bool get isEdit => widget.resume != null;

  @override
  void initState() {
    super.initState();
    _profileNameController = TextEditingController(text: widget.resume?.profileName ?? '');
    _fullNameController = TextEditingController(text: widget.resume?.fullName ?? '');
    _emailController = TextEditingController(text: widget.resume?.email ?? '');
    _phoneController = TextEditingController(text: widget.resume?.phone ?? '');
    _addressController = TextEditingController(text: widget.resume?.address ?? '');
    _summaryController = TextEditingController(text: widget.resume?.summary ?? '');

    if (widget.resume != null) {
      _experiences = List.from(widget.resume!.experience);
      _education = List.from(widget.resume!.education);
      _skills = List.from(widget.resume!.skills);
    }
  }

  @override
  void dispose() {
    _profileNameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  void _saveResume() {
    if (!_basicInfoFormKey.currentState!.validate()) {
      setState(() {
        _currentStep = 0;
      });
      return;
    }

    final provider = context.read<ResumeProvider>();
    final resume = ResumeModel(
      id: isEdit ? widget.resume!.id : IdGenerator.generateUuid(),
      profileName: _profileNameController.text.trim(),
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      summary: _summaryController.text.trim(),
      skills: _skills,
      education: _education,
      experience: _experiences,
      createdAt: isEdit ? widget.resume!.createdAt : DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (isEdit) {
      provider.updateResume(resume);
    } else {
      provider.addResume(resume);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          isEdit ? 'Edit Resume' : 'Build Resume',
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          TextButton(
            onPressed: _saveResume,
            child: const Text('Save', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        elevation: 0,
        onStepTapped: (step) => setState(() => _currentStep = step),
        onStepContinue: () {
          if (_currentStep < 3) {
            setState(() => _currentStep += 1);
          } else {
            _saveResume();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          }
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 40.0, bottom: 20),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: _currentStep == 3 ? 'Finish & Save' : 'Next Step',
                    onPressed: details.onStepContinue!,
                  ),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      label: 'Previous',
                      isOutlined: true,
                      onPressed: details.onStepCancel!,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Basic', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            content: _buildBasicInfo(),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Work', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            content: ExperienceForm(
              experiences: _experiences,
              onChanged: (exp) => setState(() => _experiences = exp),
            ),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Education', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            content: EducationForm(
              education: _education,
              onChanged: (edu) => setState(() => _education = edu),
            ),
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Skills', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            content: SkillsInput(
              skills: _skills,
              onChanged: (skills) => setState(() => _skills = skills),
            ),
            isActive: _currentStep >= 3,
            state: _currentStep == 3 ? StepState.editing : StepState.indexed,
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Form(
      key: _basicInfoFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Profile Identity'),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Profile Name (e.g. Senior Backend CV)',
            controller: _profileNameController,
            prefixIcon: const Icon(Icons.badge_rounded, color: AppColors.primary),
            validator: (val) => Validators.validateRequired(val, 'Field'),
          ),
          const SizedBox(height: 32),
          _buildSectionTitle('Personal Details'),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Full Name',
            controller: _fullNameController,
            prefixIcon: const Icon(Icons.person_rounded, color: AppColors.primary),
            validator: (val) => Validators.validateRequired(val, 'Field'),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Email Address',
            controller: _emailController,
            prefixIcon: const Icon(Icons.email_rounded, color: AppColors.primary),
            validator: Validators.validateEmail,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Phone Number',
            controller: _phoneController,
            prefixIcon: const Icon(Icons.phone_rounded, color: AppColors.primary),
            validator: Validators.validatePhone,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Address (Optional)',
            controller: _addressController,
            prefixIcon: const Icon(Icons.location_on_rounded, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Professional Summary',
            controller: _summaryController,
            maxLines: 5,
            prefixIcon: const Icon(Icons.article_rounded, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: 0.5,
      ),
    );
  }
}
