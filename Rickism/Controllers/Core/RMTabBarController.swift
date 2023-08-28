//
//  ViewController.swift
//  Rickism
//
//  Created by FAO on 28/08/23.
//

import UIKit

class RMTabBarController: UITabBarController {
    
    let k = K()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTabs()
    }
    
    private func setupTabs(){
        let episodesVC = RMEpisodeViewController()
        let locationsVC = RMLocationsViewController()
        let charactersVC = RMCharactersViewController()
        let settingsVC = RMSettingsViewController()
        
        let episodeNav = UINavigationController(rootViewController: episodesVC)
        let locationNav = UINavigationController(rootViewController: locationsVC)
        let characterNav = UINavigationController(rootViewController: charactersVC)
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        
        episodeNav.tabBarItem = UITabBarItem(
            title: k.episodes,
            image: UIImage(systemName: "tv"),
            tag: 3
        )
        locationNav.tabBarItem = UITabBarItem(
            title: k.episodes,
            image: UIImage(systemName: "globe"),
            tag: 2
        )
        characterNav.tabBarItem = UITabBarItem(
            title: k.episodes,
            image: UIImage(systemName: "person"),
            tag: 1
        )
        settingsVC.tabBarItem = UITabBarItem(
            title: k.episodes,
            image: UIImage(systemName: "gear"),
            tag: 4
        )
        let navbars = [characterNav, locationNav, episodeNav, settingsNav]
        
        for nav in navbars{
            nav.navigationBar.prefersLargeTitles = true
        }
        setViewControllers(navbars, animated: true)
        
    }


}

