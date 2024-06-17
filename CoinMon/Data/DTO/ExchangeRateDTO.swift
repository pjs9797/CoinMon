struct ExchangeRateResponse: Codable {
    let date: String
    let usdt: [String: Double]
}
