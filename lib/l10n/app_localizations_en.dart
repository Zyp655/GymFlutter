// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'GymFit Pro';

  @override
  String get discover => 'Discover';

  @override
  String get favorites => 'Favorites';

  @override
  String get profile => 'Profile';

  @override
  String get searchHint => 'Search gyms...';

  @override
  String get noGymsFound => 'No Gyms Found';

  @override
  String get noGymsDescription =>
      'Try adjusting your search or filters, or add a new gym.';

  @override
  String get addGym => 'Add Gym';

  @override
  String get editGym => 'Edit Gym';

  @override
  String get deleteGym => 'Delete Gym';

  @override
  String get deleteConfirmTitle => 'Delete Gym?';

  @override
  String get deleteConfirmMessage =>
      'Are you sure you want to delete this gym? This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get gymAddedSuccess => 'Gym added successfully';

  @override
  String get gymUpdatedSuccess => 'Gym updated successfully';

  @override
  String get gymDeletedSuccess => 'Gym deleted successfully';

  @override
  String get errorOccurred => 'An error occurred. Please try again.';

  @override
  String get requiredField => 'This field is required';

  @override
  String get invalidEmail => 'Please enter a valid email address';

  @override
  String get invalidPhone => 'Please enter a valid phone number';

  @override
  String get invalidRating => 'Rating must be between 0 and 5';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInToContinue => 'Sign in to continue';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signOut => 'Sign Out';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get hasAccount => 'Already have an account?';

  @override
  String get createAccount => 'Create Account';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get enterEmailAddress => 'Enter your email address';

  @override
  String get passwordResetSent => 'Password reset email sent';

  @override
  String get send => 'Send';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get joinApp => 'Join GymFit Pro';

  @override
  String get createAccountSubtitle => 'Create an account to sync your data';

  @override
  String get or => 'OR';

  @override
  String get reviews => 'Reviews';

  @override
  String get noReviewsYet => 'No reviews yet. Be the first!';

  @override
  String get writeReview => 'Write a Review';

  @override
  String get submit => 'Submit';

  @override
  String get rating => 'Rating';

  @override
  String get comment => 'Comment';

  @override
  String get shareExperience => 'Share your experience...';

  @override
  String get reviewAdded => 'Review added!';

  @override
  String get pleaseSignInToReview => 'Please sign in to write a review';

  @override
  String get oopsError => 'Oops! Something went wrong';

  @override
  String get retry => 'Retry';

  @override
  String get all => 'All';

  @override
  String get about => 'About';

  @override
  String get contactInformation => 'Contact Information';

  @override
  String get phone => 'Phone';

  @override
  String get premiumFacilities => 'Premium Facilities';

  @override
  String get peakHoursAnalytics => 'Peak Hours Analytics';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get language => 'Language';

  @override
  String get languageName => 'Language / Ngôn ngữ';

  @override
  String get english => 'English';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get appVersion => 'App Version';

  @override
  String get signedOutSuccess => 'Signed out successfully';

  @override
  String get signInToAccount => 'Sign in to your account';

  @override
  String get syncFavorites => 'Sync your favorites and data across devices';

  @override
  String memberSince(String date) {
    return 'Member since $date';
  }

  @override
  String get noEmail => 'No email';

  @override
  String get favoritesCount => 'FAVORITES';

  @override
  String get syncStatus => 'SYNC STATUS';

  @override
  String get synced => 'Synced';

  @override
  String get syncing => 'Syncing...';

  @override
  String get basicInformation => 'Basic Information';

  @override
  String get gymName => 'Gym Name *';

  @override
  String get address => 'Address *';

  @override
  String get description => 'Description *';

  @override
  String get contactInfo => 'Contact Info';

  @override
  String get phoneNumber => 'Phone Number *';

  @override
  String get details => 'Details';

  @override
  String get emailField => 'Email *';

  @override
  String get imageUrl => 'Image URL *';

  @override
  String get ratingField => 'Rating (0-5) *';

  @override
  String get openingHours => 'Opening Hours *';

  @override
  String get latitude => 'Latitude';

  @override
  String get longitude => 'Longitude';

  @override
  String get facilities => 'Facilities';

  @override
  String get statistics => 'Statistics';

  @override
  String get noFavorites => 'No Favorites Yet';

  @override
  String get noFavoritesDescription =>
      'Start exploring and save your favorite gyms!';

  @override
  String get discoverGyms => 'Discover Gyms';

  @override
  String get onboardingTitle1 => 'Discover Gyms';

  @override
  String get onboardingDesc1 =>
      'Find the best premium fitness centers and boutique studios near you with detailed information.';

  @override
  String get onboardingTitle2 => 'Save Favorites';

  @override
  String get onboardingDesc2 =>
      'Create your personal collection of top-rated gyms for quick access anytime.';

  @override
  String get onboardingTitle3 => 'Sync Across Devices';

  @override
  String get onboardingDesc3 =>
      'Your data and favorites are automatically backed up and synced everywhere.';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get error => 'Error';

  @override
  String get gymDataNotAvailable => 'Gym data not available.';

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get aiAssistant => 'AI';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get aiThinking => 'AI is thinking...';

  @override
  String get aiWelcomeMessage =>
      'Ask me anything about gym, workout plans, or nutrition! I\'m here to help you reach your fitness goals 💪';

  @override
  String get recommendations => 'Recommendations';

  @override
  String get recommendedForYou => 'Recommended for You';

  @override
  String get getRecommendations => 'Get AI Recommendations';

  @override
  String get aiSuggestion1 => 'Suggest a workout plan for beginners 🏋️';

  @override
  String get aiSuggestion2 => 'Best gyms near me? 📍';

  @override
  String get aiSuggestion3 => 'Nutrition tips for muscle gain 🥩';

  @override
  String get aiSuggestion4 => 'How to choose the right gym? 🤔';
}
