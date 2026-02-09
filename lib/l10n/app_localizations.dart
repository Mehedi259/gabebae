import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

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
    Locale('es'),
    Locale('fr')
  ];

  /// No description provided for @letsBegin.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Begin ✨'**
  String get letsBegin;

  /// No description provided for @heyThere.
  ///
  /// In en, this message translates to:
  /// **'Hey there, beautiful soul'**
  String get heyThere;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Menu Sidekick!\nYour pocket-friendly foodie guide\nthat makes eating out simple,\nsafe, and joyful.'**
  String get welcomeMessage;

  /// No description provided for @menuSidekick.
  ///
  /// In en, this message translates to:
  /// **'Menu\nSidekick'**
  String get menuSidekick;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @preferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Preferred Language'**
  String get preferredLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get spanish;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get french;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signInWithApple.
  ///
  /// In en, this message translates to:
  /// **'Sign In with Apple'**
  String get signInWithApple;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign In with Google'**
  String get signInWithGoogle;

  /// No description provided for @signInWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Sign In with Email'**
  String get signInWithEmail;

  /// No description provided for @byContinuing.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to Menu Sidekick\'s '**
  String get byContinuing;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @enterVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Verification Code'**
  String get enterVerificationCode;

  /// No description provided for @codeSentToEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter the code that was sent to your email.'**
  String get codeSentToEmail;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @didntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code? '**
  String get didntReceiveCode;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @pleaseEnterCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter 4 digit code'**
  String get pleaseEnterCode;

  /// No description provided for @termsOfConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms of Conditions'**
  String get termsOfConditions;

  /// No description provided for @yourSafetyPriority.
  ///
  /// In en, this message translates to:
  /// **'✨ Your Safety is Our Priority ✨'**
  String get yourSafetyPriority;

  /// No description provided for @safetyMessage.
  ///
  /// In en, this message translates to:
  /// **'Menu Sidekick helps guide your food choices 🌿 but it may not always be perfect. Ingredients and recipes can change anytime.\n\n⚠️ Always double-check ⚠️\n\nAsk your server or restaurant before ordering, especially if you have allergies. This app is for information only 💛 — not medical advice or a guarantee of safety.'**
  String get safetyMessage;

  /// No description provided for @agreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to Menu Sidekick\'s '**
  String get agreeToTerms;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @agreeToPrivacy.
  ///
  /// In en, this message translates to:
  /// **'I agree to Menu Sidekick\'s '**
  String get agreeToPrivacy;

  /// No description provided for @imReady.
  ///
  /// In en, this message translates to:
  /// **'I\'m Ready 💛'**
  String get imReady;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How It Works ✨'**
  String get howItWorks;

  /// No description provided for @scanMenuMessage.
  ///
  /// In en, this message translates to:
  /// **'Simply scan any menu and see\nwhat\'s right for you'**
  String get scanMenuMessage;

  /// No description provided for @personalizedMessage.
  ///
  /// In en, this message translates to:
  /// **'Personalized for your diet, allergies, and\nhealth 🌿 — even across languages 🌎'**
  String get personalizedMessage;

  /// No description provided for @step1Of5.
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 5'**
  String get step1Of5;

  /// No description provided for @step2Of5.
  ///
  /// In en, this message translates to:
  /// **'Step 2 of 5'**
  String get step2Of5;

  /// No description provided for @step3Of5.
  ///
  /// In en, this message translates to:
  /// **'Step 3 of 5'**
  String get step3Of5;

  /// No description provided for @step4Of5.
  ///
  /// In en, this message translates to:
  /// **'Step 4 of 5'**
  String get step4Of5;

  /// No description provided for @step5Of5.
  ///
  /// In en, this message translates to:
  /// **'Step 5 of 5'**
  String get step5Of5;

  /// No description provided for @whatsYourEatingStyle.
  ///
  /// In en, this message translates to:
  /// **'What\'s your eating style?'**
  String get whatsYourEatingStyle;

  /// No description provided for @pickDiet.
  ///
  /// In en, this message translates to:
  /// **'Pick one or more diet that sounds like you'**
  String get pickDiet;

  /// No description provided for @nextUp.
  ///
  /// In en, this message translates to:
  /// **'Next Up ✨'**
  String get nextUp;

  /// No description provided for @anythingToAvoid.
  ///
  /// In en, this message translates to:
  /// **'Anything we should avoid for you?'**
  String get anythingToAvoid;

  /// No description provided for @keepYouSafe.
  ///
  /// In en, this message translates to:
  /// **'We\'ll keep you safe & worry-free.'**
  String get keepYouSafe;

  /// No description provided for @looksGood.
  ///
  /// In en, this message translates to:
  /// **'Looks good 😊'**
  String get looksGood;

  /// No description provided for @watchOutHealthNeeds.
  ///
  /// In en, this message translates to:
  /// **'Should we watch out for any health needs?'**
  String get watchOutHealthNeeds;

  /// No description provided for @gotYourBack.
  ///
  /// In en, this message translates to:
  /// **'We\'ve got your back, always ✨'**
  String get gotYourBack;

  /// No description provided for @allSetHere.
  ///
  /// In en, this message translates to:
  /// **'All set here 💛'**
  String get allSetHere;

  /// No description provided for @magicList.
  ///
  /// In en, this message translates to:
  /// **'✨ Here\'s the magic list ✨'**
  String get magicList;

  /// No description provided for @magicListSubtitle.
  ///
  /// In en, this message translates to:
  /// **'These are all the ingredients we\'re watching for you — switch on or off anytime 🌿'**
  String get magicListSubtitle;

  /// No description provided for @readyToGlow.
  ///
  /// In en, this message translates to:
  /// **'Ready to Glow ✨'**
  String get readyToGlow;

  /// No description provided for @allSetLovely.
  ///
  /// In en, this message translates to:
  /// **'🌸 All set, lovely!'**
  String get allSetLovely;

  /// No description provided for @diningReadyMessage.
  ///
  /// In en, this message translates to:
  /// **'Your dining sidekick is ready to watch out for you. Just tell us your name and choose an avatar that makes you smile ✨'**
  String get diningReadyMessage;

  /// No description provided for @whatToCallYou.
  ///
  /// In en, this message translates to:
  /// **'🌸 What should we call you?'**
  String get whatToCallYou;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @chooseAvatar.
  ///
  /// In en, this message translates to:
  /// **'Choose Avatar'**
  String get chooseAvatar;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload a Photo'**
  String get uploadPhoto;

  /// No description provided for @addAnotherProfile.
  ///
  /// In en, this message translates to:
  /// **'+ Add Another Profile'**
  String get addAnotherProfile;

  /// No description provided for @letsEat.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Eat 🌿'**
  String get letsEat;

  /// No description provided for @unlockingSidekick.
  ///
  /// In en, this message translates to:
  /// **'✨ Unlocking your Sidekick\'s Superpowers... ✨'**
  String get unlockingSidekick;

  /// No description provided for @personalShield.
  ///
  /// In en, this message translates to:
  /// **'🦸‍♀️ Personal Shield → Protects you from foods that don\'t fit your diet, allergies, or health 🌿'**
  String get personalShield;

  /// No description provided for @ingredientXray.
  ///
  /// In en, this message translates to:
  /// **'🥦 Ingredient X-Ray Vision → Spots 5,000+ hidden ingredients at a glance'**
  String get ingredientXray;

  /// No description provided for @menuScanVision.
  ///
  /// In en, this message translates to:
  /// **'📸 Menu Scan Vision → Activating camera, PDF & URL scanning'**
  String get menuScanVision;

  /// No description provided for @globalTranslator.
  ///
  /// In en, this message translates to:
  /// **'🌎 Global Translator → Reads menus in 20+ languages, no passport required.'**
  String get globalTranslator;

  /// No description provided for @aiWisdom.
  ///
  /// In en, this message translates to:
  /// **'🤖 AI Wisdom → Powering up tips, swaps & safe suggestions'**
  String get aiWisdom;

  /// No description provided for @readyToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Ready to get started?'**
  String get readyToGetStarted;

  /// No description provided for @agreeTermsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'I agree to Menu Sidekick\'s {terms} and {privacy}. I understand that I should always verify ingredient and allergen information, especially if I have a serious food allergy. Any disputes shall be resolved through binding arbitration.'**
  String agreeTermsPrivacy(String terms, String privacy);

  /// No description provided for @verificationDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'. I understand that I should always verify ingredient and allergen information, especially if I have a serious food allergy. Any disputes shall be resolved through binding arbitration.'**
  String get verificationDisclaimer;

  /// No description provided for @healthDriven.
  ///
  /// In en, this message translates to:
  /// **'Health-Driven'**
  String get healthDriven;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See More'**
  String get seeMore;

  /// No description provided for @vegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get vegan;

  /// No description provided for @plantBasedOnly.
  ///
  /// In en, this message translates to:
  /// **'Plant-based only'**
  String get plantBasedOnly;

  /// No description provided for @pescatarian.
  ///
  /// In en, this message translates to:
  /// **'Pescatarian'**
  String get pescatarian;

  /// No description provided for @fishVegetables.
  ///
  /// In en, this message translates to:
  /// **'Fish & vegetables'**
  String get fishVegetables;

  /// No description provided for @keto.
  ///
  /// In en, this message translates to:
  /// **'Keto'**
  String get keto;

  /// No description provided for @lowCarbHighFat.
  ///
  /// In en, this message translates to:
  /// **'Low carb, high fat'**
  String get lowCarbHighFat;

  /// No description provided for @paleo.
  ///
  /// In en, this message translates to:
  /// **'Paleo'**
  String get paleo;

  /// No description provided for @wholeFoodsOnly.
  ///
  /// In en, this message translates to:
  /// **'Whole foods only'**
  String get wholeFoodsOnly;

  /// No description provided for @glutenFree.
  ///
  /// In en, this message translates to:
  /// **'Gluten-Free'**
  String get glutenFree;

  /// No description provided for @noGluten.
  ///
  /// In en, this message translates to:
  /// **'No gluten'**
  String get noGluten;

  /// No description provided for @flexible.
  ///
  /// In en, this message translates to:
  /// **'Flexible'**
  String get flexible;

  /// No description provided for @balanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get balanced;

  /// No description provided for @strict.
  ///
  /// In en, this message translates to:
  /// **'Strict'**
  String get strict;

  /// No description provided for @varietyHealthy.
  ///
  /// In en, this message translates to:
  /// **'You enjoy variety while maintaining healthy choices'**
  String get varietyHealthy;

  /// No description provided for @flexitarian.
  ///
  /// In en, this message translates to:
  /// **'Flexitarian'**
  String get flexitarian;

  /// No description provided for @plantBasedOccasionalMeat.
  ///
  /// In en, this message translates to:
  /// **'Plant-based, occasional meat/fish'**
  String get plantBasedOccasionalMeat;

  /// No description provided for @whole30.
  ///
  /// In en, this message translates to:
  /// **'Whole30'**
  String get whole30;

  /// No description provided for @thirtyDayCleanEating.
  ///
  /// In en, this message translates to:
  /// **'30-day clean eating'**
  String get thirtyDayCleanEating;

  /// No description provided for @dash.
  ///
  /// In en, this message translates to:
  /// **'DASH'**
  String get dash;

  /// No description provided for @lowSaltHeartFriendly.
  ///
  /// In en, this message translates to:
  /// **'Low salt, heart-friendly'**
  String get lowSaltHeartFriendly;

  /// No description provided for @mediterranean.
  ///
  /// In en, this message translates to:
  /// **'Mediterranean'**
  String get mediterranean;

  /// No description provided for @oliveOilFishGrains.
  ///
  /// In en, this message translates to:
  /// **'Olive oil, fish, grains'**
  String get oliveOilFishGrains;

  /// No description provided for @lowFodmap.
  ///
  /// In en, this message translates to:
  /// **'Low-FODMAP'**
  String get lowFodmap;

  /// No description provided for @gutFriendlyCarbLimits.
  ///
  /// In en, this message translates to:
  /// **'Gut-friendly carb limits'**
  String get gutFriendlyCarbLimits;

  /// No description provided for @rawFood.
  ///
  /// In en, this message translates to:
  /// **'Raw Food'**
  String get rawFood;

  /// No description provided for @uncookedPlantBased.
  ///
  /// In en, this message translates to:
  /// **'Uncooked plant-based meals'**
  String get uncookedPlantBased;

  /// No description provided for @nuts.
  ///
  /// In en, this message translates to:
  /// **'Nuts'**
  String get nuts;

  /// No description provided for @dairy.
  ///
  /// In en, this message translates to:
  /// **'Dairy'**
  String get dairy;

  /// No description provided for @gluten.
  ///
  /// In en, this message translates to:
  /// **'Gluten'**
  String get gluten;

  /// No description provided for @shellfish.
  ///
  /// In en, this message translates to:
  /// **'Shellfish'**
  String get shellfish;

  /// No description provided for @egg.
  ///
  /// In en, this message translates to:
  /// **'Egg'**
  String get egg;

  /// No description provided for @salad.
  ///
  /// In en, this message translates to:
  /// **'Salad'**
  String get salad;

  /// No description provided for @onion.
  ///
  /// In en, this message translates to:
  /// **'Onion'**
  String get onion;

  /// No description provided for @banana.
  ///
  /// In en, this message translates to:
  /// **'Banana'**
  String get banana;

  /// No description provided for @pineapple.
  ///
  /// In en, this message translates to:
  /// **'Pineapple'**
  String get pineapple;

  /// No description provided for @mrBanana.
  ///
  /// In en, this message translates to:
  /// **'Mr.Banana'**
  String get mrBanana;

  /// No description provided for @diabetes.
  ///
  /// In en, this message translates to:
  /// **'Diabetes'**
  String get diabetes;

  /// No description provided for @type1OrType2.
  ///
  /// In en, this message translates to:
  /// **'Type 1 or Type 2'**
  String get type1OrType2;

  /// No description provided for @hypertension.
  ///
  /// In en, this message translates to:
  /// **'Hypertension'**
  String get hypertension;

  /// No description provided for @highBloodPressure.
  ///
  /// In en, this message translates to:
  /// **'High blood pressure'**
  String get highBloodPressure;

  /// No description provided for @highCholesterol.
  ///
  /// In en, this message translates to:
  /// **'High Cholesterol'**
  String get highCholesterol;

  /// No description provided for @elevatedLipidLevels.
  ///
  /// In en, this message translates to:
  /// **'Elevated lipid levels'**
  String get elevatedLipidLevels;

  /// No description provided for @celiacDisease.
  ///
  /// In en, this message translates to:
  /// **'Celiac Disease'**
  String get celiacDisease;

  /// No description provided for @glutenIntolerance.
  ///
  /// In en, this message translates to:
  /// **'Gluten intolerance'**
  String get glutenIntolerance;

  /// No description provided for @asthma.
  ///
  /// In en, this message translates to:
  /// **'Asthma'**
  String get asthma;

  /// No description provided for @chronicLungCondition.
  ///
  /// In en, this message translates to:
  /// **'Chronic lung condition'**
  String get chronicLungCondition;

  /// No description provided for @kidneyDisease.
  ///
  /// In en, this message translates to:
  /// **'Kidney Disease'**
  String get kidneyDisease;

  /// No description provided for @renalHealthSupport.
  ///
  /// In en, this message translates to:
  /// **'Renal health support'**
  String get renalHealthSupport;

  /// No description provided for @thyroidIssues.
  ///
  /// In en, this message translates to:
  /// **'Thyroid Issues'**
  String get thyroidIssues;

  /// No description provided for @hyperHypoThyroidism.
  ///
  /// In en, this message translates to:
  /// **'Hyper / Hypo thyroidism'**
  String get hyperHypoThyroidism;

  /// No description provided for @heartDisease.
  ///
  /// In en, this message translates to:
  /// **'Heart Disease'**
  String get heartDisease;

  /// No description provided for @cardiacHealth.
  ///
  /// In en, this message translates to:
  /// **'Cardiac health'**
  String get cardiacHealth;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @startFreeTrial.
  ///
  /// In en, this message translates to:
  /// **'Start your 3-day FREE trial to continue ✨'**
  String get startFreeTrial;

  /// No description provided for @startTrialButton.
  ///
  /// In en, this message translates to:
  /// **'Start My 3-Day Free Trial ✨'**
  String get startTrialButton;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @monthlyPrice.
  ///
  /// In en, this message translates to:
  /// **'\$4.99/mo'**
  String get monthlyPrice;

  /// No description provided for @yearlyPrice.
  ///
  /// In en, this message translates to:
  /// **'\$24.99/mo \n(\$29.99/year)'**
  String get yearlyPrice;

  /// No description provided for @noPaymentToday.
  ///
  /// In en, this message translates to:
  /// **'💛 No payment due today.'**
  String get noPaymentToday;

  /// No description provided for @threeDaysFree.
  ///
  /// In en, this message translates to:
  /// **'3 Days Free'**
  String get threeDaysFree;

  /// No description provided for @trialTerms.
  ///
  /// In en, this message translates to:
  /// **'3 days free, then \$29.99 per year. Cancel anytime during trial.'**
  String get trialTerms;

  /// No description provided for @congratsBeautifulSoul.
  ///
  /// In en, this message translates to:
  /// **'Congrats,\nBeautiful Soul!'**
  String get congratsBeautifulSoul;

  /// No description provided for @welcomeFamily.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the Menu Sidekick family—\nyour dining glow-up starts now! ✨'**
  String get welcomeFamily;

  /// No description provided for @shareWithFamily.
  ///
  /// In en, this message translates to:
  /// **'Share Menu Sidekick with\nFamily and Friends!'**
  String get shareWithFamily;

  /// No description provided for @mcontinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get mcontinue;

  /// No description provided for @continue_.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_;

  /// No description provided for @shareMessage.
  ///
  /// In en, this message translates to:
  /// **'🎉 I just joined Menu Sidekick! 🚀\nYour dining glow-up starts here – check it out now:\nhttps://menusidekick.app'**
  String get shareMessage;

  /// No description provided for @hiUser.
  ///
  /// In en, this message translates to:
  /// **'Hi, Switee'**
  String get hiUser;

  /// No description provided for @yourDiningProfile.
  ///
  /// In en, this message translates to:
  /// **'✨ Your Dining Profile ✨'**
  String get yourDiningProfile;

  /// No description provided for @diet.
  ///
  /// In en, this message translates to:
  /// **'Diet'**
  String get diet;

  /// No description provided for @dairyFree.
  ///
  /// In en, this message translates to:
  /// **'Dairy-Free'**
  String get dairyFree;

  /// No description provided for @allergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get allergies;

  /// No description provided for @peanuts.
  ///
  /// In en, this message translates to:
  /// **'Peanuts'**
  String get peanuts;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// No description provided for @diabetic.
  ///
  /// In en, this message translates to:
  /// **'Diabetic'**
  String get diabetic;

  /// No description provided for @shareQrCode.
  ///
  /// In en, this message translates to:
  /// **'Share Your Diet via QR Code'**
  String get shareQrCode;

  /// No description provided for @yourFavorites.
  ///
  /// In en, this message translates to:
  /// **'Your Favorites'**
  String get yourFavorites;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @recentScans.
  ///
  /// In en, this message translates to:
  /// **'Recent Scans'**
  String get recentScans;

  /// No description provided for @avocadoToast.
  ///
  /// In en, this message translates to:
  /// **'Avocado Toast'**
  String get avocadoToast;

  /// No description provided for @quinoaBowl.
  ///
  /// In en, this message translates to:
  /// **'Quinoa Bowl'**
  String get quinoaBowl;

  /// No description provided for @greenSmoothie.
  ///
  /// In en, this message translates to:
  /// **'Green Smoothie'**
  String get greenSmoothie;

  /// No description provided for @scannedOn.
  ///
  /// In en, this message translates to:
  /// **'Scanned On'**
  String get scannedOn;

  /// No description provided for @yourActivity.
  ///
  /// In en, this message translates to:
  /// **'Your Activity'**
  String get yourActivity;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @grilledSalmon.
  ///
  /// In en, this message translates to:
  /// **'Grilled Salmon'**
  String get grilledSalmon;

  /// No description provided for @healthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get healthy;

  /// No description provided for @safeItems.
  ///
  /// In en, this message translates to:
  /// **'Safe Items'**
  String get safeItems;

  /// No description provided for @notSafe.
  ///
  /// In en, this message translates to:
  /// **'Not Safe'**
  String get notSafe;

  /// No description provided for @bellaVistalItalian.
  ///
  /// In en, this message translates to:
  /// **'Bella Vistal Italian'**
  String get bellaVistalItalian;

  /// No description provided for @oceanBreezeSeafood.
  ///
  /// In en, this message translates to:
  /// **'Ocean Breeze Seafood'**
  String get oceanBreezeSeafood;

  /// No description provided for @burgerPlace.
  ///
  /// In en, this message translates to:
  /// **'Burger Place'**
  String get burgerPlace;

  /// No description provided for @goldenDragonAsian.
  ///
  /// In en, this message translates to:
  /// **'Golden Dragon Asian'**
  String get goldenDragonAsian;

  /// No description provided for @menuSidekickAI.
  ///
  /// In en, this message translates to:
  /// **'Menu Sidekick AI'**
  String get menuSidekickAI;

  /// No description provided for @chatWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Hey sunshine 👋, I\'m your Menu Sidekick — your foodie bestie who speaks fluent menu 🍽️...'**
  String get chatWelcomeMessage;

  /// No description provided for @chatExampleQuestion.
  ///
  /// In en, this message translates to:
  /// **'Is Tom Yum soup safe for me to eat?'**
  String get chatExampleQuestion;

  /// No description provided for @chatExampleResponse.
  ///
  /// In en, this message translates to:
  /// **'✨ Great choice! Tom Yum is naturally gluten-free 🌿\n\nIt\'s made with lemongrass, lime leaves, and chili. Perfect for your diet! 🌸'**
  String get chatExampleResponse;

  /// No description provided for @quickReplyButter.
  ///
  /// In en, this message translates to:
  /// **'🌿 Is it cooked in butter or oil?'**
  String get quickReplyButter;

  /// No description provided for @quickReplyVegan.
  ///
  /// In en, this message translates to:
  /// **'🌱 Can I make this vegan?'**
  String get quickReplyVegan;

  /// No description provided for @quickReplyAvoid.
  ///
  /// In en, this message translates to:
  /// **'❓ What should I avoid here?'**
  String get quickReplyAvoid;

  /// No description provided for @askAnything.
  ///
  /// In en, this message translates to:
  /// **'Ask me anything about your meal...'**
  String get askAnything;

  /// No description provided for @newChat.
  ///
  /// In en, this message translates to:
  /// **'New Chat'**
  String get newChat;

  /// No description provided for @searchChats.
  ///
  /// In en, this message translates to:
  /// **'Search chats...'**
  String get searchChats;

  /// No description provided for @deleteThisChat.
  ///
  /// In en, this message translates to:
  /// **'Delete This Chat'**
  String get deleteThisChat;

  /// No description provided for @deleteChatConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this conversation?'**
  String get deleteChatConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @chatDeleted.
  ///
  /// In en, this message translates to:
  /// **'Chat deleted'**
  String get chatDeleted;

  /// No description provided for @italianDinnerPlanning.
  ///
  /// In en, this message translates to:
  /// **'Italian Dinner Planning'**
  String get italianDinnerPlanning;

  /// No description provided for @pastaRecipesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Need help with pasta recipes and wine pairing...'**
  String get pastaRecipesSubtitle;

  /// No description provided for @wheatAlternativesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Looking for alternatives to wheat-based...'**
  String get wheatAlternativesSubtitle;

  /// No description provided for @chatResponseExample.
  ///
  /// In en, this message translates to:
  /// **'That\'s a great question! Let me help you with that. Based on your dietary preferences, I\'d recommend...'**
  String get chatResponseExample;

  /// No description provided for @alaCarte.
  ///
  /// In en, this message translates to:
  /// **'À la carte'**
  String get alaCarte;

  /// No description provided for @myQRCode.
  ///
  /// In en, this message translates to:
  /// **'My QR Code'**
  String get myQRCode;

  /// No description provided for @scanQRDescription.
  ///
  /// In en, this message translates to:
  /// **'Scan this to view my dietary preferences & safe meals.'**
  String get scanQRDescription;

  /// No description provided for @shareQRCode.
  ///
  /// In en, this message translates to:
  /// **'Share QR Code'**
  String get shareQRCode;

  /// No description provided for @shareQRMessage.
  ///
  /// In en, this message translates to:
  /// **'Check out my dietary preferences and safe meals: {url}'**
  String shareQRMessage(Object url);

  /// No description provided for @shareQRSubject.
  ///
  /// In en, this message translates to:
  /// **'My Menu Sidekick QR Code'**
  String get shareQRSubject;

  /// No description provided for @qrCodeSharedSuccess.
  ///
  /// In en, this message translates to:
  /// **'QR Code shared successfully!'**
  String get qrCodeSharedSuccess;

  /// No description provided for @qrCodeLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'QR Code link copied to clipboard!'**
  String get qrCodeLinkCopied;

  /// No description provided for @yourMealResults.
  ///
  /// In en, this message translates to:
  /// **'🍽️ Your Meal Results'**
  String get yourMealResults;

  /// No description provided for @quickPdfView.
  ///
  /// In en, this message translates to:
  /// **'Quick\nPDF View'**
  String get quickPdfView;

  /// No description provided for @safe.
  ///
  /// In en, this message translates to:
  /// **'Safe'**
  String get safe;

  /// No description provided for @modify.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Modify'**
  String get modify;

  /// No description provided for @avoid.
  ///
  /// In en, this message translates to:
  /// **'❌ Avoid'**
  String get avoid;

  /// No description provided for @alaCarteMode.
  ///
  /// In en, this message translates to:
  /// **'✨ À La Carte Mode'**
  String get alaCarteMode;

  /// No description provided for @tips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tips;

  /// No description provided for @askAiChatAboutThis.
  ///
  /// In en, this message translates to:
  /// **'Ask AI Chat About This'**
  String get askAiChatAboutThis;

  /// No description provided for @grilledChickenSalad.
  ///
  /// In en, this message translates to:
  /// **'Grilled Chicken Salad'**
  String get grilledChickenSalad;

  /// No description provided for @grilledChickenSaladSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Salade de Poulet Grillé'**
  String get grilledChickenSaladSubtitle;

  /// No description provided for @alignedAndGlowing.
  ///
  /// In en, this message translates to:
  /// **'Aligned and glowing — this meal\'s an exact match! 🌿'**
  String get alignedAndGlowing;

  /// No description provided for @tipOliveOil.
  ///
  /// In en, this message translates to:
  /// **'💡 Use olive oil instead of palm oil'**
  String get tipOliveOil;

  /// No description provided for @vegetableStirFry.
  ///
  /// In en, this message translates to:
  /// **'Vegetable Stir Fry'**
  String get vegetableStirFry;

  /// No description provided for @vegetableStirFrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Légumes Sautés'**
  String get vegetableStirFrySubtitle;

  /// No description provided for @almostSafeTweak.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Almost safe, just tweak it a little ✨\n💡 Skip spicy → Safe 🌿'**
  String get almostSafeTweak;

  /// No description provided for @quinoaBuddha.
  ///
  /// In en, this message translates to:
  /// **'Quinoa Buddha Bowl'**
  String get quinoaBuddha;

  /// No description provided for @quinoaBuddhaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Bol de Bouddha au Quinoa'**
  String get quinoaBuddhaSubtitle;

  /// No description provided for @perfectPowerBowl.
  ///
  /// In en, this message translates to:
  /// **'Perfect power bowl — great for muscle recovery 💪'**
  String get perfectPowerBowl;

  /// No description provided for @paneerTikka.
  ///
  /// In en, this message translates to:
  /// **'Paneer Tikka'**
  String get paneerTikka;

  /// No description provided for @paneerTikkaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tikka de Paneer'**
  String get paneerTikkaSubtitle;

  /// No description provided for @considerReplacing.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Consider replacing paneer with tofu for a lighter option.'**
  String get considerReplacing;

  /// No description provided for @cheesyPasta.
  ///
  /// In en, this message translates to:
  /// **'Cheesy Pasta'**
  String get cheesyPasta;

  /// No description provided for @cheesyPastaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pâtes au Fromage'**
  String get cheesyPastaSubtitle;

  /// No description provided for @notAMatch.
  ///
  /// In en, this message translates to:
  /// **'Not a match for you, lovely 💛'**
  String get notAMatch;

  /// No description provided for @deepFriedSnacks.
  ///
  /// In en, this message translates to:
  /// **'Deep Fried Snacks'**
  String get deepFriedSnacks;

  /// No description provided for @deepFriedSnacksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Snacks Frits'**
  String get deepFriedSnacksSubtitle;

  /// No description provided for @avoidThisMeal.
  ///
  /// In en, this message translates to:
  /// **'❌ Avoid this meal for a lighter, healthier day.'**
  String get avoidThisMeal;

  /// No description provided for @tagGlutenFree.
  ///
  /// In en, this message translates to:
  /// **'🌱 Gluten-Free'**
  String get tagGlutenFree;

  /// No description provided for @tagDairyFree.
  ///
  /// In en, this message translates to:
  /// **'🥛 Dairy-Free'**
  String get tagDairyFree;

  /// No description provided for @tagVegan.
  ///
  /// In en, this message translates to:
  /// **'🌱 Vegan'**
  String get tagVegan;

  /// No description provided for @tagHighProtein.
  ///
  /// In en, this message translates to:
  /// **'💪 High-Protein'**
  String get tagHighProtein;

  /// No description provided for @tagSpicy.
  ///
  /// In en, this message translates to:
  /// **'🌶️ Spicy'**
  String get tagSpicy;

  /// No description provided for @tagDairy.
  ///
  /// In en, this message translates to:
  /// **'🥛 Dairy'**
  String get tagDairy;

  /// No description provided for @tagVegetarian.
  ///
  /// In en, this message translates to:
  /// **'🌱 Vegetarian'**
  String get tagVegetarian;

  /// No description provided for @tagGluten.
  ///
  /// In en, this message translates to:
  /// **'🌾 Gluten'**
  String get tagGluten;

  /// No description provided for @tagDeepFried.
  ///
  /// In en, this message translates to:
  /// **'🍟 Deep-Fried'**
  String get tagDeepFried;

  /// No description provided for @tagHighOil.
  ///
  /// In en, this message translates to:
  /// **'🍳 High-Oil'**
  String get tagHighOil;

  /// No description provided for @scanMenu.
  ///
  /// In en, this message translates to:
  /// **'Scan Menu'**
  String get scanMenu;

  /// No description provided for @runScan.
  ///
  /// In en, this message translates to:
  /// **'Run Scan'**
  String get runScan;

  /// No description provided for @photo.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photo;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @document.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get document;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'How to Scan'**
  String get helpTitle;

  /// No description provided for @helpStep1.
  ///
  /// In en, this message translates to:
  /// **'Position the menu in the frame'**
  String get helpStep1;

  /// No description provided for @helpStep2.
  ///
  /// In en, this message translates to:
  /// **'Make sure the text is clear and readable'**
  String get helpStep2;

  /// No description provided for @helpStep3.
  ///
  /// In en, this message translates to:
  /// **'Tap the shutter button to capture'**
  String get helpStep3;

  /// No description provided for @helpStep4.
  ///
  /// In en, this message translates to:
  /// **'Review and add more photos if needed'**
  String get helpStep4;

  /// No description provided for @helpStep5.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Run Scan\' when ready'**
  String get helpStep5;

  /// No description provided for @buildMyPlate.
  ///
  /// In en, this message translates to:
  /// **'🍽️ Build My Plate'**
  String get buildMyPlate;

  /// No description provided for @pickSafeIngredients.
  ///
  /// In en, this message translates to:
  /// **'Pick safe ingredients 🌿 or try a \n suggested combo 💛'**
  String get pickSafeIngredients;

  /// No description provided for @myPlate.
  ///
  /// In en, this message translates to:
  /// **'My Plate'**
  String get myPlate;

  /// No description provided for @addIngredientsPrompt.
  ///
  /// In en, this message translates to:
  /// **'✨ Add ingredients to build your plate'**
  String get addIngredientsPrompt;

  /// No description provided for @suggestCombo.
  ///
  /// In en, this message translates to:
  /// **'Suggest Combo'**
  String get suggestCombo;

  /// No description provided for @safeForYou.
  ///
  /// In en, this message translates to:
  /// **'Safe for You'**
  String get safeForYou;

  /// No description provided for @buildMyPlateInfo.
  ///
  /// In en, this message translates to:
  /// **'✨ These are the items Menu Sidekick spotted as safe for you. Some restaurants may not allow mixing & matching, so double-check with your server about what\'s available.'**
  String get buildMyPlateInfo;

  /// No description provided for @extraSauce.
  ///
  /// In en, this message translates to:
  /// **'🍅 Extra Sauce'**
  String get extraSauce;

  /// No description provided for @extraVeggies.
  ///
  /// In en, this message translates to:
  /// **'🥬 Extra Veggies'**
  String get extraVeggies;

  /// No description provided for @olives.
  ///
  /// In en, this message translates to:
  /// **'🫒 Olives'**
  String get olives;

  /// No description provided for @spicy.
  ///
  /// In en, this message translates to:
  /// **'🌶️ Spicy'**
  String get spicy;

  /// No description provided for @garlic.
  ///
  /// In en, this message translates to:
  /// **'🧄 Garlic'**
  String get garlic;

  /// No description provided for @orderingTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Ordering Tips for Your Plate'**
  String get orderingTipsTitle;

  /// No description provided for @orderingTipsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quick reminders to keep your meal safe & glowing✨'**
  String get orderingTipsSubtitle;

  /// No description provided for @yourPlateCombo.
  ///
  /// In en, this message translates to:
  /// **'YOUR PLATE COMBO'**
  String get yourPlateCombo;

  /// No description provided for @tipsSelection.
  ///
  /// In en, this message translates to:
  /// **'Tips Selection'**
  String get tipsSelection;

  /// No description provided for @saveMeal.
  ///
  /// In en, this message translates to:
  /// **'Save Meal'**
  String get saveMeal;

  /// No description provided for @qrShare.
  ///
  /// In en, this message translates to:
  /// **'QR Share'**
  String get qrShare;

  /// No description provided for @tipAskAboutOilsTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask About Oils'**
  String get tipAskAboutOilsTitle;

  /// No description provided for @tipAskAboutOilsDesc.
  ///
  /// In en, this message translates to:
  /// **'Confirm chicken is grilled in olive oil, not butter.'**
  String get tipAskAboutOilsDesc;

  /// No description provided for @tipSimplifySaucesTitle.
  ///
  /// In en, this message translates to:
  /// **'Simplify Sauces'**
  String get tipSimplifySaucesTitle;

  /// No description provided for @tipSimplifySaucesDesc.
  ///
  /// In en, this message translates to:
  /// **'Request sauces on the side so you stay in control.'**
  String get tipSimplifySaucesDesc;

  /// No description provided for @tipStayHydratedTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay Hydrated'**
  String get tipStayHydratedTitle;

  /// No description provided for @tipStayHydratedDesc.
  ///
  /// In en, this message translates to:
  /// **'Request sauces on the side so you stay in control.'**
  String get tipStayHydratedDesc;

  /// No description provided for @tipAskYourServerTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask Your Server'**
  String get tipAskYourServerTitle;

  /// No description provided for @tipAskYourServerDesc.
  ///
  /// In en, this message translates to:
  /// **'Could you confirm if the rice is cooked in butter or oil?\n\nAny soy sauce in this marinade?'**
  String get tipAskYourServerDesc;

  /// No description provided for @saveYourMeal.
  ///
  /// In en, this message translates to:
  /// **'Save Your Meal'**
  String get saveYourMeal;

  /// No description provided for @tapToAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap to add a photo of your meal'**
  String get tapToAddPhoto;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get changePhoto;

  /// No description provided for @giveYourMealName.
  ///
  /// In en, this message translates to:
  /// **'Give your meal a name'**
  String get giveYourMealName;

  /// No description provided for @mealNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., My Dairy-Free Pad Thai'**
  String get mealNamePlaceholder;

  /// No description provided for @thisWillAppear.
  ///
  /// In en, this message translates to:
  /// **'This will appear in your Favorites'**
  String get thisWillAppear;

  /// No description provided for @mealSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Meal \'{mealName}\' saved successfully! 🎉'**
  String mealSavedSuccess(Object mealName);

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @positionMenuInFrame.
  ///
  /// In en, this message translates to:
  /// **'Position the menu within the frame'**
  String get positionMenuInFrame;

  /// No description provided for @pdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get pdf;

  /// No description provided for @url.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get url;

  /// No description provided for @tipsForClearScan.
  ///
  /// In en, this message translates to:
  /// **'Tips for a Clear Scan'**
  String get tipsForClearScan;

  /// No description provided for @tipsForClearScanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your dining sidekick works best when the menu is easy to see. Here\'s how to glow it up:'**
  String get tipsForClearScanSubtitle;

  /// No description provided for @tipFlatSteadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Flat & Steady'**
  String get tipFlatSteadyTitle;

  /// No description provided for @tipFlatSteadyDesc.
  ///
  /// In en, this message translates to:
  /// **'Place the menu flat, hold the phone steady.'**
  String get tipFlatSteadyDesc;

  /// No description provided for @tipGoodLightingTitle.
  ///
  /// In en, this message translates to:
  /// **'Good Lighting'**
  String get tipGoodLightingTitle;

  /// No description provided for @tipGoodLightingDesc.
  ///
  /// In en, this message translates to:
  /// **'Natural light is best. Avoid strong reflections.'**
  String get tipGoodLightingDesc;

  /// No description provided for @tipNoCroppingTitle.
  ///
  /// In en, this message translates to:
  /// **'No Cropping'**
  String get tipNoCroppingTitle;

  /// No description provided for @tipNoCroppingDesc.
  ///
  /// In en, this message translates to:
  /// **'Capture the whole page edge to edge.'**
  String get tipNoCroppingDesc;

  /// No description provided for @tipSharpClearTitle.
  ///
  /// In en, this message translates to:
  /// **'Sharp & Clear'**
  String get tipSharpClearTitle;

  /// No description provided for @tipSharpClearDesc.
  ///
  /// In en, this message translates to:
  /// **'Make sure the text is legible for best results.'**
  String get tipSharpClearDesc;

  /// No description provided for @tipSpecialMessage.
  ///
  /// In en, this message translates to:
  /// **'Think of it as taking a photo for friend- clear, bright, and cozy. The clearer the shot, the better we can guide you!'**
  String get tipSpecialMessage;

  /// No description provided for @chooseHowToScan.
  ///
  /// In en, this message translates to:
  /// **'Choose How to Scan'**
  String get chooseHowToScan;

  /// No description provided for @scanOptionPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get scanOptionPhoto;

  /// No description provided for @scanOptionPhotoDesc.
  ///
  /// In en, this message translates to:
  /// **'Take a photo with your camera or upload an existing image of a menu.'**
  String get scanOptionPhotoDesc;

  /// No description provided for @scanOptionPDF.
  ///
  /// In en, this message translates to:
  /// **'PDF(Beta)'**
  String get scanOptionPDF;

  /// No description provided for @scanOptionPDFDesc.
  ///
  /// In en, this message translates to:
  /// **'Upload a menu PDF from your Files'**
  String get scanOptionPDFDesc;

  /// No description provided for @scanOptionURL.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get scanOptionURL;

  /// No description provided for @scanOptionURLDesc.
  ///
  /// In en, this message translates to:
  /// **'Capture the whole page edge to edge.'**
  String get scanOptionURLDesc;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it!'**
  String get gotIt;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @activeProfile.
  ///
  /// In en, this message translates to:
  /// **'Active Profile'**
  String get activeProfile;

  /// No description provided for @switchProfile.
  ///
  /// In en, this message translates to:
  /// **'Switch Profile'**
  String get switchProfile;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmation;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;
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
      <String>['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
