import Foundation
import ReactorKit
import RxCocoa
import RxFlow

class EditFavoritesReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let favoritesUseCase: FavoritesUseCase
    
    init(favoritesUseCase: FavoritesUseCase){
        self.favoritesUseCase = favoritesUseCase
    }
    
    enum Action {
        case backButtonTapped
        case saveButtonTapped
        case deleteButtonTapped
        case updateSearchText(String)
        case clearButtonTapped
        case notificationMarketSelected
        case selectMarket(Int)
        case loadFavoritesData
        case toggleFavorite(Int)
        case moveFavorite(from: Int, to: Int)
    }
    
    enum Mutation {
        case setSearchText(String)
        case setWillSelectMarket(Int)
        case setSelectedMarket(Int)
        case setFavoritesData([FavoritesForEdit])
        case setFilteredFavorites([FavoritesForEdit])
        case setIsDataChanged(Bool)
        case setDeleteButtonEnabled(Bool)
    }
    
    struct State {
        var searchText: String = ""
        var willSelectMarket: Int = 0
        var selectedMarket: Int = 0
        var markets: [Market] = [
            Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "Binance"), localizationKey: "Binance"),
            Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "Bybit"), localizationKey: "Bybit"),
            Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "Upbit"), localizationKey: "Upbit"),
            Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "Bithumb"), localizationKey: "Bithumb")
        ]
        var favorites: [FavoritesForEdit] = []
        var filteredFavorites: [FavoritesForEdit] = []
        var isDataChanged: Bool = false
        var isDeleteButtonEnabled: Bool = false
        var originalFavorites: [FavoritesForEdit] = []
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            if currentState.isDataChanged {
                self.steps.accept(HomeStep.presentToUnsavedFavoritesSheetPresentationController)
            } else {
                self.steps.accept(HomeStep.popViewController)
            }
            return .empty()
            
        case .saveButtonTapped:
            let updatedFavorites = currentState.favorites.map { favorite -> FavoritesUpdateOrder in
                if let filteredFavorite = currentState.filteredFavorites.first(where: { $0.id == favorite.id }) {
                    return FavoritesUpdateOrder(symbol: filteredFavorite.symbol, favoritesOrder: filteredFavorite.favoritesOrder)
                } else {
                    return FavoritesUpdateOrder(symbol: favorite.symbol, favoritesOrder: -1)
                }
            }
            
            return self.favoritesUseCase.updateFavorites(market: currentState.markets[currentState.selectedMarket].localizationKey, favoritesUpdateOrder: updatedFavorites)
                .flatMap { resultCode -> Observable<Mutation> in
                    if resultCode == "200" {
                        NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
                        self.steps.accept(HomeStep.popViewController)
                    }
                    return .just(.setIsDataChanged(false))
                }
                .catch { [weak self] error in
                    self?.steps.accept(HomeStep.presentToNetworkErrorAlertController)
                    return .empty()
                }
            
        case .deleteButtonTapped:
            var newFavorites = currentState.filteredFavorites
            newFavorites = newFavorites.enumerated().compactMap { index, favorite in
                if index == 0 || !favorite.isSelected {
                    var updatedFavorite = favorite
                    updatedFavorite.favoritesOrder = index
                    return updatedFavorite
                }
                return nil
            }
            let isDataChanged = newFavorites != currentState.originalFavorites
            return .concat([
                .just(.setFilteredFavorites(newFavorites)),
                .just(.setIsDataChanged(isDataChanged)),
                .just(.setDeleteButtonEnabled(false))
            ])
            
        case .updateSearchText(let searchText):
            let filteredFavorites: [FavoritesForEdit]
            if searchText.isEmpty {
                filteredFavorites = currentState.favorites
            } else {
                filteredFavorites = currentState.favorites.filter { $0.symbol.lowercased().contains(searchText.lowercased()) }
            }
            return .concat([
                .just(.setSearchText(searchText)),
                .just(.setFilteredFavorites(filteredFavorites))
            ])
            
        case .clearButtonTapped:
            return .concat([
                .just(.setSearchText("")),
                .just(.setFilteredFavorites(currentState.favorites))
            ])
            
        case .notificationMarketSelected:
            let index = currentState.willSelectMarket
            return self.favoritesUseCase.fetchFavoritesForEdit(market: currentState.markets[index].localizationKey)
                .flatMap { favoritesData -> Observable<Mutation> in
                    var updatedFavoritesData = favoritesData
                    updatedFavoritesData.insert(FavoritesForEdit(id: "all", symbol: "전체", favoritesOrder: 0, isSelected: false), at: 0)
                    return .concat([
                        .just(.setFavoritesData(updatedFavoritesData)),
                        .just(.setFilteredFavorites(updatedFavoritesData)),
                        .just(.setSelectedMarket(index)),
                        .just(.setIsDataChanged(false))
                    ])
                }
                .catch { [weak self] error in
                    self?.steps.accept(HomeStep.presentToNetworkErrorAlertController)
                    return .empty()
                }
            
        case .selectMarket(let index):
            if currentState.isDataChanged {
                self.steps.accept(HomeStep.presentToUnsavedFavoritesSecondSheetPresentationController)
                return .just(.setWillSelectMarket(index))
            }
            else {
                return self.favoritesUseCase.fetchFavoritesForEdit(market: currentState.markets[index].localizationKey)
                    .flatMap { favoritesData -> Observable<Mutation> in
                        var updatedFavoritesData = favoritesData
                        updatedFavoritesData.insert(FavoritesForEdit(id: "all", symbol: "전체", favoritesOrder: 0, isSelected: false), at: 0)
                        return .concat([
                            .just(.setFavoritesData(updatedFavoritesData)),
                            .just(.setFilteredFavorites(updatedFavoritesData)),
                            .just(.setSelectedMarket(index))
                        ])
                    }
                    .catch { [weak self] error in
                        self?.steps.accept(HomeStep.presentToNetworkErrorAlertController)
                        return .empty()
                    }
            }
            
        case .loadFavoritesData:
            return self.favoritesUseCase.fetchFavoritesForEdit(market: "Binance")
                .flatMap { favoritesData -> Observable<Mutation> in
                    var updatedFavoritesData = favoritesData
                    updatedFavoritesData.insert(FavoritesForEdit(id: "all", symbol: "전체", favoritesOrder: 0, isSelected: false), at: 0)
                    return .concat([
                        .just(.setFavoritesData(updatedFavoritesData)),
                        .just(.setFilteredFavorites(updatedFavoritesData)),
                        .just(.setSelectedMarket(0))
                    ])
                }
                .catch { [weak self] error in
                    self?.steps.accept(HomeStep.presentToNetworkErrorAlertController)
                    return .empty()
                }
            
        case .toggleFavorite(let index):
            var newFavorites = currentState.filteredFavorites
            if index == 0 {
                let allSelected = !newFavorites[0].isSelected
                newFavorites = newFavorites.map { var f = $0; f.isSelected = allSelected; return f }
            } else {
                newFavorites[index].isSelected.toggle()
                newFavorites[0].isSelected = newFavorites.dropFirst().allSatisfy { $0.isSelected }
            }
            let isAnySelected = newFavorites.dropFirst().contains { $0.isSelected }
            return .concat([
                .just(.setFilteredFavorites(newFavorites)),
                .just(.setDeleteButtonEnabled(isAnySelected))
            ])
            
        case .moveFavorite(let from, let to):
            var newFavorites = currentState.filteredFavorites
            let favorite = newFavorites.remove(at: from)
            newFavorites.insert(favorite, at: to)
            for (index, var f) in newFavorites.enumerated() {
                f.favoritesOrder = index
                newFavorites[index] = f
            }
            let isDataChanged = newFavorites != currentState.originalFavorites
            return .concat([
                .just(.setFilteredFavorites(newFavorites)),
                .just(.setIsDataChanged(isDataChanged))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSearchText(let searchText):
            newState.searchText = searchText
        case .setWillSelectMarket(let index):
            newState.willSelectMarket = index
        case .setSelectedMarket(let index):
            print("selectedMarket",index)
            newState.selectedMarket = index
        case .setFavoritesData(let favoritesData):
            newState.favorites = favoritesData
            newState.originalFavorites = favoritesData
        case .setFilteredFavorites(let filteredFavorites):
            newState.filteredFavorites = filteredFavorites
        case .setIsDataChanged(let isChanged):
            newState.isDataChanged = isChanged
        case .setDeleteButtonEnabled(let isEnabled):
            newState.isDeleteButtonEnabled = isEnabled
        }
        return newState
    }
}
