# Application Entry Screen

**File**: `lib/features/application/presentation/screens/application_entry_screen.dart`

## Overview
The `ApplicationEntryScreen` provides a robust data entry form for users to log new job applications or edit existing ones. It securely binds a job application to a specific version of a user's resume, maintaining an accurate historical record of what was submitted to which employer.

## Key Features
- **Core Information**: Collects the essential details of a job application: Company Name, Job Role, and an optional URL linking to the original job posting.
- **Resume Linking**: Features a smart Dropdown menu that reads from the `ResumeProvider`. This forces the user to select exactly which `ResumeModel` was submitted for this specific application, allowing for accurate tracking of tailored resumes.
- **Date Tracking**: Integrates the native Material `showDatePicker` to accurately log the exact date the application was submitted.
- **Notes Field**: Provides a multi-line text area for users to jot down specific requirements, recruiter names, or interview hints.
- **Dynamic Mode**: Acts as both the "Create" and "Edit" screen. When editing an existing application, it seamlessly pre-fills all controllers and preserves the unique `applicationId` and creation timestamps.

## State Management
- Validates all input using the centralized `Validators` utility class.
- Upon successful validation, it constructs an `ApplicationModel`.
- Directly interacts with the `ApplicationProvider` to invoke either `addApplication` or `updateApplication`. The provider automatically flags the change for background synchronization.
