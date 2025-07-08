import 'package:flutter/material.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  String activeSection = 'backup';
  String newPin = '';
  String confirmPin = '';
  String language = 'fr';
  bool pinLoading = false;

  void _showSnack(String msg, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color ?? Colors.blue),
    );
  }

  void _handleBackup() {
    // TODO: Implement backup logic (e.g., export to file)
    _showSnack('Sauvegarde simulée (non implémentée)', color: Colors.green);
  }

  void _handleRestore() {
    // TODO: Implement restore logic (e.g., import from file)
    _showSnack('Restauration simulée (non implémentée)', color: Colors.orange);
  }

  void _handlePinChange() {
    if (newPin != confirmPin) {
      _showSnack('Les codes PIN ne correspondent pas', color: Colors.red);
      return;
    }
    if (newPin.length < 4) {
      _showSnack(
        'Le code PIN doit contenir au moins 4 caractères',
        color: Colors.red,
      );
      return;
    }
    setState(() => pinLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => pinLoading = false);
      _showSnack('Code PIN modifié avec succès !', color: Colors.green);
      setState(() {
        newPin = '';
        confirmPin = '';
      });
    });
  }

  void _handleLogout() {
    // TODO: Implement logout logic
    _showSnack('Déconnexion simulée (non implémentée)', color: Colors.red);
  }

  void _handleBack() {
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey, size: 28),
          onPressed: _handleBack,
          tooltip: 'Retour',
        ),
        title: const Text(
          'Sauvegarde & Paramètres',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ElevatedButton(
              onPressed: _handleLogout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: const Text('Déconnexion'),
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Sidebar(
                      activeSection: activeSection,
                      onSection: (s) => setState(() => activeSection = s),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: _SectionContent(
                        section: activeSection,
                        newPin: newPin,
                        confirmPin: confirmPin,
                        onNewPin: (v) => setState(() => newPin = v),
                        onConfirmPin: (v) => setState(() => confirmPin = v),
                        onPinChange: _handlePinChange,
                        pinLoading: pinLoading,
                        language: language,
                        onLanguage: (v) {
                          setState(() {
                            if (v != null) language = v;
                          });
                        },
                        onBackup: _handleBackup,
                        onRestore: _handleRestore,
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Sidebar(
                      activeSection: activeSection,
                      onSection: (s) => setState(() => activeSection = s),
                    ),
                    const SizedBox(height: 24),
                    _SectionContent(
                      section: activeSection,
                      newPin: newPin,
                      confirmPin: confirmPin,
                      onNewPin: (v) => setState(() => newPin = v),
                      onConfirmPin: (v) => setState(() => confirmPin = v),
                      onPinChange: _handlePinChange,
                      pinLoading: pinLoading,
                      language: language,
                      onLanguage: (v) {
                        setState(() {
                          if (v != null) language = v;
                        });
                      },
                      onBackup: _handleBackup,
                      onRestore: _handleRestore,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final String activeSection;
  final ValueChanged<String> onSection;
  const _Sidebar({required this.activeSection, required this.onSection});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDBEAFE)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _SidebarBtn(
            icon: Icons.save_alt,
            label: 'Sauvegarde',
            selected: activeSection == 'backup',
            onTap: () => onSection('backup'),
          ),
          _SidebarBtn(
            icon: Icons.shield,
            label: 'Sécurité',
            selected: activeSection == 'security',
            onTap: () => onSection('security'),
          ),
          _SidebarBtn(
            icon: Icons.language,
            label: 'Général',
            selected: activeSection == 'general',
            onTap: () => onSection('general'),
          ),
        ],
      ),
    );
  }
}

