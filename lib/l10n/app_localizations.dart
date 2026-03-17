import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// The app name
  ///
  /// In en, this message translates to:
  /// **'GymFit Pro'**
  String get appName;

  /// Bottom nav label
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discover;

  /// Bottom nav label
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// Bottom nav label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Search bar hint
  ///
  /// In en, this message translates to:
  /// **'Search gyms...'**
  String get searchHint;

  /// Empty state title
  ///
  /// In en, this message translates to:
  /// **'No Gyms Found'**
  String get noGymsFound;

  /// Empty state description
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or filters, or add a new gym.'**
  String get noGymsDescription;

  /// Add gym button
  ///
  /// In en, this message translates to:
  /// **'Add Gym'**
  String get addGym;

  /// Edit gym title
  ///
  /// In en, this message translates to:
  /// **'Edit Gym'**
  String get editGym;

  /// Delete gym button
  ///
  /// In en, this message translates to:
  /// **'Delete Gym'**
  String get deleteGym;

  /// Delete confirmation title
  ///
  /// In en, this message translates to:
  /// **'Delete Gym?'**
  String get deleteConfirmTitle;

  /// Delete confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this gym? This action cannot be undone.'**
  String get deleteConfirmMessage;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Success message
  ///
  /// In en, this message translates to:
  /// **'Gym added successfully'**
  String get gymAddedSuccess;

  /// Success message
  ///
  /// In en, this message translates to:
  /// **'Gym updated successfully'**
  String get gymUpdatedSuccess;

  /// Success message
  ///
  /// In en, this message translates to:
  /// **'Gym deleted successfully'**
  String get gymDeletedSuccess;

  /// Generic error
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get errorOccurred;

  /// Validation error
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// Validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmail;

  /// Validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get invalidPhone;

  /// Validation error
  ///
  /// In en, this message translates to:
  /// **'Rating must be between 0 and 5'**
  String get invalidRating;

  /// Login title
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// Login subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// Sign in button
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Sign up button
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Sign out button
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Google sign in button
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Sign up prompt
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// Sign in prompt
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get hasAccount;

  /// Create account button
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Guest mode button
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// Forgot password link
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Reset password dialog title
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// Reset password hint
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get enterEmailAddress;

  /// Reset password success
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent'**
  String get passwordResetSent;

  /// Send button
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// Validation error
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Signup title
  ///
  /// In en, this message translates to:
  /// **'Join GymFit Pro'**
  String get joinApp;

  /// Signup subtitle
  ///
  /// In en, this message translates to:
  /// **'Create an account to sync your data'**
  String get createAccountSubtitle;

  /// Divider text
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// Reviews section title
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// Empty reviews message
  ///
  /// In en, this message translates to:
  /// **'No reviews yet. Be the first!'**
  String get noReviewsYet;

  /// Write review button
  ///
  /// In en, this message translates to:
  /// **'Write a Review'**
  String get writeReview;

  /// Submit button
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// Rating label
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// Comment label
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// Review comment hint
  ///
  /// In en, this message translates to:
  /// **'Share your experience...'**
  String get shareExperience;

  /// Review success message
  ///
  /// In en, this message translates to:
  /// **'Review added!'**
  String get reviewAdded;

  /// Auth required for review
  ///
  /// In en, this message translates to:
  /// **'Please sign in to write a review'**
  String get pleaseSignInToReview;

  /// Error state title
  ///
  /// In en, this message translates to:
  /// **'Oops! Something went wrong'**
  String get oopsError;

  /// Retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Filter chip all
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// About section title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Contact section title
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// Phone label
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// Facilities section title
  ///
  /// In en, this message translates to:
  /// **'Premium Facilities'**
  String get premiumFacilities;

  /// Statistics section title
  ///
  /// In en, this message translates to:
  /// **'Peak Hours Analytics'**
  String get peakHoursAnalytics;

  /// Theme setting label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Light theme label
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// Dark theme label
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// System theme label
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Language setting title
  ///
  /// In en, this message translates to:
  /// **'Language / Ngôn ngữ'**
  String get languageName;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Vietnamese language name
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnamese;

  /// App version label
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// Sign out success message
  ///
  /// In en, this message translates to:
  /// **'Signed out successfully'**
  String get signedOutSuccess;

  /// Unauthenticated title
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account'**
  String get signInToAccount;

  /// Unauthenticated subtitle
  ///
  /// In en, this message translates to:
  /// **'Sync your favorites and data across devices'**
  String get syncFavorites;

  /// Member since date
  ///
  /// In en, this message translates to:
  /// **'Member since {date}'**
  String memberSince(String date);

  /// Fallback when no email
  ///
  /// In en, this message translates to:
  /// **'No email'**
  String get noEmail;

  /// Stats card label
  ///
  /// In en, this message translates to:
  /// **'FAVORITES'**
  String get favoritesCount;

  /// Stats card label
  ///
  /// In en, this message translates to:
  /// **'SYNC STATUS'**
  String get syncStatus;

  /// Sync status
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get synced;

  /// Sync in progress
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get syncing;

  /// Form section header
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// Form field label
  ///
  /// In en, this message translates to:
  /// **'Gym Name *'**
  String get gymName;

  /// Form field label
  ///
  /// In en, this message translates to:
  /// **'Address *'**
  String get address;

  /// Description label
  ///
  /// In en, this message translates to:
  /// **'Description *'**
  String get description;

  /// Contact section title
  ///
  /// In en, this message translates to:
  /// **'Contact Info'**
  String get contactInfo;

  /// Form field label
  ///
  /// In en, this message translates to:
  /// **'Phone Number *'**
  String get phoneNumber;

  /// Details section title
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// Form field label
  ///
  /// In en, this message translates to:
  /// **'Email *'**
  String get emailField;

  /// Form field label
  ///
  /// In en, this message translates to:
  /// **'Image URL *'**
  String get imageUrl;

  /// Form field label
  ///
  /// In en, this message translates to:
  /// **'Rating (0-5) *'**
  String get ratingField;

  /// Form field label
  ///
  /// In en, this message translates to:
  /// **'Opening Hours *'**
  String get openingHours;

  /// Form field label
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitude;

  /// Form field label
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitude;

  /// Facilities section title
  ///
  /// In en, this message translates to:
  /// **'Facilities'**
  String get facilities;

  /// Statistics section title
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// Empty favorites title
  ///
  /// In en, this message translates to:
  /// **'No Favorites Yet'**
  String get noFavorites;

  /// Empty favorites description
  ///
  /// In en, this message translates to:
  /// **'Start exploring and save your favorite gyms!'**
  String get noFavoritesDescription;

  /// Discover gyms button
  ///
  /// In en, this message translates to:
  /// **'Discover Gyms'**
  String get discoverGyms;

  /// Onboarding page 1 title
  ///
  /// In en, this message translates to:
  /// **'Discover Gyms'**
  String get onboardingTitle1;

  /// Onboarding page 1 description
  ///
  /// In en, this message translates to:
  /// **'Find the best premium fitness centers and boutique studios near you with detailed information.'**
  String get onboardingDesc1;

  /// Onboarding page 2 title
  ///
  /// In en, this message translates to:
  /// **'Save Favorites'**
  String get onboardingTitle2;

  /// Onboarding page 2 description
  ///
  /// In en, this message translates to:
  /// **'Create your personal collection of top-rated gyms for quick access anytime.'**
  String get onboardingDesc2;

  /// Onboarding page 3 title
  ///
  /// In en, this message translates to:
  /// **'Sync Across Devices'**
  String get onboardingTitle3;

  /// Onboarding page 3 description
  ///
  /// In en, this message translates to:
  /// **'Your data and favorites are automatically backed up and synced everywhere.'**
  String get onboardingDesc3;

  /// Skip button
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Next button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Get started button
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Error title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Error when gym data missing
  ///
  /// In en, this message translates to:
  /// **'Gym data not available.'**
  String get gymDataNotAvailable;

  /// 404 error message
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get pageNotFound;

  /// AI tab label
  ///
  /// In en, this message translates to:
  /// **'AI'**
  String get aiAssistant;

  /// Chat input hint
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessage;

  /// Loading text
  ///
  /// In en, this message translates to:
  /// **'AI is thinking...'**
  String get aiThinking;

  /// AI welcome message
  ///
  /// In en, this message translates to:
  /// **'Ask me anything about gym, workout plans, or nutrition! I\'m here to help you reach your fitness goals 💪'**
  String get aiWelcomeMessage;

  /// Recommendations screen title
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendations;

  /// Recommendations header
  ///
  /// In en, this message translates to:
  /// **'Recommended for You'**
  String get recommendedForYou;

  /// Recommendations button
  ///
  /// In en, this message translates to:
  /// **'Get AI Recommendations'**
  String get getRecommendations;

  /// Quick suggestion 1
  ///
  /// In en, this message translates to:
  /// **'Suggest a workout plan for beginners 🏋️'**
  String get aiSuggestion1;

  /// Quick suggestion 2
  ///
  /// In en, this message translates to:
  /// **'Best gyms near me? 📍'**
  String get aiSuggestion2;

  /// Quick suggestion 3
  ///
  /// In en, this message translates to:
  /// **'Nutrition tips for muscle gain 🥩'**
  String get aiSuggestion3;

  /// Quick suggestion 4
  ///
  /// In en, this message translates to:
  /// **'How to choose the right gym? 🤔'**
  String get aiSuggestion4;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
