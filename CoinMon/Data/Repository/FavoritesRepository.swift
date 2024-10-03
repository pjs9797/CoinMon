import Moya
import RxMoya
import RxSwift

class FavoritesRepository: FavoritesRepositoryInterface {
    private var provider = MoyaProvider<FavoritesService>()
    
    func createFavorites(market: String, symbol: String) -> Observable<String> {
        return provider.rx.request(.createFavorites(market: market, symbol: symbol))
            .filterSuccessfulStatusCodes()
            .map(FavoritesResponseDTO.self)
            .map{ FavoritesResponseDTO.toResultCode(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func fetchFavorites(market: String) -> Observable<[Favorites]> {
        return provider.rx.request(.fetchFavorites(market: market))
            .filterSuccessfulStatusCodes()
            .map(FavoritesResponseDTO.self)
            .map{ FavoritesResponseDTO.toFavorites(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func deleteFavorites(favoritesId: String) -> Observable<String> {
        return provider.rx.request(.deleteFavorites(favoritesId: favoritesId))
            .filterSuccessfulStatusCodes()
            .map(FavoritesResponseDTO.self)
            .map{ FavoritesResponseDTO.toResultCode(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func updateFavorites(market: String, favoritesUpdateOrder: [FavoritesUpdateOrder]) -> Observable<String> {
        let favoritesUpdateOrderDtos = favoritesUpdateOrder.map { FavoritesUpdateOrderDTO.toFavoritesUpdateOrderDTO(entity: $0) }
        return provider.rx.request(.updateFavorites(market: market, favoritesUpdateOrder: favoritesUpdateOrderDtos))
            .filterSuccessfulStatusCodes()
            .map(FavoritesResponseDTO.self)
            .map{ FavoritesResponseDTO.toResultCode(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
}
