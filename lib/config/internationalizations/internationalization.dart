import 'package:flutter/material.dart';

import 'local_string.dart';

/// AppInternalization defines all the 'local' strings displayed to
/// the user.
/// Local strings are strings that do not come from a database.
/// e.g: error messages, page titles.
class Internationalization extends ChangeNotifier {
  Locale _locale;

  /// Gets the locale.
  Locale get locale => _locale;

  static final Map<String, String> _placeholder = {
    LocalizedString.defaultLanguage: LocalizedString.placeholder,
  };

  /// Update the current locale.
  void setLocale(Locale locale) {
    if (locale == _locale) return;
    _locale = locale;
    notifyListeners();
  }

  /// The locales supported by the application.
  static const List<Locale> supportedLocales = [Locale('en'), Locale('fr')];

  String _stringOfLocalizedValue(
    Map<dynamic, dynamic> jsonMap, {
    List<String>? parameters,
  }) {
    String localizedString = LocalizedString(jsonMap).get(_locale);

    // If no parameters provided, return the string as-is
    if (parameters == null || parameters.isEmpty) {
      return localizedString;
    }

    // Replace placeholders with actual values
    for (int i = 0; i < parameters.length; i++) {
      localizedString = localizedString.replaceAll('{$i}', parameters[i]);
    }

    return localizedString;
  }

  /// Constructs a new [Internationalization].
  Internationalization(this._locale);

  // Loaded from a map, but will eventually be loaded from a JSON
  // file.
  static const Map<String, Map<String, String>> _localizedValues = {
    'dashboard': {'en': 'Dashboard', 'fr': 'Tableau de bord'},
    'products': {'en': 'Products', 'fr': 'Produits'},
    'inventory': {'en': 'Inventory', 'fr': 'Inventaire'},
    'categories': {'en': 'Categories', 'fr': 'Catégories'},
    'addProduct': {'en': 'Add Product', 'fr': 'Ajouter un produit'},
    'sales': {'en': 'Sales', 'fr': 'Ventes'},
    'reports': {'en': 'Reports', 'fr': 'Rapports'},
    'suppliers': {'en': 'Suppliers', 'fr': 'Fournisseurs'},
    'users': {'en': 'Users', 'fr': 'Utilisateurs'},
    'settings': {'en': 'Settings', 'fr': 'Paramètres'},
    'logout': {'en': 'Logout', 'fr': 'Déconnexion'},
    'login': {'en': 'Login', 'fr': 'Connexion'},
    'email': {'en': 'Email', 'fr': 'E-mail'},
    'password': {'en': 'Password', 'fr': 'Mot de passe'},
    'confirmPassword': {
      'en': 'Confirm Password',
      'fr': 'Confirmer le mot de passe',
    },
    'forgotPassword': {'en': 'Forgot Password?', 'fr': 'Mot de passe oublié ?'},
    'submit': {'en': 'Submit', 'fr': 'Soumettre'},
    'cancel': {'en': 'Cancel', 'fr': 'Annuler'},
    'save': {'en': 'Save', 'fr': 'Enregistrer'},
    'edit': {'en': 'Edit', 'fr': 'Modifier'},
    'delete': {'en': 'Delete', 'fr': 'Supprimer'},
    'search': {'en': 'Search', 'fr': 'Rechercher'},
    'name': {'en': 'Name', 'fr': 'Nom'},
    'role': {'en': 'Role', 'fr': 'Rôle'},
    'admin': {'en': 'Admin', 'fr': 'Administrateur'},
    'pharmacist': {'en': 'Pharmacist', 'fr': 'Pharmacien'},
    'assistant': {'en': 'Assistant', 'fr': 'Assistant'},
    'welcome': {'en': 'Welcome', 'fr': 'Bienvenue'},
    'add': {'en': 'Add', 'fr': 'Ajouter'},
    'update': {'en': 'Update', 'fr': 'Mettre à jour'},
    'close': {'en': 'Close', 'fr': 'Fermer'},
    'description': {'en': 'Description', 'fr': 'Description'},
    'quantity': {'en': 'Quantity', 'fr': 'Quantité'},
    'price': {'en': 'Price', 'fr': 'Prix'},
    'supplier': {'en': 'Supplier', 'fr': 'Fournisseur'},
    'date': {'en': 'Date', 'fr': 'Date'},
    'actions': {'en': 'Actions', 'fr': 'Actions'},
    'noData': {'en': 'No data available', 'fr': 'Aucune donnée disponible'},
    'requiredField': {
      'en': 'This field is required',
      'fr': 'Ce champ est requis',
    },
    'invalidEmail': {
      'en': 'Invalid email address',
      'fr': 'Adresse e-mail invalide',
    },
    'passwordsDoNotMatch': {
      'en': 'Passwords do not match',
      'fr': 'Les mots de passe ne correspondent pas',
    },
    'loading': {'en': 'Loading...', 'fr': 'Chargement...'},
    'success': {'en': 'Success', 'fr': 'Succès'},
    'error': {'en': 'Error', 'fr': 'Erreur'},
    'confirmDelete': {
      'en': 'Are you sure you want to delete?',
      'fr': 'Êtes-vous sûr de vouloir supprimer ?',
    },
    'yes': {'en': 'Yes', 'fr': 'Oui'},
    'no': {'en': 'No', 'fr': 'Non'},
    'logoutMessage': {
      'en': 'You have been logged out.',
      'fr': 'Vous avez été déconnecté.',
    },
    'profile': {'en': 'Profile', 'fr': 'Profil'},
    'language': {'en': 'Language', 'fr': 'Langue'},
    'english': {'en': 'English', 'fr': 'Anglais'},
    'french': {'en': 'French', 'fr': 'Français'},
    'home': {'en': 'Home', 'fr': 'Accueil'},
    'addCategory': {'en': 'Add Category', 'fr': 'Ajouter une catégorie'},
    'addSupplier': {'en': 'Add Supplier', 'fr': 'Ajouter un fournisseur'},
    'addUser': {'en': 'Add User', 'fr': 'Ajouter un utilisateur'},
    'productName': {'en': 'Product Name', 'fr': 'Nom du produit'},
    'category': {'en': 'Category', 'fr': 'Catégorie'},
    'stock': {'en': 'Stock', 'fr': 'Stock'},
    'lowStock': {'en': 'Low Stock', 'fr': 'Stock faible'},
    'expired': {'en': 'Expired', 'fr': 'Expiré'},
    'expirationDate': {'en': 'Expiration Date', 'fr': 'Date d\'expiration'},
    'active': {'en': 'Active', 'fr': 'Actif'},
    'inactive': {'en': 'Inactive', 'fr': 'Inactif'},
  };

