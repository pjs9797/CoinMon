import UIKit

struct Exchanges: Equatable{
    let image: UIImage?
    let title: String
}

struct PriceList: Equatable{
    let coinImage: String
    let coinTitle: String
    let price: String
    let change: String
    let gap: String
}

struct FeeList: Equatable{
    let coinImage: String
    let coinTitle: String
    let fee: String
}

struct PremiumList: Equatable{
    let coinImage: String
    let coinTitle: String
    let premium: String
}
