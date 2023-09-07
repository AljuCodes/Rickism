//
//  RMCharacterPhotoCollectionView.swift
//  Rickism
//
//  Created by FAO on 06/09/23.
//

import UIKit

class RMCharacterPhotoCollectionViewCell: UICollectionViewCell {
     static let cellIdentifier = "RMCharacterPhotoCollectionView"
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
        imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        addConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    public func configure(with viewModel: RMCharacterPhotoCollectionViewCellVM){
        viewModel.fetchImage{ [weak self] result in
            switch result {
                
            case .success(let data):
                DispatchQueue.main.async {
                print("Image is assigned")
                    self?.imageView.image = UIImage(data: data)
                }
            case .failure:
                break
            }
            }
    }
}