  /// Returns the localized value of text 'dashboard'.
  String get active =>
      _stringOfLocalizedValue(_localizedValues['active'] ?? _placeholder);

  /// Returns the localized value of text 'dashboard'.
  String get inactive =>
      _stringOfLocalizedValue(_localizedValues['inactive'] ?? _placeholder);

  /// Returns the localized value of text 'dashboard'.
  String get dashboard =>
      _stringOfLocalizedValue(_localizedValues['dashboard'] ?? _placeholder);

  /// Returns the localized value of text 'products'.
  String get products =>
      _stringOfLocalizedValue(_localizedValues['products'] ?? _placeholder);

  /// Returns the localized value of text 'inventory'.
  String get inventory =>
      _stringOfLocalizedValue(_localizedValues['inventory'] ?? _placeholder);

  /// Returns the localized value of text 'categories'.
  String get categories =>
      _stringOfLocalizedValue(_localizedValues['categories'] ?? _placeholder);

  /// Returns the localized value of text 'addProduct'.
  String get addProduct =>
      _stringOfLocalizedValue(_localizedValues['addProduct'] ?? _placeholder);

  /// Returns the localized value of text 'sales'.
  String get sales =>
      _stringOfLocalizedValue(_localizedValues['sales'] ?? _placeholder);

  /// Returns the localized value of text 'reports'.
  String get reports =>
      _stringOfLocalizedValue(_localizedValues['reports'] ?? _placeholder);

  /// Returns the localized value of text 'suppliers'.
  String get suppliers =>
      _stringOfLocalizedValue(_localizedValues['suppliers'] ?? _placeholder);

  /// Returns the localized value of text 'users'.
  String get users =>
      _stringOfLocalizedValue(_localizedValues['users'] ?? _placeholder);

