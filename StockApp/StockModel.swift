struct StockQuote: Decodable {
    let currentPrice: Double
    let change: Double
    let changePercent: Double
    let high: Double
    let low: Double
    let open: Double
    let previousClose: Double

    enum CodingKeys: String, CodingKey {
        case currentPrice = "c"
        case change = "d"
        case changePercent = "dp"
        case high = "h"
        case low = "l"
        case open = "o"
        case previousClose = "pc"
    }
}
