struct AlarmDTO: Codable {
    let resultCode: String
    let resultMessage: String
    
    static func toResultCode(dto: AlarmDTO) -> String {
        let resultCode = dto.resultCode
        return resultCode
    }
}

struct AlarmResponseDTO: Codable {
    let resultCode: String
    let resultMessage: String
    let data: DataClass

    struct DataClass: Codable {
        let info: [AlarmInfoDTO]
    }
    
    static func toAlarms(dto: AlarmResponseDTO) -> [Alarm] {
        return dto.data.info.map { AlarmInfoDTO.toAlarm(dto: $0) }
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
    
    static func toAlarm(dto: AlarmInfoDTO) -> Alarm {
        var market = ""
        if let firstChar = dto.exchange.first {
            let lowercasedString = String(dto.exchange.dropFirst()).lowercased()
            market = String(firstChar) + lowercasedString
        }
        let isOn = dto.useYn == "Y" ? true : false
        return Alarm(alarmId: dto.pushId, market: market, coinTitle: dto.symbol, setPrice: dto.targetPrice, filter: dto.filter, cycle: dto.frequency, isOn: isOn)
    }
}
