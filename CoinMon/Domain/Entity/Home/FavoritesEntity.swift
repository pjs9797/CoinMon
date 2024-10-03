struct Favorites: Equatable {
    let id: String
    let symbol: String
    let favoritesOrder: Int
}

struct FavoritesForEdit: Equatable {
    let id: String
    let symbol: String
    var favoritesOrder: Int
    var isSelected: Bool
}

struct FavoritesUpdateOrder{
    let symbol: String
    let favoritesOrder: Int
}
