# Resume List Screen

**File**: `lib/features/resume/presentation/screens/resume_list_screen.dart`

## Overview
The `ResumeListScreen` is the primary interface for users to view, manage, and access their various resume profiles. It allows users to maintain multiple versions of their resume tailored for different job roles.

## Key Features
- **List View**: Displays all saved resumes using the custom `ResumeCard` widget.
- **Empty State Handling**: If the user has not created any resumes yet, it elegantly displays an `EmptyStateWidget` providing a helpful message and a call-to-action button to create their first resume.
- **Loading State**: Features a skeleton loading animation (`LoadingShimmer`) to improve perceived performance while data is being fetched from the local Hive database.
- **Floating Action Button**: A primary action button prominently displayed to quickly navigate to the `ResumeBuilderScreen` for creating a new resume from scratch.

## Interactions
- Tapping a `ResumeCard` navigates to the `ResumeBuilderScreen` in edit mode, allowing the user to modify the selected resume.
- Long-pressing a `ResumeCard` opens a bottom sheet with quick actions:
  - **Duplicate**: Clones the resume, instantly creating a new editable copy.
  - **Delete**: Prompts a confirmation dialog to permanently remove the resume.
- Swiping a `ResumeCard` from right to left reveals a quick-delete action via `flutter_slidable`.

## State Management
- Directly consumes the `ResumeProvider` to read the list of `ResumeModel`s and automatically rebuilds the list whenever a resume is added, duplicated, modified, or deleted.
