# Resume Builder Screen

**File**: `lib/features/resume/presentation/screens/resume_builder_screen.dart`

## Overview
The `ResumeBuilderScreen` is a comprehensive, multi-step form wizard used to create or edit a `ResumeModel`. It breaks down the complex task of building a resume into manageable, logical sections using Flutter's Material `Stepper` widget.

## Key Features
- **Multi-Step Wizard**: Divided into four distinct steps for improved UX and cognitive load reduction:
  1. **Basic Info**: Collects high-level information including a distinct Profile Name (to identify the resume version internally), Full Name, Email, Phone, Address, and a Professional Summary.
  2. **Experience**: Utilizes the `ExperienceForm` widget to dynamically add, edit, or remove work experience entries (`ExperienceModel`), including company name, role, dates, and descriptions.
  3. **Education**: Utilizes the `EducationForm` widget to dynamically add, edit, or remove educational history entries (`EducationModel`), including institution, degree, and graduation dates.
  4. **Skills**: Utilizes the `SkillsInput` widget, allowing users to rapidly type and add technical or soft skills which are visually represented as dismissible Action Chips.
- **Form Validation**: The Basic Info step enforces strict validation rules (using the `Validators` utility) for required fields, email formatting, and 10-digit Indian mobile numbers before allowing the user to save.
- **Smart Editing**: Adapts its title and save logic seamlessly depending on whether a `ResumeModel` was passed in as an argument (Edit Mode) or if it is null (Create Mode).

## State Management
- Maintains local UI state for the current stepper index and temporary form data.
- Upon successful validation and submission, it constructs a complete `ResumeModel` and calls either `addResume` or `updateResume` on the `ResumeProvider`.
