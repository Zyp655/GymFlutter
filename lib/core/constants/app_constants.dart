class AppConstants {
  AppConstants._();

  static const String databaseName = 'gym_discovery.db';

  static const String gymTable = 'gyms';
  static const String reviewTable = 'reviews';

  static const String colId = 'id';
  static const String colName = 'name';
  static const String colAddress = 'address';
  static const String colPhoneNumber = 'phone_number';
  static const String colEmail = 'email';
  static const String colDescription = 'description';
  static const String colImageUrl = 'image_url';
  static const String colRating = 'rating';
  static const String colLatitude = 'latitude';
  static const String colLongitude = 'longitude';
  static const String colOpeningHours = 'opening_hours';
  static const String colFacilities = 'facilities';
  static const String colCreatedAt = 'created_at';
  static const String colCreatedBy = 'created_by';
  static const String colUpdatedAt = 'updated_at';

  static const String keyThemeMode = 'theme_mode';
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyUserId = 'user_id';

  static const String appName = 'Gym Discovery';
  static const String noGymsFound = 'No gyms found';
  static const String searchHint = 'Search gyms...';
  static const String addGym = 'Add Gym';
  static const String editGym = 'Edit Gym';
  static const String deleteGym = 'Delete Gym';
  static const String deleteConfirmTitle = 'Delete Gym?';
  static const String deleteConfirmMessage =
      'Are you sure you want to delete this gym? This action cannot be undone.';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String save = 'Save';
  static const String gymAddedSuccess = 'Gym added successfully';
  static const String gymUpdatedSuccess = 'Gym updated successfully';
  static const String gymDeletedSuccess = 'Gym deleted successfully';
  static const String errorOccurred = 'An error occurred. Please try again.';

  static const String requiredField = 'This field is required';
  static const String invalidEmail = 'Please enter a valid email address';
  static const String invalidPhone = 'Please enter a valid phone number';
  static const String invalidRating = 'Rating must be between 0 and 5';
}
