//
//  TagCell.swift
//  Quotip
//
//  Created by Gautier Billard on 17/05/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import Foundation
import UIKit

class TagCell: UITableViewCell {

    private lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.text = "Chargement"
        label.font = UIFont.init(name: "American Typewriter", size: 25)
        label.numberOfLines = 3
        label.textAlignment = .left
        label.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        return label
    }()
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 45)
        label.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        return label
    }()
    private var countLabelLeading: NSLayoutConstraint!
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 35, weight: .thin)
        button.setImage(UIImage(systemName: "arrow.right.circle",withConfiguration: config), for: .normal)
        button.alpha = 0.0
        button.tintColor = .black
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    var leadingLabelAnchor: NSLayoutConstraint!
    var quoteTag: Tag?
    var buttonTapped: ((Tag)->Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        addButton()
        addLabel()
        addCountLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func passData(tag: Tag) {
        self.quoteTag = tag
        self.tagLabel.text = tag.name.capitalized
        self.countLabel.text = String(tag.count)
    }
    @objc private func buttonPressed(_ sender:UIButton!){
        if let tag = quoteTag {
            buttonTapped?(tag)
        }
    }
    private func addCountLabel() {
        
        self.addSubview(countLabel)
        
        func addConstraints(fromView: UIView, toView: UIView) {
               
           fromView.translatesAutoresizingMaskIntoConstraints = false
           
            NSLayoutConstraint.activate([fromView.bottomAnchor.constraint(equalTo: toView.topAnchor,constant: 0)])
        }
        addConstraints(fromView: countLabel, toView: self.tagLabel)
        
        countLabelLeading = NSLayoutConstraint(item: countLabel, attribute: .leading, relatedBy: .equal, toItem: tagLabel, attribute: .leading, multiplier: 1, constant: 25)
        
        self.addConstraint(countLabelLeading)
        
    }
    private func addButton() {
        
        self.addSubview(plusButton)
        
        func addConstraints(fromView: UIView, toView: UIView) {
               
           fromView.translatesAutoresizingMaskIntoConstraints = false
           
            NSLayoutConstraint.activate([fromView.widthAnchor.constraint(equalToConstant: 50),
                                         fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor ,constant: -20),
                                        fromView.centerYAnchor.constraint(equalTo: toView.centerYAnchor, constant: 0),
                                        fromView.heightAnchor.constraint(equalTo: toView.heightAnchor,constant: 50)])
        }
        addConstraints(fromView: plusButton, toView: self)
        plusButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        
    }
    private func addLabel() {
        
        self.addSubview(tagLabel)
        
        func addConstraints(fromView: UIView, toView: UIView) {
               
           fromView.translatesAutoresizingMaskIntoConstraints = false
           
            NSLayoutConstraint.activate([fromView.widthAnchor.constraint(equalToConstant: 200),
                                         fromView.centerYAnchor.constraint(equalTo: toView.centerYAnchor ,constant: 20)])
        }
        addConstraints(fromView: tagLabel, toView: self)
        
        leadingLabelAnchor = NSLayoutConstraint(item: tagLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        
        self.addConstraint(leadingLabelAnchor)
        
    }
    func magnify(on: Bool) {
        
        let scale:CGFloat = on ? 1 : 0.6

        UIView.animate(withDuration: 0.5) {
            self.leadingLabelAnchor.constant = on ? 70 : 0
            self.tagLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.countLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.countLabelLeading.constant = on ? 0 : 25
            self.plusButton.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.plusButton.alpha = on ? 1.0 : 0.0
            self.layoutIfNeeded()
        }
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        magnify(on: false)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }

}
