//
//  RMSearchResultView.swift
//  Rickism
//
//  Created by FAO on 16/09/23.
//

import UIKit

final class RMNoSearchResultView: UIView {
    
    
    private let vm = RMNoSearchResultsViewVM()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubViews(iconView, label)
        addConstraints()
        configure()
        isHidden = true
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .systemBlue
        iconView.translatesAutoresizingMaskIntoConstraints = false
        return iconView
    }()
    
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 90),
            iconView.heightAnchor.constraint(equalToConstant: 90),
            iconView.topAnchor.constraint(equalTo: topAnchor),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            label.leftAnchor.constraint(equalTo: leftAnchor),
            label.rightAnchor.constraint(equalTo: rightAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            label.heightAnchor.constraint(greaterThanOrEqualToConstant:  60),
            label.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 10)

        ])
        }
    
    private func configure(){
        label.text = vm.title
        iconView.image = vm.image
    }
    
    
}
