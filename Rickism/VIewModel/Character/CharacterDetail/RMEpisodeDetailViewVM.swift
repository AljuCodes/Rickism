//
//  RMCharacterDetailViewVM.swift
//  Rickism
//
//  Created by FAO on 10/09/23.
//

import Foundation

protocol RMEpisodeDetailViewVMDelegate : AnyObject {
    func didFetchEpisodeDetails()
}

final class RMEpisodeDetailViewVM {
    private let endPointURL: URL?
    public var characters :[RMCharacter] = []
    
    private var dataTuple: (episode: RMEpisode, characters: [RMCharacter])?{
        didSet {
            delegate?.didFetchEpisodeDetails()
            createCellViewModels()
        }
    }
    
    enum sectionType {
        case information(viewModels: [RMEpisodeInfoCollectionViewCellVM])
        case characters(viewmodels: [RMCharacterCollectionViewCellViewModel])
    }

    public func character(at index: Int) -> RMCharacter? {
        guard let dataTuple = dataTuple else {
            return nil
        }
        return dataTuple.characters[index]
    }
    
   public weak var delegate: RMEpisodeDetailViewVMDelegate?
    
    public private(set) var cellViewModels: [sectionType] = []
    
    public func createCellViewModels(){
        
        guard let dataTuple = dataTuple else {
            return
        }
        
        let episode = dataTuple.episode
        
        cellViewModels = [
            .information(viewModels: [
                .init(title: "Episode Name", value: episode.name),
                .init(title: "Air Date", value: episode.air_date),
                .init(title: "Episode", value: episode.episode),
                .init(title: "Created", value: CustomDateFormatter.getDateInString(episode.created)),
            ]),
            .characters(viewmodels: characters.compactMap({ character in
                return RMCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.image)
                )
            }))
        ]
        
    }
    

    
    init(url: URL?) {
        self.endPointURL = url
        fetchEpisode()
        
    }
    
    public func fetchEpisode(){
        
        guard let url = endPointURL, let request = RMRequest(url: url) else {
            return
        }
        RMService.shared.execute(request, expecting: RMEpisode.self){ [weak self] result in
            print("Call is working")
            switch result {
            case .success(let model):
                self?.fetchRelatedCharacters(episode: model)
            case .failure(let error ):
                print(String(describing: error))
                break
            }
            
        }
    }
    
    private func fetchRelatedCharacters(episode: RMEpisode){
        let requests: [RMRequest] = episode.characters.compactMap({
            RMRequest(url: URL(string: $0)!)
        })
        
        let group = DispatchGroup()
        
        for request in requests {
            group.enter()
            
            RMService.shared.execute(request, expecting: RMCharacter.self){ result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let model):
                    self.characters.append(model)
                case .failure:
                    break
                }
            }
        }
        group.notify(queue: .main){
            self.dataTuple = (
                episode: episode,
                characters: self.characters
            )
        }
    }
}
