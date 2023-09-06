//
//  RMCharacterDetailVM.swift
//  Rickism
//
//  Created by FAO on 01/09/23.
//

import UIKit

final class RMCharacterDetailVM{

    
    enum SectionType {
        case photo(viewModel: RMCharacterPhotoCollectionViewCellVM)
        case information(viewModels: [RMCharacterInforCollectionViewCell])
        case episodes(viewModels: [RMCharacterEpisodeCollectionViewCellVM])
    }
    
    public var  sections :[SectionType] = []
    
    private let character: RMCharacter
    
    init(character: RMCharacter) {
        self.character = character
        setupSections()
    }
    
    private func setupSections() {
        self.sections = [
            .photo(viewModel: .init()),
            .information(viewModels: [
                .init(),
                .init(),
                .init(),
                .init()
            ]),
            .episodes(viewModels: [
                .init(),
                       .init(),
                       .init(),
                       .init()])
            
            
        ]
    }
    
    public var title: String {
        character.name.uppercased()
    }
    
    public var imageUrl: String {
        character.image
    }

// Photo section
public func createPhotoSectionLayout() ->
    NSCollectionLayoutSection {
       let item = NSCollectionLayoutItem(
           layoutSize: NSCollectionLayoutSize(
               widthDimension: .fractionalWidth(1.0),
               heightDimension: .fractionalHeight(1.0)
           )
           
       )
       item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
       let group = NSCollectionLayoutGroup.vertical(
           layoutSize: NSCollectionLayoutSize(
               widthDimension: .fractionalWidth(1.0),
               heightDimension: .absolute(150)),
               subitems: [item]
       )
       let section = NSCollectionLayoutSection(group:  group)
       return section
   }



public func createInfoSectionLayout() ->
    NSCollectionLayoutSection {
       let item = NSCollectionLayoutItem(
           layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
               heightDimension: .fractionalHeight(1.0)
           )
           
       )
       item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
       let group = NSCollectionLayoutGroup.horizontal(
           layoutSize: NSCollectionLayoutSize(
               widthDimension: .fractionalWidth(1.0),
               heightDimension: .absolute(150)),
               subitems: [item, item]
       )
       let section = NSCollectionLayoutSection(group:  group)
       return section
   }


public func createEpisodeSectionLayout() ->
    NSCollectionLayoutSection {
       let item = NSCollectionLayoutItem(
           layoutSize: NSCollectionLayoutSize(
               widthDimension: .fractionalWidth(1.0),
               heightDimension: .fractionalHeight(1.0)
           )
       )
       item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 8)
       let group = NSCollectionLayoutGroup.horizontal(
           layoutSize: NSCollectionLayoutSize(
               widthDimension: .fractionalWidth(1.0),
               heightDimension: .absolute(150)),
               subitems: [item]
       )
       let section = NSCollectionLayoutSection(group:  group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
   }

}
