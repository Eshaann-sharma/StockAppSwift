import SwiftUI

struct StockDetailBottomSheet: View {
    let stock: StockSymbol
    let stockQuote: StockQuote?
    let isLoading: Bool

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 10) {
                Text(stock.description)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("Symbol: \(stock.symbol)")
                    .font(.title3)
                    .foregroundColor(.gray)

                // Check if the stockQuote is nil to show a ProgressView
                if let stockQuote = stockQuote {
                    Text("Current Price: $\(stockQuote.currentPrice, specifier: "%.2f")")
                        .font(.title2)
                        .foregroundColor(.white)

                    Text("Change: \(stockQuote.change, specifier: "%.2f")")
                        .font(.body)
                        .foregroundColor(stockQuote.change >= 0 ? .green : .red)

                    Text("Percentage Change: \(stockQuote.changePercent, specifier: "%.2f")%")
                        .font(.body)
                        .foregroundColor(stockQuote.changePercent >= 0 ? .green : .red)
                } else {
                    // Display ProgressView while data is being loaded
                    ProgressView("Loading stock data...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))// Set the color to blue
                        .foregroundColor(.white)
                        .padding()
                }

                Spacer()
            }
            .padding()
            .frame(width: geometry.size.width)
            .background(Color.black)
        }
        .presentationDetents([.medium, .large])
    }
}

