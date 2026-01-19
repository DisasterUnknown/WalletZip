# Expenso 💰

A comprehensive personal expense tracking and budget management application built with Flutter. Expenso helps you manage your finances by tracking expenses, income, budgets, and providing detailed insights into your spending patterns.

## 📱 Features

### Core Functionality

- **📊 Transaction Management**
  - Add, edit, and delete income and expense transactions
  - Support for multiple categories per transaction
  - Add notes and timestamps to transactions
  - Temporary transactions with expected dates and status tracking
  - Link related transactions (e.g., temporary expense to actual expense)

- **📁 Category System**
  - 100+ pre-defined categories across various spending areas:
    - Food & Drinks (Food, Coffee, Tea, Snacks, Dinner, Breakfast, etc.)
    - Transport (Bus, Taxi, Fuel, Parking, Train, Flight, etc.)
    - Bills & Utilities (Electric, Water, Internet, Rent, Phone, etc.)
    - Shopping (Clothes, Gifts, Books, Tech, Jewelry, Beauty, etc.)
    - Entertainment (Movie, Games, Sport, Events, Concerts, etc.)
    - Health & Fitness (Gym, Yoga, Dentist, Spa, Therapy, etc.)
    - Finance & Money (Salary, Card, Debt, Loan, Tax, Crypto, etc.)
    - Travel, Pets, Education, and more
  - Customizable category states (active/inactive)
  - Restore default categories option

- **📅 Time-based Views**
  - **Dashboard**: Overview with filters for Month, Year, and All-time
  - **Year View**: Browse expenses by year with monthly breakdowns
  - **Monthly View**: Detailed day-by-day expense tracking within a month
  - Automatic navigation to current month option

- **💰 Budget Management**
  - Set monthly budgets
  - Track spending against budgets
  - Visual budget usage indicators with projections
  - Budget status for today, weekly, monthly, and yearly periods
  - Ring charts for budget visualization

- **📈 Analytics & Insights**
  - Total income and expense calculations
  - Category-wise spending breakdown
  - Visual status cards with spending summaries
  - Dashboard filters (Month/Year/All-time)
  - Income vs. expense comparisons

- **🎨 Customization**
  - Multiple built-in themes:
    - Dark themes: Dark Gray, Deep Purple, Forest Green, Ocean Blue
    - Light themes: Sky Light, Aqua Light, Blush Pink, Classic Light, Mint Green, Sunny Yellow
  - Customizable appearance settings
  - Theme persistence

- **💾 Data Management**
  - **Encrypted Backup & Restore**
    - Export database as encrypted `.silverFoxDb` file
    - Import and restore from backup files
    - AES encryption for data security
  - **Data Import/Export**: Full database backup and restore functionality
  - **Clear Data**: Option to reset all data while preserving default categories

- **⚙️ Settings & Preferences**
  - Toggle "Open app on current month" setting
  - View application logs
  - Download logs for debugging
  - Clear logs option
  - Restore system categories
  - Developer options

- **🔒 Privacy & Security**
  - Local data storage using SQLite
  - Encrypted backup files
  - No cloud sync (data stays on your device)
  - Permission handling for file access

## 🚀 Installation

### Prerequisites

Before installing Expenso, ensure you have the following installed:

