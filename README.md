# MoodTune 
A mood-tracking application that recommends music based on how the user feels.  
Built using **Flutter**, **Riverpod**, **SQLite**, and the **iTunes Search API**.
### !!!To prevents bug, please run this app on Android Emulator only!!!
---

## Features

###  Mood Tracking
- Select daily mood (Happy, Sad, Angry, Calm)
- Intensity slider (1–5)
- Optional notes
- Saved locally with timestamp in SQLite

### Music Recommendations
- Maps mood → custom keyword set
- Fetches tracks from iTunes Search API
- Displays title, artist, artwork
- “Open Preview” button opens 30s audio preview

###  Journal
- Shows all past mood entries
- Reverse chronological order
- Auto-refresh when new moods are added

###  Stats
- Pie chart of mood distribution
- Real-time updates from DB

###  Settings
- Clear App Data (wipes DB + refreshes providers)

---

## Tech Stack

- Flutter 3.x
- Riverpod 2.x (AsyncNotifier, FutureProvider)
- sqflite for local storage
- fl_chart for pie charts
- iTunes Search API (music)
- url_launcher

---

## Project Architecture
```
lib/ 
├─ core/ # mood keywords, utilities
├─ data/ # api, db, repositories
├─ domain/ # entities + repository interfaces
├─ presentation/ # screens + providers
└─ main.dart
```

Clean architecture pattern with:
- Data layer
- Domain layer
- Presentation layer

---

##  Getting Started

### Clone the repo
```bash
git clone https://github.com/YOUR_USERNAME/mood_tune_project.git
cd mood_tune_project
```

### Install packages
```bash
flutter pub get
```
### Run on device/emulator


---

##  License

MIT License 
