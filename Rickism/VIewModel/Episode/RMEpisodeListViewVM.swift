//
//  EpisodeListViewVM.swift
//  Rickism
//
//  Created by FAO on 31/08/23.
//

import Foundation
import UIKit

protocol RMEpisodeListViewVMDelegate: AnyObject {
    func  didLoadInitialEpisodes()
    
    func didSelectEpisode(_ character: RMEpisode)
}

final class RMEpisodeListViewVM: NSObject {
    
    private var cellVMs: [RMEpisodeCollectionViewCellVM] = []
    
    public weak var delegate: RMEpisodeListViewVMDelegate?
    
    private var apiInfo: RMGetAllEpisodesResponse.Info? = nil
    
    private var episodes: [RMEpisode] = []
//    {
//        didSet {
//            for character in characters {
//                let viewModel = RMEpisodeCollectionViewCellVM(
//                    characterName: character.name,
//                    characterStatus: character.status,
//                    characterImageUrl: URL(string: character.image)
//                )
//                cellVMs.append(viewModel)
//            }
//        }
//    }
    
    private var isLoadingMoreEpisodes = false
    
    func fetchEpisodes()  {
        RMService.shared.execute(
            .listEpisodeRequests,
            expecting: RMGetAllEpisodesResponse.self
        ) { [weak self] result in
            switch result {
            case .success(let response):
                let results = response.results
                self?.apiInfo = response.info
                self?.episodes = results
                let tempVM = results.map {
                    result in
                    return RMEpisodeCollectionViewCellVM(episodeDataUrl:URL(string: result.url))
                }
                self?.cellVMs.append(contentsOf: tempVM )
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialEpisodes()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    public func fetchAddicitonalEpisodes(url: URL){
        isLoadingMoreEpisodes = true
        guard let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(
            request,
            expecting: RMGetAllEpisodesResponse.self
        ) {[weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
               
            case .success(let success):
                let results = success.results
//                strongSelf.cellVMs = []
//                strongSelf.characters.append(contentsOf: success.results)
                strongSelf.episodes.append(contentsOf: results)
                
                let newCellVMs = results.map { result in
                    return RMEpisodeCollectionViewCellVM(episodeDataUrl: URL(string: result.url)
                    )
                }
                strongSelf.cellVMs.append(contentsOf: newCellVMs)
                
                strongSelf.isLoadingMoreEpisodes = false
                strongSelf.apiInfo = success.info
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadInitialEpisodes()
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


extension RMEpisodeListViewVM: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cellVMs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterEpisodeCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        cell.configure(with: cellVMs[indexPath.row])
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
        let width = (bounds.width-20)
        return CGSize(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = episodes[indexPath.row]
        delegate?.didSelectEpisode(character)
    }
}


extension RMEpisodeListViewVM: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator, !isLoadingMoreEpisodes,
        let nextUrlString = apiInfo?.next,
        let url = URL(string: nextUrlString) else {
            return
        }
        let offset = scrollView.contentOffset.y
        let totalContentHeight = scrollView.contentSize.height
        let totalScrollViewFixedHeight = scrollView.frame.size.height
        
        if offset > 0, offset >= (totalContentHeight - totalScrollViewFixedHeight - 200){
//            print("Should start fetching more")
            fetchAddicitonalEpisodes(url: url)
        }
    }
}
