//
//  RMSearchInputView.swift
//  Rickism
//
//  Created by FAO on 16/09/23.
//

import UIKit

protocol RMSearchInputViewDelegate: AnyObject {
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewVM.DynamicOption)
    
    func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String)
    
    func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputView)
}

class RMSearchInputView: UIView {

    weak var delegate: RMSearchInputViewDelegate?
    
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private var vm: RMSearchInputViewVM? {
        didSet{
            guard let vm = vm, vm.hasDynamicOptions else {
                return
            }
            let options = vm.options
            createOptionSelectionViews(options: options)
        }
    }
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()
    private func createOptionSelectionViews(options: [RMSearchInputViewVM.DynamicOption]){
        print(options)

        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 58),
        ])
        
        
        
        for x in 0..<options.count {
            let option = options[x]
            let button = createButton(with: option, tag: x)
            stackView.addArrangedSubview(button)
            stackView.spacing = 6
        }
    }
    
    private func createButton(with option: RMSearchInputViewVM.DynamicOption, tag: Int) -> UIButton {
        let button = UIButton()

         
         button.setAttributedTitle(
             NSAttributedString(
             string: option.rawValue,
             attributes: [
                 .font : UIFont.systemFont(ofSize: 18, weight: .medium),
                 .foregroundColor: UIColor.label
             ]
         ),
         for: .normal)
         
         button.tag = tag
         button.backgroundColor = .secondarySystemFill
         button.layer.cornerRadius = 6
         button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        
        return button
    }
    
    @objc
    private func didTapButton(_ sender: UIButton){
        guard let options = vm?.options else {
            return
        }
        let tag = sender.tag
        let selected = options[tag]
        delegate?.rmSearchInputView(self, didSelectOption: selected)
        
        print("Did tap \(selected.rawValue)")
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
//        backgroundColor = .systemPink
        searchBar.delegate = self
        addSubViews(searchBar)
        addConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    public func presentKeyboard(){
        searchBar.becomeFirstResponder()
    }

    private func addConstraints(){
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leftAnchor.constraint(equalTo: leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 58),
        ])
    }
    
    public func configure(vm: RMSearchInputViewVM){
        self.vm = vm
        searchBar.placeholder = vm.searchPlaceholderText
    }
    
    public func update(option: RMSearchInputViewVM.DynamicOption, value: String){
        guard let buttons = stackView.arrangedSubviews as? [UIButton],
              let allOptions = vm?.options,
              let index = allOptions.firstIndex(of: option) else {
            return
        }
        buttons[index].setAttributedTitle(
                NSAttributedString(
                    string: value.capitalized,
                attributes: [
                    .font : UIFont.systemFont(ofSize: 18, weight: .medium),
                    .foregroundColor: UIColor.link
                    
                ]
            ),
            for: .normal)
    }
    
}


extension RMSearchInputView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.rmSearchInputView(self, didChangeSearchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        delegate?.rmSearchInputViewDidTapSearchKeyboardButton(self)
    }
    
}
