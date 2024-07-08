struct AlarmDTO: Codable {
    let resultCode: String
    let resultMessage: String
}

struct AlarmResponseDTO: Codable {
    let resultCode: String
    let resultMessage: String
    let data: DataClass

    struct DataClass: Codable {
        let info: [AlarmInfoDTO]
    }
}

struct AlarmInfoDTO: Codable {
    let pushId: Int
    let email: String
    let exchange: String
    let symbol: String
    let targetPrice: String
    let frequency: String
    let filter: String
    let useYn: String
    let expTime: [Int]
}
