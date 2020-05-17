//
//  ViewController.swift
//  Quotip
//
//  Created by Gautier Billard on 17/05/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(TagCell.self, forCellReuseIdentifier: CellID.main)
        table.isScrollEnabled = false
        table.backgroundColor = .clear
        table.isUserInteractionEnabled = true
        table.separatorStyle = .none
        return table
    }()
    
    private lazy var cards: CardsView = {
        let cards = CardsView()
        return cards
    }()
    
    var quotesViewModel: QuotesTableViewModel?
    var selectedCellIndexPath: IndexPath = IndexPath(item: 2, section: 0)
    
    struct CellID {
        static let main = "cell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quotesViewModel = QuotesTableViewModel(view: self)
        
        addGestureRecognizers()
        
        let button = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(userButtonTapped(_:)))
        button.tintColor = .black
        navigationItem.rightBarButtonItem = button
        
        self.title = "Exploration"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        addCards()
        addTableView()
        
    }
    func passUser(user: UserID) {
        self.quotesViewModel?.currentUser = user
        quotesViewModel?.fetchUserQuotes(url: "https://favqs.com/api/quotes/?filter=\(user.login)&type=user")
    }
    @objc private func userButtonTapped(_ sender:UIButton!){
        
        let vc = UserLogin()
        vc.userLoggedIn = passUser(user:)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let cell = tableView.cellForRow(at: IndexPath(item: 1, section: 0)) as? TagCell{
            cell.magnify(on:true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    private func addGestureRecognizers() {
        let upSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        upSwipeGesture.direction = .up
        self.view.addGestureRecognizer(upSwipeGesture)
        
        let downSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        downSwipeGesture.direction = .down
        self.view.addGestureRecognizer(downSwipeGesture)
    }
    
    private func magnifyCell(on: Bool) {
        if let cell = tableView.cellForRow(at: selectedCellIndexPath) as? TagCell {
            cell.magnify(on: on)
        }
    }
    
    @objc private func handleSwipe(_ recognizer:UISwipeGestureRecognizer) {
        switch recognizer.direction {
        case .up:
            magnifyCell(on: false)
            let nextPath = IndexPath(item: min(selectedCellIndexPath.row + 1,19), section: 0)
            tableView.scrollToRow(at: nextPath, at: .middle, animated: true)
            selectedCellIndexPath.row += 1
            magnifyCell(on: true)
            cards.moveUp()
        case .down:
            magnifyCell(on: false)
            let nextPath = IndexPath(item: max(selectedCellIndexPath.row - 1,0), section: 0)
            tableView.scrollToRow(at: nextPath, at: .middle, animated: true)
            selectedCellIndexPath.row -= 1
            magnifyCell(on: true)
            cards.moveDown()
        default:
            break
        }
    }
    private func addCards() {
        
        self.view.addSubview(cards)
        
        func addConstraints(fromView: UIView, toView: UIView) {
               
           fromView.translatesAutoresizingMaskIntoConstraints = false
           
            NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                         fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor ,constant: 0),
                                        fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 0),
                                        fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor,constant: 0)])
        }
        addConstraints(fromView: cards, toView: self.view)
        
    }
    private func addTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
        
        func addConstraints(fromView: UIView, toView: UIView) {
               
           fromView.translatesAutoresizingMaskIntoConstraints = false
           
            NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                         fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor ,constant: 0),
                                         fromView.centerYAnchor.constraint(equalTo: toView.layoutMarginsGuide.centerYAnchor, constant: 0),
                                         fromView.heightAnchor.constraint(equalToConstant: (400))])
        }
        addConstraints(fromView: tableView, toView: self.view)
        

        
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.main, for: indexPath) as! TagCell
        
        if let tag = quotesViewModel?.typeheads?.tags[indexPath.row]{
            cell.passData(tag: tag)
        }
        
        cell.buttonTapped = buttonTapped
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let sizeHeight = 400 / 3
        
        return CGFloat(sizeHeight)
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    func buttonTapped(tag: Tag){
        cards.animateCardForQuoteDisplay(on: true)
        
        UIView.animate(withDuration: 0.4) {
            self.tableView.alpha = 0.0
            self.navigationController?.navigationBar.alpha = 0.0
        }
        
        let vc = DetailQuoteView()
        vc.updateData(tag: tag, user: quotesViewModel?.currentUser)
        
        vc.controllerDismissed = { [weak self] in
            self?.navigationController?.navigationBar.alpha = 1.0
            self?.cards.animateCardForQuoteDisplay(on: false)
        UIView.animate(withDuration: 0.5) {
            self?.tableView.alpha = 1.0
        }}
        
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
}

