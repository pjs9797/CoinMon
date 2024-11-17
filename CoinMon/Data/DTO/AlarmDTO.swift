import Foundation

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
            .sorted { $0.setPrice > $1.setPrice }
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

struct NotificationAlertDTO: Codable {
    let resultCode: String
    let resultMessage: String
    let data: DataClass

    struct DataClass: Codable {
        let info: [NotificationAlertInfoDTO]
    }
    
    static func toNotificationAlert(dto: NotificationAlertDTO) -> [NotificationAlert] {
        return dto.data.info.map { NotificationAlertInfoDTO.toNotificationAlert(dto: $0) }
            .sorted { $0.id > $1.id }
    }
}

struct NotificationAlertInfoDTO: Codable {
    let pushId: Int
    let exchange: String
    let symbol: String
    let targetPrice: String
    let sendTime: [Int]
    let filter: String
    let type: String

    static func toNotificationAlert(dto: NotificationAlertInfoDTO) -> NotificationAlert {
        let sendDate = Calendar.current.date(from: DateComponents(
            year: dto.sendTime[0],
            month: dto.sendTime[1],
            day: dto.sendTime[2],
            hour: dto.sendTime[3],
            minute: dto.sendTime[4],
            second: dto.sendTime[5]
        ))!

        let timeInterval = Date().timeIntervalSince(sendDate)
        let (date, dateType) = calculateTimeDifference(timeInterval: timeInterval)

        return NotificationAlert(
            id: dto.pushId,
            market: dto.exchange,
            symbol: dto.symbol,
            targetPrice: dto.targetPrice,
            date: date,
            dateType: dateType,
            filter: dto.filter,
            type: dto.type,
            time: sendDate
        )
    }

    static func calculateTimeDifference(timeInterval: TimeInterval) -> (String, String) {
        let minutes = Int(timeInterval / 60)
        let hours = minutes / 60
        let days = hours / 24

        if days > 0 {
            return (String(days), "일")
        } else if hours > 0 {
            return (String(hours), "시간")
        } else {
            return (String(minutes), "분")
        }
    }
}