  /// Returns the localized value of text 'settings'.
  String get settings =>
      _stringOfLocalizedValue(_localizedValues['settings'] ?? _placeholder);

  /// Returns the localized value of text 'logout'.
  String get logout =>
      _stringOfLocalizedValue(_localizedValues['logout'] ?? _placeholder);

  /// Returns the localized value of text 'login'.
  String get login =>
      _stringOfLocalizedValue(_localizedValues['login'] ?? _placeholder);

  /// Returns the localized value of text 'email'.
  String get email =>
      _stringOfLocalizedValue(_localizedValues['email'] ?? _placeholder);

  /// Returns the localized value of text 'password'.
  String get password =>
      _stringOfLocalizedValue(_localizedValues['password'] ?? _placeholder);

  /// Returns the localized value of text 'confirmPassword'.
  String get confirmPassword => _stringOfLocalizedValue(
    _localizedValues['confirmPassword'] ?? _placeholder,
  );

  /// Returns the localized value of text 'forgotPassword'.
  String get forgotPassword => _stringOfLocalizedValue(
    _localizedValues['forgotPassword'] ?? _placeholder,
  );

  /// Returns the localized value of text 'submit'.
  String get submit =>
      _stringOfLocalizedValue(_localizedValues['submit'] ?? _placeholder);

  /// Returns the localized value of text 'cancel'.
  String get cancel =>
      _stringOfLocalizedValue(_localizedValues['cancel'] ?? _placeholder);

  /// Returns the localized value of text 'save'.
  String get save =>
      _stringOfLocalizedValue(_localizedValues['save'] ?? _placeholder);

  /// Returns the localized value of text 'edit'.
  String get edit =>
      _stringOfLocalizedValue(_localizedValues['edit'] ?? _placeholder);

  /// Returns the localized value of text 'delete'.
  String get delete =>
      _stringOfLocalizedValue(_localizedValues['delete'] ?? _placeholder);

  /// Returns the localized value of text 'search'.
  String get search =>
      _stringOfLocalizedValue(_localizedValues['search'] ?? _placeholder);

  /// Returns the localized value of text 'name'.
  String get name =>
      _stringOfLocalizedValue(_localizedValues['name'] ?? _placeholder);

  /// Returns the localized value of text 'role'.
  String get role =>
      _stringOfLocalizedValue(_localizedValues['role'] ?? _placeholder);

  /// Returns the localized value of text 'admin'.
  String get admin =>
      _stringOfLocalizedValue(_localizedValues['admin'] ?? _placeholder);

  /// Returns the localized value of text 'pharmacist'.
  String get pharmacist =>
      _stringOfLocalizedValue(_localizedValues['pharmacist'] ?? _placeholder);

  /// Returns the localized value of text 'assistant'.
  String get assistant =>
      _stringOfLocalizedValue(_localizedValues['assistant'] ?? _placeholder);

  /// Returns the localized value of text 'welcome'.
  String get welcome =>
      _stringOfLocalizedValue(_localizedValues['welcome'] ?? _placeholder);

  /// Returns the localized value of text 'add'.
  String get add =>
      _stringOfLocalizedValue(_localizedValues['add'] ?? _placeholder);

  /// Returns the localized value of text 'update'.
  String get update =>
      _stringOfLocalizedValue(_localizedValues['update'] ?? _placeholder);

  /// Returns the localized value of text 'close'.
  String get close =>
      _stringOfLocalizedValue(_localizedValues['close'] ?? _placeholder);

  /// Returns the localized value of text 'description'.
  String get description =>
      _stringOfLocalizedValue(_localizedValues['description'] ?? _placeholder);

  /// Returns the localized value of text 'quantity'.
  String get quantity =>
      _stringOfLocalizedValue(_localizedValues['quantity'] ?? _placeholder);

  /// Returns the localized value of text 'price'.
  String get price =>
      _stringOfLocalizedValue(_localizedValues['price'] ?? _placeholder);

  /// Returns the localized value of text 'supplier'.
  String get supplier =>
      _stringOfLocalizedValue(_localizedValues['supplier'] ?? _placeholder);

  /// Returns the localized value of text 'date'.
  String get date =>
      _stringOfLocalizedValue(_localizedValues['date'] ?? _placeholder);

