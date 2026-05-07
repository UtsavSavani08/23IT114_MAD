# Application Detail Screen

**File**: `lib/features/application/presentation/screens/application_detail_screen.dart`

## Overview
The `ApplicationDetailScreen` offers a deep, comprehensive view of a specific job application. It serves as the primary interface for users to review their submission details, update the hiring status as they progress through interview stages, and access the exact resume they used to apply.

## Key Features
- **Header Card**: Prominently displays the target Job Role, Company Name, and automatically generated `applicationId` alongside a dynamically colored company avatar.
- **Status Tracker & Updater**: 
  - Visually displays the current standing of the application using the globally themed `StatusBadge`.
  - Features an "Update Status" button that triggers a frictionless Bottom Sheet. This allows users to rapidly transition the application between `Applied`, `Shortlisted`, `Interview`, `Rejected`, or `Selected` states.
- **Timeline Information**: Clearly lists both the original Date Applied and the timestamp of the Last Update, formatted nicely using the `DateFormatter` utility.
- **Resume Deep Linking**: Renders a dedicated card identifying the specific `ResumeModel` tied to this application. Tapping this card uses deep linking to instantly navigate the user to the `ResumeBuilderScreen` to review that exact resume version.
- **Contextual Data**: Displays the external Job URL and any custom interview notes if they were provided during entry.

## State Management
- Utilizes `context.watch<ApplicationProvider>()` to ensure the screen automatically re-renders if the underlying application data changes (e.g., if the user updates the status via the bottom sheet or edits details via the `ApplicationEntryScreen`).
