//
//  RMSearchVC.swift
//  Rickism
//
//  Created by FAO on 11/09/23.
//

import UIKit

class RMSearchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = self.vm.config.type.title
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .done, target: self, action: #selector(didTapExecuteSearch))
        // Do any additional setup after loading the view.
    }
    
    @objc
    private func didTapExecuteSearch(){
        vm.executeSearch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchView.presentKeyBoard()
    }
    
    private let vm: RMSearchViewVM
    
    private var searchView: RMSearchView
    
    struct Config {
        enum configType {
            case character
            case episode
            case location
            
            var title: String {
                return "Search \(String(describing: self).capitalized)"
            }
            
            var endPoint: RMEndpoint {
                switch self {
                    
                case .character:
                    return .character
                case .episode:
                      return  .episode
                case .location:
                       return .location
                }
            }
        }
        let type : configType
        
    }
    
    
    init(config: Config) {
        self.vm = RMSearchViewVM(config: config)
        self.searchView = RMSearchView(
            frame: .zero,
            viewModel: vm
        )
       super.init(nibName: nil, bundle: nil)
        view.addSubview(searchView)
        searchView.delegate = self
        addContrainst()
    }
    
    
    private func  addContrainst(){
        view.addConstraintsToFullScreen(to: searchView)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }r
    */

}

extension RMSearchVC: RMSearchViewDelegate {
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewVM.DynamicOption) {
        let vc = RMSearchOptionPickerVC(options: option){ [weak self] selection in
            DispatchQueue.main.async {
                self?.vm.setValue(value: selection, for: option)
            }
            
        }
        vc.sheetPresentationController?.detents = [.medium()]
        vc.sheetPresentationController?.prefersGrabberVisible = true
        present(vc, animated: true)
    }
    
    
}
