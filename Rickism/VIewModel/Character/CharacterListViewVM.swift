//
//  CharacterListViewViewModel.swift
//  Rickism
//
//  Created by FAO on 31/08/23.
//

import Foundation
import UIKit

protocol RMCharacterListViewViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
    
    func didSelectCharacter(_ character: RMCharacter)
}

final class CharacterListViewViewModel: NSObject {
    
    private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = []
    
    public weak var delegate: RMCharacterListViewViewModelDelegate?
    
    private var apiInfo: RMGetAllCharactersResponse.Info? = nil
    
    private var characters: [RMCharacter] = []
//    {
//        didSet {
//            for character in characters {
//                let viewModel = RMCharacterCollectionViewCellViewModel(
//                    characterName: character.name,
//                    characterStatus: character.status,
//                    characterImageUrl: URL(string: character.image)
//                )
//                cellViewModels.append(viewModel)
//            }
//        }
//    }
    
    private var isLoadingMoreCharacters = false
    
    func fetchCharacters()  {
        RMService.shared.execute(
            .listCharactersRequests,
            expecting: RMGetAllCharactersResponse.self
        ) { [weak self] result in
            switch result {
            case .success(let response):
                let results = response.results
                self?.apiInfo = response.info
                self?.characters = results
                let tempVM = results.map {
                    result in
                        return RMCharacterCollectionViewCellViewModel(
                            characterName: result.name,
                            characterStatus: result.status,
                            characterImageUrl: URL(string: result.image)
                        )
                }
                self?.cellViewModels.append(contentsOf: tempVM )
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    public func fetchAddicitonalCharacters(url: URL){
        isLoadingMoreCharacters = true
        guard let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(
            request,
            expecting: RMGetAllCharactersResponse.self
        ) {[weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
               
            case .success(let success):
                let results = success.results
                strongSelf.characters.append(contentsOf: results)
                
                let newCellViewModels = results.map { result in
                    return RMCharacterCollectionViewCellViewModel(
                        characterName: result.name,
                        characterStatus: result.status,
                        characterImageUrl: URL(string: result.image)
                    )
                }
                strongSelf.cellViewModels.append(contentsOf: newCellViewModels)
                
                strongSelf.isLoadingMoreCharacters = false
                strongSelf.apiInfo = success.info
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadInitialCharacters()
                }
            case .failure(let failure):
                print(String(describing: failure))
            }
    
            
        }
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    
}


extension CharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        cell.configure(with: cellViewModels[indexPath.row])
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
                for: indexPath) as? RMFooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
        }
        footer.startAnimating()
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
}


extension CharacterListViewViewModel: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator, !isLoadingMoreCharacters,
        let nextUrlString = apiInfo?.next,
        let url = URL(string: nextUrlString) else {
            return
        }
        let offset = scrollView.contentOffset.y
        let totalContentHeight = scrollView.contentSize.height
        let totalScrollViewFixedHeight = scrollView.frame.size.height
        
        if offset > 0, offset >= (totalContentHeight - totalScrollViewFixedHeight - 200){
//            print("Should start fetching more")
            fetchAddicitonalCharacters(url: url)
        }
    }
}
