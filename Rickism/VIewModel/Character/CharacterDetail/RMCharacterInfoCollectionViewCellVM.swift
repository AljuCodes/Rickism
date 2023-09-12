//
//  RMCharacterInforCollectionViewCell.swift
//  Rickism
//
//  Created by FAO on 06/09/23.
//

import Foundation
import UIKit

final class CustomDateFormatter {
    
    public static func getDateInString(_ value: String)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        guard let date = dateFormatter.date(from: value) else {
            fatalError()
        }
        return date.formatted(
            date: Date.FormatStyle.DateStyle.abbreviated, time: Date.FormatStyle.TimeStyle.omitted
        )
    }
}

final class RMCharacterInfoCollectionViewCellVM {
    private let type: infoType
    private let value: String
    
    
    init(type: infoType, value: String) {
        self.value = value
        self.type = type
    }
    
    public var title: String {
        type.displayTitle
    }

    
    public var displayValue: String {
        if value.isEmpty { return "None"}
        
        
        if self.type == .created {
            return CustomDateFormatter.getDateInString(value)
        }
            return value
    }
    
    public var iconImage: UIImage? {
        return type.iconImage
    }
    
    public var tintColor: UIColor {
        return type.tintColor
    }
    
    enum infoType: String {
        case status
        case gender
        case type
        case species
        case origin
        case created
        case location
        case episodeCount
        
        var tintColor: UIColor {
                 switch self {
                 case .status:
                     return .systemBlue
                 case .gender:
                     return .systemRed
                 case .type:
                     return .systemPurple
                 case .species:
                     return .systemGreen
                 case .origin:
                     return .systemOrange
                 case .created:
                     return .systemPink
                 case .location:
                     return .systemYellow
                 case .episodeCount:
                     return .systemMint
                 }
             }
        
        var iconImage: UIImage? {
                  switch self {
                  case .status:
                      return UIImage(systemName: "bell")
                  case .gender:
                      return UIImage(systemName: "bell")
                  case .type:
                      return UIImage(systemName: "bell")
                  case .species:
                      return UIImage(systemName: "bell")
                  case .origin:
                      return UIImage(systemName: "bell")
                  case .created:
                      return UIImage(systemName: "bell")
                  case .location:
                      return UIImage(systemName: "bell")
                  case .episodeCount:
                      return UIImage(systemName: "bell")
                  }
              }
        
        var displayTitle: String {
            switch self {
            case .episodeCount:
                return "EPISODE COUNT"
                
            default:
                return rawValue.uppercased()
            }
                }
        
        
    }

}
