# StockApp

StockApp is an iOS application built using SwiftUI and integrates with the [Finnhub API](https://finnhub.io) to provide real-time stock information. Users can search for stock symbols, view detailed stock data, and maintain a personalized list of stocks. The app is designed with a clean, dark-mode interface for an enhanced user experience.

---

## Screenshots

<img width="300" alt="home page" src="https://github.com/user-attachments/assets/f06ea9d2-6376-4649-a212-ebae5b04f916">
<img width="300" alt="ImageView" src="https://github.com/user-attachments/assets/fbcf3965-8fe8-48fa-b0cc-1ef6b24439f0">
<img width="300" alt="ViewAllImages" src="https://github.com/user-attachments/assets/d2463b60-f153-4299-9574-07439d2108d2">
<img width="300" alt="ImageView" src="https://github.com/user-attachments/assets/7dbc7113-de27-4d88-9643-ca7d2c14db1c">
<img width="300" alt="ViewAllImages" src="https://github.com/user-attachments/assets/7c0a4232-65ad-4fa2-b92c-4b9a57955259">

---

## Features

- **Search for Stocks**: Search for stocks by symbol or company description.
- **Add Stocks to Watchlist**: Easily add stocks to a personalized watchlist.
- **View Detailed Stock Information**: View real-time stock price, daily change, percentage change, and more.
- **Dark Mode**: The app is designed to run exclusively in dark mode for a sleek and modern user experience.
- **Persistent Storage**: Added stocks are saved locally and remain accessible after app restarts.

---

## Technologies

- **SwiftUI**: Modern declarative UI framework for building iOS apps.
- **Combine**: Framework for managing asynchronous events in Swift.
- **Finnhub API**: Real-time stock market data API.
- **UserDefaults**: For local data persistence.
- **MVVM Architecture**: Clean separation of UI and business logic.

---

## Project Structure

The project follows the **MVVM (Model-View-ViewModel)** pattern for separation of concerns:

- **Model**: Defines the structure of stock symbols and stock details (`StockSymbol`, `StockQuote`).
- **View**: The SwiftUI views like `ContentView`, `StockDetailBottomSheet`, which handle the user interface.
- **ViewModel**: The `StockViewModel` handles data fetching from the API and manages the app state (e.g., `isLoading`, `isLoading2`, `stockSymbols`).

---

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/StockApp.git
   ```

2. Open the project in **Xcode**:
   ```bash
   cd StockApp
   open StockApp.xcodeproj
   ```

3. Get a free API key from [Finnhub](https://finnhub.io) and insert it into `StockViewModel`:
   ```swift
   let apiKey = "YOUR_API_KEY"
   ```

4. Build and run the app on the simulator or a real device:
   - Select the target device in Xcode.
   - Press `Cmd + R` to run the project.

---

## Testing

To test the app:

1. Run the app on a simulator or physical device.
2. Search for stock symbols using the search bar.
3. Add stocks to the watchlist.
4. Tap on a stock to view detailed information.
5. Ensure that the app only makes the API call for stock symbols once and persists added stocks between app sessions.

---

## Project Files

- **`ContentView.swift`**: The main screen of the app containing the search bar, stock list, and watchlist.
- **`StockDetailBottomSheet.swift`**: The bottom sheet view that displays detailed stock information.
- **`StockViewModel.swift`**: Handles API requests and manages app state.
- **`StockSymbol.swift`**: Model representing a stock symbol.
- **`StockQuote.swift`**: Model representing detailed stock information.

---

## API Usage

The app uses the [Finnhub API](https://finnhub.io) to fetch stock symbols and stock quotes. To get started, sign up for a free account and generate your API key.

- **Get Stock Symbols**: `https://finnhub.io/api/v1/stock/symbol?exchange=US&token=YOUR_API_KEY`
- **Get Stock Quote**: `https://finnhub.io/api/v1/quote?symbol=SYMBOL&token=YOUR_API_KEY`

Replace `YOUR_API_KEY` in the `StockViewModel` with your Finnhub API key.

---



