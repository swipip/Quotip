//
//  QuoteCell.swift
//  Quotip
//
//  Created by Gautier Billard on 17/05/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit

protocol QuoteCellDelegate:class {
    func didPressFav(quoteID: Int)
}
class QuoteCell: UICollectionViewCell {
    private lazy var quoteBody: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "American Typewriter", size: 25)
        label.numberOfLines = 0
        return label
    }()
    private lazy var quoteAuthor: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    lazy var rack = ButtonsRack()
    var quote: Quote?
    
    weak var delegate: QuoteCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        rack.delegate = self
        
        addQuoteLabel()
        addAuthor()
        addButtonsRack()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func updateData(quote: Quote) {
        
        let bodyString = quote.body
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 40
        let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        
        let myMutableString = NSMutableAttributedString(
            string: bodyString,
            attributes: attributes)
        
        self.quote = quote
        
        quoteBody.attributedText = myMutableString
        quoteAuthor.text = quote.author
        
    }
    private func addButtonsRack() {
        
        self.addSubview(rack)
        
        func addConstraints(fromView: UIView, toView: UIView) {
            
            fromView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                         fromView.widthAnchor.constraint(equalToConstant: 150),
                                         fromView.topAnchor.constraint(equalTo: toView.bottomAnchor, constant: 50),
                                         fromView.heightAnchor.constraint(equalToConstant: 50)])
        }
        addConstraints(fromView: rack, toView: self.quoteAuthor)
        
    }
    private func addAuthor() {
        
        self.addSubview(quoteAuthor)
        
        func addConstraints(fromView: UIView, toView: UIView) {
            
            fromView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                         fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor ,constant: 0),
                                         fromView.topAnchor.constraint(equalTo: toView.bottomAnchor, constant: 50)])
        }
        addConstraints(fromView: quoteAuthor, toView: self.quoteBody)
        
    }
    private func addQuoteLabel() {
        
        self.addSubview(quoteBody)
        
        func addConstraints(fromView: UIView, toView: UIView) {
            
            fromView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 30),
                                         fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor ,constant: -30),
                                         fromView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: toView.topAnchor, constant: 150)])
        }
        addConstraints(fromView: quoteBody, toView: self)
        
    }
}
extension QuoteCell: ButtonRackDelegate{
    
    func didPressFavorite() {
        if let quote = quote {
            delegate?.didPressFav(quoteID: quote.id)
        }
    }
    
}
