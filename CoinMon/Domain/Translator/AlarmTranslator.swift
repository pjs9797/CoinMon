struct AlarmTranslator {
    static func toResultCode(dto: AlarmDTO) -> String {
        return dto.resultCode
    }
    
    static func toAlarms(dto: AlarmResponseDTO) -> [Alarm] {
        return dto.data.info.map { AlarmInfoTranslator.toAlarm(dto: $0) }
    }
}

struct AlarmInfoTranslator {
    static func toAlarm(dto: AlarmInfoDTO) -> Alarm {
        var market = ""
        if let firstChar = dto.exchange.first {
            let lowercasedString = String(dto.exchange.dropFirst()).lowercased()
            market = String(firstChar) + lowercasedString
        }
        let isOn = dto.useYn == "Y"
        return Alarm(alarmId: dto.pushId, market: market, coinTitle: dto.symbol, setPrice: dto.targetPrice, filter: dto.filter, cycle: dto.frequency, isOn: isOn)
    }
}
