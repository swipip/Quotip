//
//  UserQuoteCell.swift
//  Quotip
//
//  Created by Gautier Billard on 17/05/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit

class UserQuoteCell: UITableViewCell {

    private lazy var quoteAuthor: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    private lazy var quoteBody: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "American Typewriter", size: 25)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    var rack = ButtonsRack()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        addAuthor()
        addQuoteLabel()
        addButtonsRack()
        
    }
    func passData(quote: Quote) {
        quoteAuthor.text = quote.author
        quoteBody.text = quote.body
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
    private func addButtonsRack() {
        rack.setButton(states: [.highlighted,.regular,.regular],tint: .white)
        self.addSubview(rack)
        
        func addConstraints(fromView: UIView, toView: UIView) {
            
            fromView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                         fromView.widthAnchor.constraint(equalToConstant: 150),
                                         fromView.topAnchor.constraint(equalTo: toView.bottomAnchor, constant: 50),
                                         fromView.heightAnchor.constraint(equalToConstant: 50)])
        }
        addConstraints(fromView: rack, toView: self.quoteBody)
        
    }
    private func addQuoteLabel() {
        
        self.addSubview(quoteBody)
        
        func addConstraints(fromView: UIView, toView: UIView) {
            
            fromView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 30),
                                         fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor ,constant: -30),
                                         fromView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: quoteAuthor.bottomAnchor, constant: 10)])
        }
        addConstraints(fromView: quoteBody, toView: self)
        
    }
    private func addAuthor() {
        
        self.addSubview(quoteAuthor)
        
        func addConstraints(fromView: UIView, toView: UIView) {
            
            fromView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 30),
                                         fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor ,constant: 0),
                                         fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 30)])
        }
        addConstraints(fromView: quoteAuthor, toView: self)
        
    }

}
