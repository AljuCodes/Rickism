//
//  RMEpisodeViewController.swift
//  Rickism
//
//  Created by FAO on 28/08/23.
//

import UIKit

class RMEpisodeViewController: UIViewController, RMEpisodeListViewDelegate {
    func rmEpisodeListView(_ episodeListView: EpisodeListView, didSelectEpisode episode: RMEpisode) {
        let detailVC = RMEpisodesDetailVC(url: URL(string: episode.url))
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func addSearchButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc
    private func didTapSearch() {
        let vc = RMSearchVC(config: RMSearchVC.Config(type: .episode))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private let episodeListView = EpisodeListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        episodeListView.delegate = self
        view.backgroundColor = .systemBackground
        title = "Episodes"
        self.navigationItem.largeTitleDisplayMode = .automatic
        view.addSubview(episodeListView)
        addSearchButton()
        NSLayoutConstraint.activate([
            episodeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            episodeListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
