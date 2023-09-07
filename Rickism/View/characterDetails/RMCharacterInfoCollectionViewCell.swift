//
//  RMCharacterInfoCollectionView.swift
//  Rickism
//
//  Created by FAO on 06/09/23.
//

import UIKit

class RMCharacterInfoCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RMCharacterInfoCollectionView"
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    private let titleLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Location"
        return label
    }()
    
    
    private let valueLable: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .light)
        return label
    }()
    
    
    
    private let iconImageView: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(systemName: "globe.americas")
//        icon.contentMode = .scaledToFit
        return icon
    }()
    
    private let titleContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubViews(
            titleContainerView,
            valueLable,
            iconImageView
        )
        titleContainerView.addSubview(titleLable)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            titleContainerView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            titleContainerView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            titleContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleContainerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.33),
            
            titleLable.centerXAnchor.constraint(equalTo: titleContainerView.centerXAnchor),
            titleLable.centerYAnchor.constraint(equalTo: titleContainerView.centerYAnchor),

            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35),
            iconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),

            valueLable.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10),
            valueLable.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            valueLable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 36),
            valueLable.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        valueLable.text = nil
        titleLable.text = nil
        iconImageView.image = nil
        iconImageView.tintColor = .label
        titleLable.textColor = .label
    }
    
    public func configure(with viewModel: RMCharacterInfoCollectionViewCellVM){
        titleLable.text = viewModel.title
        titleLable.textColor = viewModel.tintColor
        valueLable.text = viewModel.displayValue
        iconImageView.tintColor = viewModel.tintColor
        
    }
    
}
