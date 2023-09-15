

import Foundation

protocol RMLocationDetailViewVMDelegate : AnyObject {
    func didFetchEpisodeDetails()
}

final class RMLocationDetailViewVM {
    public var characters :[RMCharacter] = []
    public var locationVM: RMLocation
    
    private var dataTuple: (location: RMLocation, characters: [RMCharacter])?{
        didSet {
            createCellViewModels()
            delegate?.didFetchEpisodeDetails()
            
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
    
   public weak var delegate: RMLocationDetailViewVMDelegate?
    
    public private(set) var cellViewModels: [sectionType] = []
    
    public func createCellViewModels(){
        
        guard let dataTuple = dataTuple else {
            return
        }
        
        let location = dataTuple.location
        
        cellViewModels = [
            .information(viewModels: [
                .init(title: "Location Name", value: location.name),
                .init(title: "Dimension", value: location.dimension),
                .init(title: "Type", value: location.type),
                .init(title: "Created", value: CustomDateFormatter.getDateInString(location.created)),
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
    

    
    init(vm: RMLocation) {
        self.locationVM = vm
    }
    
    public func fetchRelatedCharacters(location: RMLocation){
        let requests: [RMRequest] = location.residents.compactMap({
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
                    DispatchQueue.main.async {
                        self.characters.append(model)
                    }
                case .failure:
                    break
                }
            }
        }
        group.notify(queue: .main){
            self.dataTuple = (
                location: location,
                characters: self.characters
            )
        }
    }
}
