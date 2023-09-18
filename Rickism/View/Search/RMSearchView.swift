//
//  RMSearchView.swift
//  Rickism
//
//  Created by FAO on 16/09/23.
//

import UIKit

protocol RMSearchViewDelegate: AnyObject {
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewVM.DynamicOption)
}


final class RMSearchView: UIView {
    private let vm: RMSearchViewVM
    
    private let noResultView = RMNoSearchResultView()
    private let searchInputView = RMSearchInputView()
     
    weak var delegate : RMSearchViewDelegate?
    
    init(frame: CGRect, viewModel: RMSearchViewVM) {
        self.vm = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
         addSubViews(noResultView, searchInputView)
         addConstraints()
        searchInputView.delegate = self
        searchInputView.configure(vm: .init(type: vm.config.type))
        vm.registerOptionChangeBlock { tuple in
            self.searchInputView.update(option: tuple.0, value: tuple.1)
            
        }
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leftAnchor.constraint(equalTo: leftAnchor),
            searchInputView.rightAnchor.constraint(equalTo: rightAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: vm.config.type == .episode ? 60: 110),
            
            noResultView.widthAnchor.constraint(equalToConstant: 180),
            noResultView.heightAnchor.constraint(equalToConstant: 180),
            noResultView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func presentKeyBoard(){
        searchInputView.presentKeyboard()
    }
}

// MARK: collection view stuff

extension RMSearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension RMSearchView : RMSearchInputViewDelegate {
    func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String) {
        vm.set(query: text)
    }
    
    func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputView) {
        vm.executeSearch()
    }
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewVM.DynamicOption) {
        delegate?.rmSearchView(self, didSelectOption: option)
    }
    
    
}
