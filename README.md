# 🌤 Weather and News Aggregator App

A Flutter app that shows current weather and news headlines — with a unique feature that filters news **based on the current weather mood** (like cold, hot, or warm conditions).

---

## 📌 Objective

Build an app using Flutter that fetches and displays:
- Real-time **weather** based on current location or searched city
- **News headlines** from public APIs
- Filters news content based on the weather condition (e.g., positive articles on warm days)

---

## ✨ App Features

### 🏠 Home Screen
- Displays **weather from current location**
- Users can also **search for any city**
- Weather card is **clickable** — navigates to a **detailed weather screen**
- Displays **filtered news** based on weather (see logic below)
- Clicking on a news item opens the **news detail screen**

### ⚙️ Settings Screen
- Choose temperature unit: **Celsius / Fahrenheit**
- Select up to **5 news categories** (from 17 options)
- All settings are saved using **SharedPreferences**

---

## 🌦 Weather Features
- Uses **OpenWeatherMap API** ([openweathermap.org](https://openweathermap.org/api))
- Shows:
  - Temperature
  - Humidity
  - Wind speed
  - City name
  - Weather condition & icon
- Fetches data by:
  - 📍 Current location (uses GPS)
  - 🔍 Searched city
- Fallbacks to default cities if permission is denied

---

## 📰 News Features
- Uses **NewsAPI** ([newsapi.org](https://newsapi.org/))
- Displays:
  - Headline title
  - Description
  - Image (or placeholder)
  - Source name
  - Published time
- Clickable to view **full details**
- Supports **pagination** and **pull to refresh**

---

## 🌡 Weather-Based News Filtering Logic

News content is filtered based on the current weather temperature:

| Temperature       | Keywords Shown                         |
|-------------------|----------------------------------------|
| ❄ Cold (< 15°C)   | tragedy, depressing, disaster, loss    |
| 🔥 Hot (> 30°C)   | danger, fear, threat, risk             |
| 🌤 Warm (15–30°C) | positivity, winning, happiness, joy    |

---

## 🛠 Technologies Used

- Flutter & Dart
- GetX (State Management, Routing, DI)
- OpenWeatherMap API
- NewsAPI
- SharedPreferences
- Geolocator & Geocoding
- Clean, modular folder structure

---

## ▶️ How to Run the Project

1. **Clone the repository**
   ```bash
   git clone https://github.com/Theerthac/Weather-News.git
   cd Weather-News
