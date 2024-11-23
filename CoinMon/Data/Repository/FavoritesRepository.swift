import Moya
import RxMoya
import RxSwift

class FavoritesRepository: FavoritesRepositoryInterface {
    private let provider: MoyaProvider<FavoritesService>
    
    init() {
        provider = MoyaProvider<FavoritesService>(requestClosure: MoyaProviderUtils.requestClosure, session: Session(interceptor: MoyaRequestInterceptor()))
    }
    
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
            .map(FavoritesPriceResponseDTO.self)
            .map{ FavoritesPriceResponseDTO.toFavorites(dto: $0) }
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
    
    func fetchCoinPriceChangeGapListByFavorites(exchange: String) -> Observable<[CoinPriceChangeGap]> {
        return provider.rx.request(.fetchFavorites(market: exchange))
            .filterSuccessfulStatusCodes()
            .map(FavoritesPriceResponseDTO.self)
            .map { FavoritesPriceResponseDTO.toCoinPriceChangeGapsSorted(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
}
