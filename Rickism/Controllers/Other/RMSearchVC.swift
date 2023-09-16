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
        title = self.config.type.title
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
    }
    
    struct Config {
        enum configType {
            case character
            case episode
            case location
            
            var title: String {
                return "Search \(String(describing: self).capitalized)"
            }
        }
        let type : configType
        
    }
    
    private let config: Config
    
    init(config: Config) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
        
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
    }
    */

}
