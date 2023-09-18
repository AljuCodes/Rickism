//
//  RMSearchOptionPickerVC.swift
//  Rickism
//
//  Created by FAO on 17/09/23.
//

import UIKit

class RMSearchOptionPickerVC: UIViewController {
    private let option: RMSearchInputViewVM.DynamicOption
    private let selectionBlock: ((String)-> Void)
    
    private let tableView: UITableView =  {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    init(options: RMSearchInputViewVM.DynamicOption, selection: @escaping (String) -> Void) {
        self.option = options
        self.selectionBlock = selection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.addConstraintsToFullScreen(to: tableView)
    }
}


extension RMSearchOptionPickerVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return option.choices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let choice = option.choices[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = choice.capitalized
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
     dismiss(animated: true)
        let choice = option.choices[indexPath.row]
        self.selectionBlock(choice)
        dismiss(animated: true)
    }
    
}
