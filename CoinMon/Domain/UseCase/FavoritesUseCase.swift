import RxSwift

class FavoritesUseCase {
    private let repository: FavoritesRepositoryInterface

    init(repository: FavoritesRepositoryInterface) {
        self.repository = repository
    }
    
    func createFavorites(market: String, symbol: String) -> Observable<String> {
        let marketUpper = market.uppercased()
        return repository.createFavorites(market: marketUpper, symbol: symbol)
    }
    
    func fetchFavorites(market: String) -> Observable<[Favorites]> {
        let marketUpper = market.uppercased()
        return repository.fetchFavorites(market: marketUpper)
    }
    
    func fetchFavoritesForEdit(market: String) -> Observable<[FavoritesForEdit]> {
        let marketUpper = market.uppercased()
        return repository.fetchFavorites(market: marketUpper).map{ favorites in
            var editFavorites = favorites.map {
                FavoritesForEdit(id: $0.id, symbol: $0.symbol, favoritesOrder: $0.favoritesOrder, isSelected: false)
            }
            editFavorites.insert(FavoritesForEdit(id: "all", symbol: "전체", favoritesOrder: 0, isSelected: false), at: 0)
            return editFavorites
        }
    }
    
    func deleteFavorites(favoritesId: String) -> Observable<String> {
        return repository.deleteFavorites(favoritesId: favoritesId)
    }
    
    func updateFavorites(market: String, favoritesUpdateOrder: [FavoritesUpdateOrder]) -> Observable<String> {
        let marketUpper = market.uppercased()
        let sortedFavoritesUpdateOrder = favoritesUpdateOrder.sorted { $0.favoritesOrder < $1.favoritesOrder }
        return repository.updateFavorites(market: marketUpper, favoritesUpdateOrder: sortedFavoritesUpdateOrder)
    }
    
    func fetchCoinPriceChangeGapListByFavorites(market: String) -> Observable<[CoinPriceChangeGap]> {
        let marketUpper = market.uppercased()
        return repository.fetchCoinPriceChangeGapListByFavorites(exchange: marketUpper)
    }
}
