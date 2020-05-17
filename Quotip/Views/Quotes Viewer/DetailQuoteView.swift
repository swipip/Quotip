//
//  DetailQuoteView.swift
//  Quotip
//
//  Created by Gautier Billard on 17/05/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import Foundation
import UIKit

class DetailQuoteView: UIViewController {
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        button.setImage(UIImage(systemName: "chevron.compact.left", withConfiguration: config), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collection.register(QuoteCell.self, forCellWithReuseIdentifier: "CellID")
        collection.delegate = self
        collection.dataSource = self
        collection.isPagingEnabled = true
        collection.backgroundColor = .clear
        return collection
    }()
    private lazy var pageNumber: UILabel = {
        let label = UILabel()
        label.text = "1/20"
        label.textColor = .white
        label.backgroundColor = .black
        return label
    }()
    
    var rack = ButtonsRack()
    var quotes: QuoteModel?
    var controllerDismissed: (()->Void)?
    var quoteViewModel: QuoteDetailsViewModel?
    var currentIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        
        addCollection()
        addBackButton()
        addPages()
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(_:)))
        swipeGesture.direction = .down
        self.view.addGestureRecognizer(swipeGesture)
        
        self.currentIndex = IndexPath(item: 0, section: 0)
        
    }
    @objc private func swipeHandler(_ recognizer: UISwipeGestureRecognizer) {
        self.controllerDismissed?()
        self.dismiss(animated: true) {
            
        }
    }
    deinit {
//        print("deinit")
    }
    func updateData(tag: Tag, user: UserID?) {
        
        QuotesManager.shared.fetchQuotes(withTag: tag.name)
        QuotesManager.shared.decodedJson = tags(quotes:)
        
        quoteViewModel = QuoteDetailsViewModel(view: self)
        quoteViewModel?.userId = user
        
    }
    private func tags(quotes: QuoteModel) {
        self.quotes = quotes
        collection.reloadData()
    }
    @objc private func backButtonPressed(_ sender:UIButton!){
        self.controllerDismissed?()
        self.dismiss(animated: true) {
            
        }
    }
    private func addPages() {
        
        self.view.addSubview(pageNumber)
        
        func addConstraints(fromView: UIView, toView: UIView) {
            
            fromView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor ,constant: -20),
                                         fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor,constant: -150)])
        }
        addConstraints(fromView: pageNumber, toView: self.view)
        
    }
    private func addCollection() {
        
        self.view.addSubview(collection)
        
        func addConstraints(fromView: UIView, toView: UIView) {
               
           fromView.translatesAutoresizingMaskIntoConstraints = false
           
            NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                         fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor ,constant: 0),
                                        fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 0),
                                        fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor,constant: 0)])
        }
        addConstraints(fromView: collection, toView: self.view)
        
    }
    private func addBackButton() {
        
        self.view.addSubview(backButton)
        
        func addConstraints(fromView: UIView, toView: UIView) {
               
           fromView.translatesAutoresizingMaskIntoConstraints = false
           
            NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 20),
                                         fromView.widthAnchor.constraint(equalToConstant: 50),
                                        fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 50),
                                        fromView.heightAnchor.constraint(equalToConstant: 50)])
        }
        addConstraints(fromView: backButton, toView: self.view)
        
    }
    
}
extension DetailQuoteView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath) as! QuoteCell
        cell.delegate = self
        if let quote = quotes?.quotes[indexPath.row] {
            cell.updateData(quote: quote)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.view.frame.size
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in collection.visibleCells {
            let indexPath = collection.indexPath(for: cell)
            pageNumber.text = "\(indexPath!.row + 1)/20"
            self.currentIndex = indexPath
        }
        
    }
    
}
extension DetailQuoteView:QuoteCellDelegate {
    
    func didPressFav(quoteID: Int) {
        
        quoteViewModel?.userNotLoggedIn = {
            print("user not logged")
        }
        
        quoteViewModel?.addToFavorite(quoteID: quoteID)

    }
    
}
