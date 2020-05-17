//
//  ButtonsRack.swift
//  Quotip
//
//  Created by Gautier Billard on 17/05/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit

protocol ButtonRackDelegate:class {
    func didPressFavorite()
}
class ButtonsRack: UIView {

    lazy var hStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.spacing = 5
        return stack
    }()
    
    weak var delegate: ButtonRackDelegate?
    private var buttons: [UIButton] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addStackView()
    }
    enum ButtonState{
        case highlighted, regular
    }
    func prepareButtonsForReuse() {
        
    }
    func setButton(states: [ButtonState],tint: UIColor){
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
        for (i,state) in states.enumerated() {
            buttons[i].tintColor = tint
            switch state {
            case .regular:
                if i == 0 {
                    buttons[i].setImage(UIImage(systemName: "plus",withConfiguration: config), for: .normal)
                }else if i == 1 {
                    buttons[i].setImage(UIImage(systemName: "hand.thumbsup",withConfiguration: config), for: .normal)
                }else{
                    buttons[i].setImage(UIImage(systemName: "hand.thumbsdown",withConfiguration: config), for: .normal)
                }
            case .highlighted:
                if i == 0 {
                    buttons[i].setImage(UIImage(systemName: "star.fill",withConfiguration: config), for: .normal)
                    delegate?.didPressFavorite()
                }else if i == 1 {
                    buttons[i].setImage(UIImage(systemName: "hand.thumbsup.fill",withConfiguration: config), for: .normal)
                }else{
                    buttons[i].setImage(UIImage(systemName: "hand.thumbsdown.fill",withConfiguration: config), for: .normal)
                }
            }
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc private func buttonPressed(_ sender:UIButton!){
        
        for (i,button) in buttons.enumerated() {
            if button == sender {
                if i == 0 {
                    let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
                    button.setImage(UIImage(systemName: "star.fill",withConfiguration: config), for: .normal)
                    delegate?.didPressFavorite()
                }else if i == 1 {
                    let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
                    button.setImage(UIImage(systemName: "hand.thumbsup.fill",withConfiguration: config), for: .normal)
                }else{
                    let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
                    button.setImage(UIImage(systemName: "hand.thumbsdown.fill",withConfiguration: config), for: .normal)
                }
            }
        }
        
    }
    private func addStackView() {
        
        self.addSubview(hStack)
        
        let images = ["plus.circle","hand.thumbsup","hand.thumbsdown"]
            for i in 0..<3 {
                let button = UIButton()
                let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
                button.setImage(UIImage(systemName: images[i],withConfiguration: config), for: .normal)
                button.tintColor = .black
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
                button.backgroundColor = .clear
                button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
                buttons.append(button)
                hStack.addArrangedSubview(button)
            }
        
        func addConstraints(fromView: UIView, toView: UIView) {
               
           fromView.translatesAutoresizingMaskIntoConstraints = false
           
            NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                         fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor ,constant: 0),
                                        fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 0),
                                        fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor, constant: 0)])
        }
        addConstraints(fromView: hStack, toView: self)
        
    }
}
