import SwiftUI
import Combine

struct StockSymbol: Codable, Identifiable {
    var id: String { symbol }
    let symbol: String
    let description: String
    let currency: String
    let type: String
}

class StockViewModel: ObservableObject {
    @Published var stockSymbols: [StockSymbol] = []
    @Published var mainStocks: [StockSymbol] = [] // User-added stocks
    @Published var stockQuote: StockQuote?
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var isLoading2: Bool = false
    @Published var showAlert: Bool = false

    let apiKey = "cru5avhr01qi6bkaao30cru5avhr01qi6bkaao3g"
    let userDefaultsKey = "MainStocks" // Key for UserDefaults

    init() {
        loadMainStocks()
    }


    // Fetch the list of available stock symbols
    func fetchStockSymbols() {
            guard stockSymbols.isEmpty else { return } // Ensure this is called only once
            self.isLoading = true
            let urlString = "https://finnhub.io/api/v1/stock/symbol?exchange=US&token=\(apiKey)"
            guard let url = URL(string: urlString) else {
                DispatchQueue.main.async {
                    self.errorMessage = "Invalid URL"
                    self.showAlert = true
                    self.isLoading = false
                }
                return
            }
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Network error: \(error.localizedDescription)"
                        self.showAlert = true
                        self.isLoading = false
                    }
                    return
                }
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.errorMessage = "No data received"
                        self.showAlert = true
                        self.isLoading = false
                    }
                    return
                }
                do {
                    let stockSymbols = try JSONDecoder().decode([StockSymbol].self, from: data)
                    DispatchQueue.main.async {
                        self.stockSymbols = stockSymbols
                        self.isLoading = false
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to decode: \(error.localizedDescription)"
                        self.showAlert = true
                        self.isLoading = false
                    }
                }
            }.resume()
        }
        // Fetch stock details
    func fetchStockDetails(for symbol: String) {
            self.stockQuote = nil
            self.isLoading2 = true // Start loading
            let urlString = "https://finnhub.io/api/v1/quote?symbol=\(symbol)&token=\(apiKey)"
            guard let url = URL(string: urlString) else {
                DispatchQueue.main.async {
                    self.errorMessage = "Invalid URL"
                    self.showAlert = true
                    self.isLoading2 = false // Reset loading state
                }
                return
            }
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Network error: \(error.localizedDescription)"
                        self.showAlert = true
                        self.isLoading2 = false // Reset loading state on error
                    }
                    return
                }
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.errorMessage = "No data received"
                        self.showAlert = true
                        self.isLoading2 = false // Reset loading state on no data
                    }
                    return
                }
                do {
                    let stockQuote = try JSONDecoder().decode(StockQuote.self, from: data)
                    DispatchQueue.main.async {
                        self.stockQuote = stockQuote
                        self.isLoading2 = false // Reset loading state on success
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to decode: \(error.localizedDescription)"
                        self.showAlert = true
                        self.isLoading2 = false // Reset loading state on decoding failure
                    }
                }
            }.resume()
        }
    
    
    // Add a stock to the main list and persist it
    func addStock(_ stock: StockSymbol) {
        if !mainStocks.contains(where: { $0.symbol == stock.symbol }) {
            mainStocks.append(stock)
            saveMainStocks() // Save to UserDefaults after adding
        }
    }

    // Remove a stock from the main list and persist the change
    func removeStock(_ stock: StockSymbol) {
        mainStocks.removeAll { $0.symbol == stock.symbol }
        saveMainStocks() // Save to UserDefaults after removing
    }

    // Save the mainStocks array to UserDefaults
    private func saveMainStocks() {
        do {
            let encodedData = try JSONEncoder().encode(mainStocks)
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
        } catch {
            print("Failed to save main stocks: \(error)")
        }
    }

    // Load the mainStocks array from UserDefaults
    private func loadMainStocks() {
        guard let savedData = UserDefaults.standard.data(forKey: userDefaultsKey) else { return }
        do {
            mainStocks = try JSONDecoder().decode([StockSymbol].self, from: savedData)
        } catch {
            print("Failed to load main stocks: \(error)")
        }
    }
}
