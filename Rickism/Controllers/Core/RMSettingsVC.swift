//

    import Foundation
    import UIKit
    import SwiftUI
    import SafariServices
    import StoreKit
    final class RMSettingsVC: UIViewController {
        
        private var settingsSwiftUIController: UIHostingController<RMSettingsView>?
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .systemBackground
            title = "Settings"
            self.navigationItem.largeTitleDisplayMode = .automatic
            // Do any additional setup after loading the view.
            addSwiftUIController()
        }
        
        private func handleTap(option: RMSettingsOption){
            guard Thread.current.isMainThread else {
                return
            }
            if let url = option.targetUrl {
                let vc = SFSafariViewController(url: url)
                present(vc, animated: true)
            } else if option == .rateApp {
                if let windowScene = view.window?.windowScene {
                    SKStoreReviewController.requestReview(in: windowScene)
                }
            }
        }
        
        
        
        private func addSwiftUIController(){
            let settingsSwiftUIController = UIHostingController(rootView: RMSettingsView(
                viewModel: RMSettingsViewViewModel(
                    cellViewModels: RMSettingsOption.allCases.compactMap({
                        return RMSettingsCellViewModel(type: $0){ option in
                            print(option.displayTitle)
                            self.handleTap(option: option)
                        }
                    })
            )))
            addChild(settingsSwiftUIController)
            settingsSwiftUIController.didMove(toParent: self)
            
            view.addSubview(settingsSwiftUIController.view)
            settingsSwiftUIController.view.translatesAutoresizingMaskIntoConstraints = false

            
            NSLayoutConstraint.activate([
                settingsSwiftUIController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                settingsSwiftUIController.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                settingsSwiftUIController.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                settingsSwiftUIController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
            
            self.settingsSwiftUIController = settingsSwiftUIController
        }
    }
