//
//  RMLocationView.swift
//  Rickism
//
//  Created by FAO on 13/09/23.
//

import UIKit

protocol RMLocationViewDelegate: AnyObject {
    func rmLocationViewDelegate(RMLocationVM: RMLocation)
}

class RMLocationView: UIView {

    weak var delegate: RMLocationViewDelegate?
    
    private var vm: RMLocationViewVM? {
        didSet{
            spinner.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
            UIView.animate(withDuration: 0.3){
                self.tableView.alpha = 1
            }
        }
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.alpha = 0
        table.isHidden = true
        table.register(RMLocationTVC.self, forCellReuseIdentifier: RMLocationTVC.cellIdentifier)
        return table
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubViews(tableView, spinner)
        spinner.startAnimating()
        addConstrains()
        configureTableDataSourceDelegate()
    }
    
    private func configureTableDataSourceDelegate(){
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func addConstrains(){
        addConstraintsToFullScreen(to:tableView)
        addSpinnerDefaultConstraints(to: spinner)
    }
    
    public func configure(vm:RMLocationViewVM){
        self.vm = vm
    }
}


extension RMLocationView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm?.cellViewModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTVC.cellIdentifier, for: indexPath) as? RMLocationTVC else {
            fatalError()
        }
        
        guard let cellVMs = vm?.cellViewModels else {
            fatalError()
        }
        
        let cellVM = cellVMs[indexPath.row]
        cell.configure(with: cellVM)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let locationModel = vm?.location(at: indexPath.row) else {
            return
        }
        delegate?.rmLocationViewDelegate(RMLocationVM: locationModel)
    }
    
}