1. **Flutter SDK** (version 3.9.2 or higher)
   - Download from [Flutter Official Website](https://flutter.dev/docs/get-started/install)
   - Verify installation: `flutter doctor`

2. **Development Environment**
   - For **Android**: Android Studio with Android SDK
   - For **iOS**: Xcode (macOS only)
   - For **Windows/Linux/macOS Desktop**: Flutter desktop support enabled

3. **Dependencies**
   - Git (for cloning the repository)
   - A code editor (VS Code or Android Studio recommended)

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd expenso
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Verify installation**
   ```bash
   flutter doctor
   ```
   Make sure all required components are checked.

4. **Run the application**

   For **Android**:
   ```bash
   flutter run
   ```
   Or open in Android Studio and click "Run"

   For **iOS** (macOS only):
   ```bash
   flutter run
   ```
   Or open in Xcode and run the project

   For **Windows**:
   ```bash
   flutter run -d windows
   ```

   For **Linux**:
   ```bash
   flutter run -d linux
   ```

   For **macOS Desktop**:
   ```bash
   flutter run -d macos
   ```

   For **Web**:
   ```bash
   flutter run -d chrome
   ```

5. **Build for production**

   Android APK:
   ```bash
   flutter build apk
   ```

   Android App Bundle (for Play Store):
   ```bash
   flutter build appbundle
   ```

   iOS (macOS only):
   ```bash
   flutter build ios
   ```

   Windows:
   ```bash
   flutter build windows
   ```

   Linux:
   ```bash
   flutter build linux
   ```

   macOS:
   ```bash
   flutter build macos
   ```

   Web:
   ```bash
   flutter build web
   ```

## 📖 How to Use

### Getting Started

1. **First Launch**
   - The app opens to the Dashboard screen
   - Default categories are automatically loaded
   - Start adding your first transaction by tapping the floating action button (+)

2. **Adding a Transaction**
   - Tap the **+** (Floating Action Button) on any screen
   - Select transaction type: **Income** or **Expense**
   - Enter the amount
   - Select one or more categories
   - Add an optional note
   - Set the date and time
   - Tap **Confirm** to save

3. **Managing Categories**
   - Navigate to the **Categories** screen from the bottom navigation
   - View all available categories
   - Categories can be activated/deactivated (if supported)
   - Use "Restore System Categories" in Settings to reset to defaults

### Main Screens

- **Dashboard** 📊
  - Overview of your finances with visual status cards
  - Filter by Month, Year, or All-time
  - View total income and expenses
  - Category-wise spending breakdown

- **Expense Records** 📝
  - Browse all transactions organized by year
  - Tap a year to see monthly breakdowns
  - Tap a month to see daily transactions
  - View transaction details and edit/delete

- **Budget** 💰
  - Set and manage monthly budgets
  - View spending progress with visual indicators
  - Track budget usage for different time periods
  - Budget projections and warnings

- **Categories** 🏷️
  - Browse all expense and income categories
  - View category icons and names
  - Manage category preferences

- **Settings** ⚙️
  - Customize app appearance and themes
  - Manage backups and data
  - Configure preferences
  - View logs and debug information

### Budget Management

1. **Setting a Budget**
   - Navigate to the **Budget** screen
   - Tap "Add Budget" or the budget card
   - Enter the monthly budget amount
   - Save to track your spending

2. **Monitoring Budget**
   - View current month's spending vs. budget
   - Check daily, weekly, monthly, and yearly spending
   - See visual progress indicators
   - Get insights on budget projections

### Data Backup & Restore

1. **Creating a Backup**
   - Go to **Settings**
   - Tap **"Download Backup (.silverFoxDb)"**
   - Choose a location to save the encrypted backup file
   - Your backup is encrypted and secure

2. **Restoring from Backup**
   - Go to **Settings**
   - Tap **"Import Backup (.silverFoxDb)"**
   - Select your backup file
   - Confirm to restore your data

⚠️ **Note**: Restoring a backup will replace all existing data.

### Temporary Transactions

- Create temporary expenses with expected reimbursement dates
- Track transaction status (open/completed)
- Link temporary expenses to actual expenses
- Useful for tracking business expenses, loans, or pending payments

### Customization

1. **Changing Theme**
   - Go to **Settings** → **Appearances**
   - Select from available dark or light themes
   - Theme preference is saved automatically

2. **App Preferences**
   - Enable/disable "Open app on current month"
   - Customize default views

## 🛠️ Technical Details

### Built With

- **Flutter** - UI framework
- **Dart** - Programming language
- **SQLite (sqflite)** - Local database
- **Shared Preferences** - Settings storage
- **Encryption** - Secure backup files
- **Path Provider** - File system access
- **File Selector** - File import/export
- **Permission Handler** - File permissions

### Database Schema

- **expenses** - Stores all transactions
- **categories** - Stores category definitions
- **budgets** - Stores budget information

### Project Structure

```
lib/
├── core/           # Constants, themes, shared preferences
├── data/           # Database, models, backup services
├── services/       # Routing, theme, logging, startup services
├── ui/             # Screens and widgets
│   ├── screens/    # Main application screens
│   └── widgets/    # Reusable UI components
├── utils/          # Utility functions
└── main.dart       # Application entry point
```

## 📝 License

This project is private and not intended for public distribution.

## 🤝 Contributing

This is a personal project. Contributions are welcome through issues and pull requests.

## 📧 Support

For issues, questions, or feature requests, please open an issue in the repository.

---

**Made with ❤️ using Flutter**
