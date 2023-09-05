//
//  RMCharacterViewController.swift
//  Rickism
//
//  Created by FAO on 28/08/23.
//

import UIKit

class RMCharactersViewController: UIViewController, RMCharacterListViewDelegate {
    func rmCharacterListView(_ characterListView: CharacterListView, didSelectCharacter character: RMCharacter) {
        let viewModel = RMCharacterDetailVM(character: character)
        let detailVC = RMCharacterDetailViewController(viewModel: viewModel)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
    

    private let characterListView = CharacterListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        characterListView.delegate = self
        view.backgroundColor = .systemBackground
        title = "Characters"
        self.navigationItem.largeTitleDisplayMode = .automatic
        view.addSubview(characterListView)
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
