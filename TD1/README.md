# Namer App - TD1

Application Flutter générant des noms de projet aléatoires avec favoris persistants.

## 📋 Fonctionnalités

### Core
- ✅ Générateur de noms aléatoires (utilisant le package `english_words`)
- ✅ Affichage dans un composant `BigCard` stylisé
- ✅ Bouton "Suivant" pour générer un nouveau nom
- ✅ Bouton "J'aime" pour ajouter aux favoris
- ✅ Page de favoris avec liste `ListView`
- ✅ Navigation entre deux pages (AccueilF favoris) avec `BottomNavigationBar`
- ✅ Gestion d'état avec `ChangeNotifier` et `Provider`

### Améliorations
- ✅ **Accessibilité**: Utilisation de `semanticsLabel` avec `asPascalCase`
- ✅ **Persistance**: Sauvegarde les favoris en local avec `shared_preferences`
- ✅ **Mode paysage**: Support complet des orientations portrait/paysage
- ✅ **Layout adaptatif**:
  - Mode portrait : `BottomNavigationBar`
  - Mode paysage : `NavigationRail` à gauche
- ✅ **Initialisation asynchrone**: Affichage d'un `CircularProgressIndicator` pendant le chargement
- ✅ **Suppression de favoris**: Bouton delete dans chaque ListTile
- ✅ **Thème Material 3**: `ColorScheme` du thème personnalisé

## 📦 Dépendances

```yaml
english_words: ^4.0.0     # Génération de noms aléatoires
provider: ^6.0.0          # Gestion d'état
shared_preferences: ^2.0.0 # Sauvegarde locale
```

## 🏗 Architecture

```
lib/
├── main.dart
│   ├── MyApp               # Composant principal avec Provider
│   ├── MyAppState          # Gestion d'état globale
│   ├── MyHomePage          # Page principal avec navigation
│   ├── GeneratorPage       # Page de génération
│   ├── BigCard            # Composant de carte
│   └── FavoritesPage      # Page de favoris
```

## 🚀 Utilisation

### Installation des dépendances
```bash
flutter pub get
```

### Lancer l'application
```bash
flutter run
```

### Mode débug
- Utilisez le débuggeur de VS Code pour tester
- Hot reload activé : modifications en temps réel
- Inspectez le layout avec Widget Inspector

## 🎨 Caractéristiques UI

- **BigCard**: Carte avec couleur primaire, padding et vraie typographie
- **Thème**: Utilisation de `Theme.of(context)` pour cohérence
- **Centrage**: Colonne et ligne centrées avec `mainAxisAlignment`
- **Espacement**: Utilisation de `SizedBox` pour l'espacement
- **Responsive**: Adaptation automatique à différentes tailles d'écran

## 💾 Stockage des données

Les favoris sont stockés en JSON dans `shared_preferences`:
- Format: `["word1-word2", "word3-word4", ...]`
- Persistence entre les lancements de l'application
- Suppression possible depuis l'interface

## ✅ Tests

Pour tester les fonctionnalités:
1. Appuyez sur "Suivant" pour générer de nouveaux noms
2. Appuyez sur "J'aime" pour ajouter/retirer des favoris
3. Allez à l'onglet "Favoris" pour voir la liste
4. Appuyez sur la poubelle pour supprimer un favori
5. Fermez et ré-ouvrez l'app : les favoris sont conservés
6. Rotez l'écran : l'interface s'adapte automatiquement
