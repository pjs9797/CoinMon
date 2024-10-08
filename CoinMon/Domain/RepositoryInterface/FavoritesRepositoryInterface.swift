import RxSwift

protocol FavoritesRepositoryInterface {
    func createFavorites(market: String, symbol: String) -> Observable<String>
    func fetchFavorites(market: String) -> Observable<[Favorites]>
    func deleteFavorites(favoritesId: String) -> Observable<String>
    func updateFavorites(market: String, favoritesUpdateOrder: [FavoritesUpdateOrder]) -> Observable<String>
    func fetchCoinPriceChangeGapListByFavorites(exchange: String) -> Observable<[CoinPriceChangeGap]>
}
