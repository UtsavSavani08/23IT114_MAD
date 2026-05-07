import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../../../core/utils/validators.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../data/models/application_model.dart';
import '../../providers/application_provider.dart';
import '../../../resume/providers/resume_provider.dart';


class ApplicationEntryScreen extends StatefulWidget {
  final ApplicationModel? application;

  const ApplicationEntryScreen({super.key, this.application});

  @override
  State<ApplicationEntryScreen> createState() => _ApplicationEntryScreenState();
}

class _ApplicationEntryScreenState extends State<ApplicationEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _companyController;
  late TextEditingController _roleController;
  late TextEditingController _urlController;
  late TextEditingController _notesController;
  
  DateTime _dateApplied = DateTime.now();
  String? _selectedResumeId;
  ApplicationStatus _status = ApplicationStatus.applied;
  
  bool get isEdit => widget.application != null;

  @override
  void initState() {
    super.initState();
    _companyController = TextEditingController(text: widget.application?.companyName ?? '');
    _roleController = TextEditingController(text: widget.application?.jobRole ?? '');
    _urlController = TextEditingController(text: widget.application?.jobUrl ?? '');
    _notesController = TextEditingController(text: widget.application?.notes ?? '');
    
    if (widget.application != null) {
      _dateApplied = widget.application!.dateApplied;
      _selectedResumeId = widget.application!.resumeId;
      _status = widget.application!.status;
    }
  }

  @override
  void dispose() {
    _companyController.dispose();
    _roleController.dispose();
    _urlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveApplication() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<ApplicationProvider>();
      
      final app = ApplicationModel(
        applicationId: isEdit ? widget.application!.applicationId : provider.generateApplicationId(),
        companyName: _companyController.text.trim(),
        jobRole: _roleController.text.trim(),
        resumeId: _selectedResumeId ?? '',
        resumeProfileName: context.read<ResumeProvider>().getResumeById(_selectedResumeId ?? '')?.profileName ?? '',
        status: _status,
        dateApplied: _dateApplied,
        lastUpdated: DateTime.now(),
        jobUrl: _urlController.text.trim(),
        notes: _notesController.text.trim(),
      );

      if (isEdit) {
        provider.updateApplication(app);
      } else {
        provider.addApplication(app);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          isEdit ? 'Edit Application' : 'New Application',
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Company & Role'),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Company Name',
                controller: _companyController,
                prefixIcon: const Icon(Icons.business_rounded, color: AppColors.primary),
                validator: (val) => Validators.validateRequired(val, 'Field'),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Job Role',
                controller: _roleController,
                prefixIcon: const Icon(Icons.work_rounded, color: AppColors.primary),
                validator: (val) => Validators.validateRequired(val, 'Company Name'),
              ),
              const SizedBox(height: 32),
              _buildSectionHeader('Details'),
              const SizedBox(height: 16),
              _buildResumeDropdown(),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Job Post URL (Optional)',
                controller: _urlController,
                prefixIcon: const Icon(Icons.link_rounded, color: AppColors.primary),
                validator: (val) {
                  if (val != null && val.isNotEmpty) {
                    return Validators.validateUrl(val);
                  }
                  return null;
                },
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              _buildDatePicker(),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Notes (Optional)',
                controller: _notesController,
                maxLines: 4,
                prefixIcon: const Icon(Icons.notes_rounded, color: AppColors.primary),
              ),
              const SizedBox(height: 40),
              CustomButton(
                label: isEdit ? 'Update Application' : 'Save Application',
                onPressed: _saveApplication,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: -0.2,
      ),
    );
  }

  Widget _buildResumeDropdown() {
    final resumes = context.read<ResumeProvider>().resumes;
    
    // Ensure selected resume still exists, otherwise null it
    if (_selectedResumeId != null && !resumes.any((r) => r.id == _selectedResumeId)) {
      _selectedResumeId = null;
    }

    return DropdownButtonFormField<String>(
      value: _selectedResumeId,
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
      decoration: InputDecoration(
        labelText: 'Resume Used',
        prefixIcon: const Icon(Icons.description_rounded, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.border.withValues(alpha: 0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.border.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: Theme.of(context).cardTheme.color,
      ),
      items: resumes.map((resume) {
        return DropdownMenuItem<String>(
          value: resume.id,
          child: Text(resume.profileName),
        );
      }).toList(),
      onChanged: (val) {
        setState(() {
          _selectedResumeId = val;
        });
      },
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Please select a resume';
        }
        return null;
      },
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _dateApplied,
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                  onPrimary: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );
        if (date != null) {
          setState(() {
            _dateApplied = date;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date Applied',
          prefixIcon: const Icon(Icons.calendar_today_rounded, color: AppColors.primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.border.withValues(alpha: 0.5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.border.withValues(alpha: 0.5)),
          ),
          filled: true,
          fillColor: Theme.of(context).cardTheme.color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormatter.formatDate(_dateApplied),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
