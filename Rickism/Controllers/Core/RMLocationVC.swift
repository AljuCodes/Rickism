//
//  RMLocationViewController.swift
//  Rickism
//
//  Created by FAO on 28/08/23.
//

import UIKit

class RMLocationsViewController: UIViewController, RMLocationViewVMDelegate, RMLocationViewDelegate {
    func rmLocationViewDelegate(RMLocationVM: RMLocation) {
        let vc = RMLocationDetailVC(vm: RMLocationVM)
        vc.title = RMLocationVM.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private var rmLocationViewVM = RMLocationViewVM()
    
    func rmDidFectchAllLocations() {
        primaryView.configure(vm: rmLocationViewVM)
    }
    

    private let  primaryView = RMLocationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Locations"
        self.navigationItem.largeTitleDisplayMode = .automatic
        view.addSubview(primaryView)
        view.addConstraintsToFullScreen(to: primaryView)
        rmLocationViewVM.fetchLocations()
        rmLocationViewVM.delegate = self
        primaryView.delegate = self
        addSearchButton()
        // Do any additional setup after loading the view.
    }
    
    private func addSearchButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc
    private func didTapSearch() {
        let vc = RMSearchVC(config: RMSearchVC.Config(type: .location))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    

}
