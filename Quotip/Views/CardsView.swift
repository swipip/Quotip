//
//  CardsView.swift
//  Quotip
//
//  Created by Gautier Billard on 17/05/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import Foundation
import UIKit

class CardsView: UIView {
    
    var cards: [UIView] = []
    var cardsTopConstraints: [NSLayoutConstraint] = []
    let scales =  [0.4,0.6,0.7,0.8,1.0]
    
    let alphas: [CGFloat] = [1,0.8,0.6,0.4,0.2,0]
    let offset: [CGFloat] = [150,120,90,60,30,10]
    
    var originAngle: Double?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addCard(number: 0)
        addCard(number: 1)
        addCard(number: 2)
        addCard(number: 3)
        addCard(number: 4)
        addCard(number: 5)

    }
    func animateCardForQuoteDisplay(on: Bool) {
        
        if on {originAngle = -atan2( Double(self.cards[0].transform.b), Double(self.cards[0].transform.a))}
        var delay: Double = 0.0
        for card in cards {
            
            let angle = -atan2( Double(card.transform.b), Double(card.transform.a))
            
            UIView.animate(withDuration: 0.4, delay: delay, options: .curveEaseIn, animations: {
                card.transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi / 2))
            }) { (_) in
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                    card.transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi / 2) - CGFloat(angle))
                }) { (_) in
                    
                }
            }
            
            delay += 0.05
        }
        
        UIView.animate(withDuration: 0.4, animations: {
            if on {
                self.cards[0].transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
            }else{
                self.cards[0].transform = CGAffineTransform(rotationAngle: -CGFloat(self.originAngle ?? -Double.pi/50) )
            }
        }) { (_) in
            
        }
        
    }
    func moveUp() {
        if let awayCard = cards.first, let awayConstraint = cardsTopConstraints.first {
            
            UIView.animate(withDuration: 0.5, animations: {
                
                for constraint in self.cardsTopConstraints {
                    constraint.constant += 20
                }
                for (i,card) in self.cards.enumerated() {
                    card.alpha += 0.2
                    card.transform = CGAffineTransform(rotationAngle: -(CGFloat.pi / 50 * 6 - CGFloat.pi / 50 * CGFloat(i+1)))
                }
                
                awayCard.alpha = 0.0
                awayConstraint.constant = 300
                
                self.layoutIfNeeded()
            }) { (_) in
                self.addCard(number: 5)
                awayCard.removeFromSuperview()
                self.cardsTopConstraints.removeFirst()
                self.cards.removeFirst()
            }
        }
    }
    
    func moveDown() {
        if let awayCard = cards.last{
            
            self.addCard(number: 0, insert: false)
            self.layoutIfNeeded()
            let newCard = cards.first!
            newCard.alpha = 0.0
            let newConstraint = cardsTopConstraints.first!
            newConstraint.constant -= 200
            
            UIView.animate(withDuration: 0.5, animations: {
                
                newCard.alpha = 1
                newConstraint.constant += 200
                
                for constraint in self.cardsTopConstraints {
                    if constraint != newConstraint{
                        constraint.constant -= 20
                    }
                }
                for (i,card) in self.cards.enumerated() {
                    card.alpha = 1 - 0.2 * CGFloat(i)
                    let radians:Double = -atan2( Double(card.transform.b), Double(card.transform.a))
                    card.transform = CGAffineTransform(rotationAngle: -(CGFloat(radians) - CGFloat.pi / 50))
                }
                
                self.layoutIfNeeded()
            }) { (_) in
                
                awayCard.removeFromSuperview()
                self.cardsTopConstraints.removeLast()
                self.cards.removeLast()
            }
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addCard(number: Int, insert: Bool? = true) {
        
        let card = UIView()
        card.backgroundColor = .white
        card.transform = CGAffineTransform(rotationAngle: -(CGFloat.pi / 50 * 6 - CGFloat.pi / 50 * CGFloat(number+1)))
        card.layer.cornerRadius = 12
        card.alpha = alphas[number]
        card.clipsToBounds = true
        card.isUserInteractionEnabled = false
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemBlue.cgColor,UIColor.systemGreen.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = CGRect(x: 0, y: 0, width: 600, height: 500)
        
        card.layer.addSublayer(gradient)
        
        if insert! {
            self.insertSubview(card, at: 0)
        }else{
            self.addSubview(card)
        }
        
        
        func addConstraints(fromView: UIView, toView: UIView) {
               
           fromView.translatesAutoresizingMaskIntoConstraints = false
           
            NSLayoutConstraint.activate([fromView.widthAnchor.constraint(equalToConstant: 600),
                                         fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor ,constant: 300),
                                        fromView.heightAnchor.constraint(equalToConstant: 500)])
        }
        addConstraints(fromView: card, toView: self)
        
        let topConstraint = NSLayoutConstraint(item: card, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: offset[number])
        self.addConstraint(topConstraint)
        
        if insert! {
            cardsTopConstraints.append(topConstraint)
            cards.append(card)
        }else{
            cardsTopConstraints.insert(topConstraint, at: 0)
            cards.insert(card, at: 0)
        }

        
        
    }
    
}
