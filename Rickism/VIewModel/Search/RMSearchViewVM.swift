//
//  RMSearchViewVM.swift
//  Rickism
//
//  Created by FAO on 16/09/23.
//

import Foundation

final class RMSearchViewVM {
    
    let config: RMSearchVC.Config
    private var optionMap: [RMSearchInputViewVM.DynamicOption: String] = [:]
    private var searchText = ""
    private var optionMapUpdateBlock: (((RMSearchInputViewVM.DynamicOption, String))-> Void)?
    private var searchResultHandler: ((RMSearchResultVM) -> Void)?
    private var noResultHandler: (()-> Void)?
    
    private var searchResultModel: Codable?
    
    init(config: RMSearchVC.Config) {
        self.config = config
    }
    
    public func registerOptionChangeBlock (
        _ block: @escaping ((RMSearchInputViewVM.DynamicOption, String))-> Void){
            self.optionMapUpdateBlock = block
        }
    
    public func registerSearchResultHandler(_ block: @escaping (RMSearchResultVM) -> Void){
        self.searchResultHandler = block
    }
    
    public func registerNoResultHandler(_ block: @escaping ()-> Void){
        self.noResultHandler = block
    }
    
    public func setValue(value: String, for option: RMSearchInputViewVM.DynamicOption){
        optionMap[option] = value
        optionMapUpdateBlock?((option, value))
    }
    
    public func set(query text: String){
        self.searchText = text
        print("Search text is updated")
    }
    
    

    
    public func executeSearch(){
//        searchText = "Rick"
        
        var queryParams: [URLQueryItem] = [
            URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        ]
        
        queryParams.append(contentsOf: optionMap.enumerated().compactMap({_, element in
            return URLQueryItem(name: element.key.queryArgument, value: element.value)
        }))
        let endpoint = config.type.endPoint
        
        let request = RMRequest(
            endPoint: endpoint,
            queryParameters: queryParams
        )
        switch endpoint {
        case .character:
            makeSearchApiCall(RMGetAllCharactersResponse.self, request: request)
        case .location:
            makeSearchApiCall(RMGetAllLocationsResponse.self, request: request)
        case .episode:
            makeSearchApiCall(RMGetAllEpisodesResponse.self, request: request)
        }

    }

    private func makeSearchApiCall<T: Codable>(_ type: T.Type, request: RMRequest){
        RMService.shared.execute(request, expecting: type){ [weak self] result in
            switch result {
            case .success(let model):
                self?.processSearchResults(model: model)
            case .failure(_):
                self?.handleNoResults()
                break
            }
        }
    }
    
    private func processSearchResults(model: Codable) {
        var resultVM: RMSearchResultType?
        var nextUrl: String?
        if let characterResults = model as? RMGetAllCharactersResponse{
            resultVM = .characters(characterResults.results.compactMap({
                return RMCharacterCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageUrl: URL(string:$0.image)
                )
            }))
            nextUrl = characterResults.info.next
        }
        
        if let episodesResults = model as? RMGetAllEpisodesResponse{
            resultVM = .episodes(episodesResults.results.compactMap({
                return RMEpisodeCollectionViewCellVM(episodeDataUrl: URL(string:$0.url))
            }))
            nextUrl = episodesResults.info.next
        }
        
        if let locationsResults = model as? RMGetAllLocationsResponse{
            resultVM = .locations(locationsResults.results.compactMap({
                return RMLocationTVCVM(location: $0)
            }))
            nextUrl = locationsResults.info.next
        }
        
        if let result = resultVM {
            self.searchResultModel = model
            print(result)
            let vm = RMSearchResultVM(results: result, next: nextUrl)
            self.searchResultHandler?(vm)
        }
        
    }
    
    private func handleNoResults(){
        noResultHandler?()
    }
}



enum RMSearchResultType {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMEpisodeCollectionViewCellVM])
    case locations([RMLocationTVCVM])
}
