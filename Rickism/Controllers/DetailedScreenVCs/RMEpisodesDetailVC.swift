//
//  RMEpisodesDetailVC.swift
//  Rickism
//
//  Created by FAO on 10/09/23.
//

import UIKit

class RMEpisodesDetailVC: UIViewController {

    private let viewModel: RMEpisodeDetailViewVM
    
    init(url: URL?) {
        self.viewModel = .init(url: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private let detailView = RMEpisodeDetailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episode"
        detailView.delegate = self
        view.addSubview(detailView)
       
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapshare))
        setupLayout()
        viewModel.delegate = self
        viewModel.fetchEpisode()
        
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


extension RMEpisodesDetailVC:  RMEpisodeDetailViewVMDelegate, RMEpisodeDetailViewDelegate {
    // VMDelegate
    func didFetchEpisodeDetails() {
        detailView.configure(with: viewModel)
    }
    
    //     view Delegate
    func rmEpisodeDetailView(_ detailView: RMEpisodeDetailView, didSelect character: RMCharacter) {
        print("this should be working")
        let vc  = RMCharacterDetailViewController(viewModel: .init(character: character))
        vc.title = character.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
