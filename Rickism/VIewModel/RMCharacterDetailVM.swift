//
//  RMCharacterDetailVM.swift
//  Rickism
//
//  Created by FAO on 01/09/23.
//

import UIKit

final class RMCharacterDetailVM{

    
    enum SectionType: CaseIterable {
        case photo
        case information
        case episodes
    }
    
    public let  sections = SectionType.allCases
    
    private let character: RMCharacter
    
    init(character: RMCharacter) {
        self.character = character
    }
    
    public var title: String {
        character.name.uppercased()
    }
    
    public var imageUrl: String {
        character.image
    }

}
