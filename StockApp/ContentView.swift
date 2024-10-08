import SwiftUI

struct ContentView: View {
    @ObservedObject var stockViewModel = StockViewModel()
    @State private var searchText: String = ""
    @State private var selectedStock: StockSymbol? = nil
    @State private var showDetailSheet: Bool = false

    var filteredStocks: [StockSymbol] {
        if searchText.isEmpty {
            return stockViewModel.stockSymbols
        } else {
            return stockViewModel.stockSymbols.filter {
                $0.symbol.lowercased().contains(searchText.lowercased()) ||
                $0.description.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                
                Text("Stocks")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top)
                
                TextField("Search Stocks", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                // Show ProgressView if loading
                if stockViewModel.isLoading {
                    ProgressView("Loading stocks...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .padding()
                } else {
                    // Scrollable Search Results with a fixed height
//                    Text("Search Results")
//                        .font(.headline)
//                        .padding(.leading)
//                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    List {
                        ForEach(filteredStocks) { stock in
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(stock.description)
                                        .font(.headline)
                                        .lineLimit(1)
                                    Text(stock.symbol)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Button(action: {
                                    stockViewModel.addStock(stock)
                                }) {
                                    Label("Add", systemImage: "plus.circle.fill")
                                        .labelStyle(.iconOnly)
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 9)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
//                            .shadow(radius: 3)
                        }
                    }
                    .frame(maxHeight: 400) // Limit the height of the search results list
                    .listStyle(PlainListStyle())
                }

                // Scrollable Added Stocks Section
                Text("Added Stocks")
                    .font(.title2)
                    .bold()
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if stockViewModel.mainStocks.isEmpty {
                    Text("No stocks added yet.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(stockViewModel.mainStocks) { stock in
                                HStack {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(stock.symbol)
                                            .font(.headline)
                                        Text(stock.description)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Button(action: {
                                        stockViewModel.removeStock(stock)
                                    }) {
                                        Label("Remove", systemImage: "trash.fill")
                                            .labelStyle(.iconOnly)
                                            .foregroundColor(.red)
                                    }
                                }
                                .padding(.vertical, 8)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .onTapGesture {
                                    selectedStock = stock
                                    stockViewModel.fetchStockDetails(for: stock.symbol)
                                    showDetailSheet.toggle()
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 200) // Set a fixed height for scrollable added stocks
                }

                Spacer()
            }
            .sheet(isPresented: $showDetailSheet) {
                if let stock = selectedStock {
                    StockDetailBottomSheet(
                        stock: stock,
                        stockQuote: stockViewModel.stockQuote,
                        isLoading: stockViewModel.isLoading // Pass loading state
                    )
                }
            }
            .alert(isPresented: $stockViewModel.showAlert) {
                Alert(title: Text("Error"),
                      message: Text(stockViewModel.errorMessage),
                      dismissButton: .default(Text("OK")))
            }
        }
        .onAppear {
            stockViewModel.fetchStockSymbols() // Ensure this is only called once
        }
        .background(Color.black.edgesIgnoringSafeArea(.all)) // Background color
        .accentColor(.white) // Accent color for navigation
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
