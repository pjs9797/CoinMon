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
            return favorites.map {
                FavoritesForEdit(id: $0.id, symbol: $0.symbol, favoritesOrder: $0.favoritesOrder, isSelected: false)
            }
        }
    }
    
    func deleteFavorites(favoritesId: String) -> Observable<String> {
        return repository.deleteFavorites(favoritesId: favoritesId)
    }
    
    func updateFavorites(market: String, favoritesUpdateOrder: [FavoritesUpdateOrder]) -> Observable<String> {
        let marketUpper = market.uppercased()
        return repository.updateFavorites(market: marketUpper, favoritesUpdateOrder: favoritesUpdateOrder)
    }
}
