import Foundation

extension Notification.Name {
    // 즐겨찾기
    static let favoritesDeleted = Notification.Name("favoritesDeleted")
    static let favoritesAdded = Notification.Name("favoritesAdded")
    static let favoritesUpdated = Notification.Name("favoritesUpdated")
    static let marketStayed = Notification.Name("marketStayed")
    static let marketSelected = Notification.Name("marketSelected")
    static let seeFavorites = Notification.Name("seeFavorites")
    
    // 지표
    static let completeDeleteIndicatorAlarm = Notification.Name("completeDeleteIndicatorAlarm")
    static let receiveTestAlarm = Notification.Name("receiveTestAlarm")
    static let refreshIndicatorHistory = Notification.Name("refreshIndicatorHistory")
    
    // 구매
    static let isPurchased = Notification.Name("isPurchased")
    static let isOutSelectCoinAtPremium = Notification.Name("isOutSelectCoinAtPremium")
    static let isCompletedSelectCoinAtPremium = Notification.Name("isCompletedSelectCoinAtPremium")
}
