//
//  RMLocationDetailVC.swift
//  Rickism
//
//  Created by FAO on 10/09/23.
//

import UIKit

class RMLocationDetailVC: UIViewController {

    private let viewModel: RMLocationDetailViewVM
    
    init(vm: RMLocation) {
        self.viewModel = .init(vm: vm)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private let detailView = RMLocationDetailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Location"
        detailView.delegate = self
        view.addSubview(detailView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapshare))
        setupLayout()
        viewModel.delegate = self
        viewModel.fetchRelatedCharacters(location: viewModel.locationVM)
        
    }
    
    
    @objc
    private func didTapshare() {
        
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}


extension RMLocationDetailVC:  RMLocationDetailViewVMDelegate, RMLocationDetailViewDelegate {
    // VMDelegate
    func didFetchEpisodeDetails() {
        detailView.configure(with: viewModel)
    }
    
    //     view Delegate
    func rmEpisodeDetailView(_ detailView: RMLocationDetailView, didSelect character: RMCharacter) {
        print("this should be working")
        let vc  = RMCharacterDetailViewController(viewModel: .init(character: character))
        vc.title = character.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
