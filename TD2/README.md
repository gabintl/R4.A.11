# Weather App

Application météo Flutter multi-plateforme se connectant à l'API OpenWeatherMap.

## Architecture

Le projet utilise les dépendances suivantes:
- **provider**: Gestion de l'état et injection de dépendances
- **http**: Requêtes HTTP vers les APIs
- **geolocator**: Géolocalisation de l'appareil
- **intl**: Formatting des dates en français

## Structure du projet

```
lib/
├── config.dart                 # Configuration (clé API)
├── main.dart                   # Point d'entrée
├── models/
│   ├── forecast.dart          # Prévision sur 5 jours
│   ├── location.dart          # Localisation
│   └── weather.dart           # Données météo
├── services/
│   ├── geolocation_service.dart # Service de géolocalisation
│   ├── location.dart          # Modèle Location
│   └── openweathermap_api.dart # Service API OpenWeatherMap
├── ui/
│   ├── loading_screen.dart    # Écran de démarrage
│   ├── search_page.dart       # Page de recherche de ville
│   └── weather_page.dart      # Page affichage météo
└── widgets/
    └── custom_scrollbar.dart  # Widget scrollbar personnalisé
```

## Fonctionnalités

### Core
- ✅ Recherche de ville via API Geocoding
- ✅ Affichage de la météo actuelle
- ✅ Géolocalisation automatique au démarrage
- ✅ Navigation entre pages

### Améliorations
- ✅ Affichage de données météo supplémentaires (humidité, vent, pression, etc.)
- ✅ Reverse geocoding pour afficher le nom de la ville pour la position actuelle
- ✅ Prévision sur 5 jours avec scroll horizontal
- ✅ Formatage des dates en français

## Configuration

1. Ajouter votre clé API OpenWeatherMap dans [lib/config.dart](lib/config.dart)
2. Installer les dépendances: `flutter pub get`
3. Pour Android, la permission de géolocalisation est déjà configurée dans [android/app/src/main/AndroidManifest.xml](android/app/src/main/AndroidManifest.xml)

## Démarrage

```bash
flutter run
```

## API utilisées

- [Geocoding API](https://openweathermap.org/api/geocoding-api) - Recherche de villes
- [Current Weather API](https://openweathermap.org/current) - Météo actuelle
- [Reverse Geocoding API](https://openweathermap.org/api/geocoding-api#reverse) - Nom de la ville par coordonnées
- [5 Day Weather Forecast API](https://openweathermap.org/forecast5) - Prévision 5 jours