  /// Returns the localized value of text 'actions'.
  String get actions =>
      _stringOfLocalizedValue(_localizedValues['actions'] ?? _placeholder);

  /// Returns the localized value of text 'noData'.
  String get noData =>
      _stringOfLocalizedValue(_localizedValues['noData'] ?? _placeholder);

  /// Returns the localized value of text 'requiredField'.
  String get requiredField => _stringOfLocalizedValue(
    _localizedValues['requiredField'] ?? _placeholder,
  );

  /// Returns the localized value of text 'invalidEmail'.
  String get invalidEmail =>
      _stringOfLocalizedValue(_localizedValues['invalidEmail'] ?? _placeholder);

  /// Returns the localized value of text 'passwordsDoNotMatch'.
  String get passwordsDoNotMatch => _stringOfLocalizedValue(
    _localizedValues['passwordsDoNotMatch'] ?? _placeholder,
  );

  /// Returns the localized value of text 'loading'.
  String get loading =>
      _stringOfLocalizedValue(_localizedValues['loading'] ?? _placeholder);

  /// Returns the localized value of text 'success'.
  String get success =>
      _stringOfLocalizedValue(_localizedValues['success'] ?? _placeholder);

  /// Returns the localized value of text 'error'.
  String get error =>
      _stringOfLocalizedValue(_localizedValues['error'] ?? _placeholder);

  /// Returns the localized value of text 'confirmDelete'.
  String get confirmDelete => _stringOfLocalizedValue(
    _localizedValues['confirmDelete'] ?? _placeholder,
  );

  /// Returns the localized value of text 'yes'.
  String get yes =>
      _stringOfLocalizedValue(_localizedValues['yes'] ?? _placeholder);

  /// Returns the localized value of text 'no'.
  String get no =>
      _stringOfLocalizedValue(_localizedValues['no'] ?? _placeholder);

  /// Returns the localized value of text 'logoutMessage'.
  String get logoutMessage => _stringOfLocalizedValue(
    _localizedValues['logoutMessage'] ?? _placeholder,
  );

  /// Returns the localized value of text 'profile'.
  String get profile =>
      _stringOfLocalizedValue(_localizedValues['profile'] ?? _placeholder);

  /// Returns the localized value of text 'language'.
  String get language =>
      _stringOfLocalizedValue(_localizedValues['language'] ?? _placeholder);

  /// Returns the localized value of text 'english'.
  String get english =>
      _stringOfLocalizedValue(_localizedValues['english'] ?? _placeholder);

  /// Returns the localized value of text 'french'.
  String get french =>
      _stringOfLocalizedValue(_localizedValues['french'] ?? _placeholder);

  /// Returns the localized value of text 'home'.
  String get home =>
      _stringOfLocalizedValue(_localizedValues['home'] ?? _placeholder);

  /// Returns the localized value of text 'addCategory'.
  String get addCategory =>
      _stringOfLocalizedValue(_localizedValues['addCategory'] ?? _placeholder);

  /// Returns the localized value of text 'addSupplier'.
  String get addSupplier =>
      _stringOfLocalizedValue(_localizedValues['addSupplier'] ?? _placeholder);

  /// Returns the localized value of text 'addUser'.
  String get addUser =>
      _stringOfLocalizedValue(_localizedValues['addUser'] ?? _placeholder);

  /// Returns the localized value of text 'productName'.
  String get productName =>
      _stringOfLocalizedValue(_localizedValues['productName'] ?? _placeholder);

  /// Returns the localized value of text 'category'.
  String get category =>
      _stringOfLocalizedValue(_localizedValues['category'] ?? _placeholder);

  /// Returns the localized value of text 'stock'.
  String get stock =>
      _stringOfLocalizedValue(_localizedValues['stock'] ?? _placeholder);

  /// Returns the localized value of text 'lowStock'.
  String get lowStock =>
      _stringOfLocalizedValue(_localizedValues['lowStock'] ?? _placeholder);

  /// Returns the localized value of text 'expired'.
  String get expired =>
      _stringOfLocalizedValue(_localizedValues['expired'] ?? _placeholder);

  /// Returns the localized value of text 'expirationDate'.
  String get expirationDate => _stringOfLocalizedValue(
    _localizedValues['expirationDate'] ?? _placeholder,
  );
}