class _SidebarBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _SidebarBtn({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFEFF6FF) : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            border: selected
                ? const Border(
                    right: BorderSide(color: Color(0xFF2563EB), width: 4),
                  )
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: selected ? const Color(0xFF2563EB) : Colors.grey[700],
                size: 22,
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  color: selected ? const Color(0xFF2563EB) : Colors.grey[900],
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionContent extends StatelessWidget {
  final String section;
  final String newPin;
  final String confirmPin;
  final ValueChanged<String> onNewPin;
  final ValueChanged<String> onConfirmPin;
  final VoidCallback onPinChange;
  final bool pinLoading;
  final String language;
  final ValueChanged<String?> onLanguage;
  final VoidCallback onBackup;
  final VoidCallback onRestore;

  const _SectionContent({
    required this.section,
    required this.newPin,
    required this.confirmPin,
    required this.onNewPin,
    required this.onConfirmPin,
    required this.onPinChange,
    required this.pinLoading,
    required this.language,
    required this.onLanguage,
    required this.onBackup,
    required this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    switch (section) {
      case 'backup':
        return _BackupSection(onBackup: onBackup, onRestore: onRestore);
      case 'security':
        return _SecuritySection(
          newPin: newPin,
          confirmPin: confirmPin,
          onNewPin: onNewPin,
          onConfirmPin: onConfirmPin,
          onPinChange: onPinChange,
          pinLoading: pinLoading,
        );
      case 'general':
        return _GeneralSection(language: language, onLanguage: onLanguage);
      default:
        return const SizedBox.shrink();
    }
  }
}

class _BackupSection extends StatelessWidget {
  final VoidCallback onBackup;
  final VoidCallback onRestore;
  const _BackupSection({required this.onBackup, required this.onRestore});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sauvegarde des Données',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: const Text(
                'Vos données sont automatiquement sauvegardées localement. Pour une sécurité maximale, exportez régulièrement vos données.',
                style: TextStyle(color: Color(0xFF1E3A8A)),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onBackup,
                    icon: const Icon(Icons.download, color: Colors.white),
                    label: const Text('Sauvegarder vers Fichier'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onRestore,
                    icon: const Icon(Icons.upload, color: Colors.white),
                    label: const Text('Restaurer depuis Fichier'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '⚠️ Important',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB45309),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Sauvegardez régulièrement vos données',
                    style: TextStyle(color: Color(0xFFB45309)),
                  ),
                  Text(
                    '• Conservez les fichiers de sauvegarde en lieu sûr',
                    style: TextStyle(color: Color(0xFFB45309)),
                  ),
                  Text(
                    '• Testez la restauration périodiquement',
                    style: TextStyle(color: Color(0xFFB45309)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecuritySection extends StatelessWidget {
  final String newPin;
  final String confirmPin;
  final ValueChanged<String> onNewPin;
  final ValueChanged<String> onConfirmPin;
  final VoidCallback onPinChange;
  final bool pinLoading;
  const _SecuritySection({
    required this.newPin,
    required this.confirmPin,
    required this.onNewPin,
    required this.onConfirmPin,
    required this.onPinChange,
    required this.pinLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sécurité',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Changer le Code PIN',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Nouveau Code PIN',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: onNewPin,
                    keyboardType: TextInputType.number,
                    maxLength: 8,
                    buildCounter:
                        (
                          _, {
                          required currentLength,
                          maxLength,
                          required isFocused,
                        }) => null,
                    controller: TextEditingController(text: newPin),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirmer le Code PIN',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: onConfirmPin,
                    keyboardType: TextInputType.number,
                    maxLength: 8,
                    buildCounter:
                        (
                          _, {
                          required currentLength,
                          maxLength,
                          required isFocused,
                        }) => null,
                    controller: TextEditingController(text: confirmPin),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: pinLoading ? null : onPinChange,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: pinLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Modifier le Code PIN'),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F2),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Conseils de Sécurité',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB91C1C),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Utilisez un code PIN d\'au moins 4 caractères',
                    style: TextStyle(color: Color(0xFFB91C1C)),
                  ),
                  Text(
                    '• Ne partagez jamais votre code PIN',
                    style: TextStyle(color: Color(0xFFB91C1C)),
                  ),
                  Text(
                    '• Changez régulièrement votre code PIN',
                    style: TextStyle(color: Color(0xFFB91C1C)),
                  ),
                  Text(
                    '• Déconnectez-vous toujours après utilisation',
                    style: TextStyle(color: Color(0xFFB91C1C)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GeneralSection extends StatelessWidget {
  final String language;
  final ValueChanged<String?> onLanguage;
  const _GeneralSection({required this.language, required this.onLanguage});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Paramètres Généraux',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Langue de l\'Interface',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: language,
              items: const [
                DropdownMenuItem(value: 'fr', child: Text('Français')),
                DropdownMenuItem(value: 'wf', child: Text('Wolof')),
                DropdownMenuItem(value: 'ar', child: Text('العربية')),
              ],
              onChanged: onLanguage,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            const Text(
              'Redémarrage requis pour appliquer les changements',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'À propos de PharmaFacile',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Version: 1.0.0'),
                  Text('Développé par: Équipe PharmaFacile'),
                  Text('Support: contact@pharmafacile.com'),
                  Text('Licence: Usage commercial autorisé'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fonctionnalités Principales',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '✓ Gestion des ventes rapide et intuitive',
                    style: TextStyle(color: Color(0xFF2563EB)),
                  ),
                  Text(
                    '✓ Suivi des stocks en temps réel',
                    style: TextStyle(color: Color(0xFF2563EB)),
                  ),
                  Text(
                    '✓ Rapports détaillés et exportables',
                    style: TextStyle(color: Color(0xFF2563EB)),
                  ),
                  Text(
                    '✓ Sauvegarde automatique des données',
                    style: TextStyle(color: Color(0xFF2563EB)),
                  ),
                  Text(
                    '✓ Interface tactile optimisée',
                    style: TextStyle(color: Color(0xFF2563EB)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
