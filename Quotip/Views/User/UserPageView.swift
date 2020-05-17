//
//  UserPageView.swift
//  Quotip
//
//  Created by Gautier Billard on 17/05/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit

class UserPageView: UIViewController {
//    private lazy var backButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = .clear
//        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
//        button.setImage(UIImage(systemName: "chevron.compact.left",withConfiguration: config), for: .normal)
//        button.tintColor = .white
//        button.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)
//        return button
//    }()
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UserQuoteCell.self, forCellReuseIdentifier: "CellID")
        table.isScrollEnabled = true
        table.backgroundColor = .clear
        table.isUserInteractionEnabled = true
        table.separatorStyle = .none
        return table
    }()
    
    var quotesViewModel: QuotesTableViewModel?
    var quoteModel: QuoteModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.view.backgroundColor = .white
        self.title = "Mes Citations"
        
        let backButton:UIButton = UIButton.init(type: .custom)
        backButton.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)
        backButton.setTitle("", for: .normal)
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        backButton.setImage(UIImage(systemName: "chevron.compact.left",withConfiguration: config), for: .normal)
        backButton.tintColor = .white
        backButton.sizeToFit()
        
        let backButtonItem:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem  = backButtonItem
        
        QuotesManager.shared.fetchUsersQuote()
        QuotesManager.shared.decodedJson = decodedJson
        
        applyGradient(self.view)
        
        //        addBackButton()
        addTable()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBarIsHidden(false)
    }
    func decodedJson(_ model: QuoteModel) {
        self.quoteModel = model
        tableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navBarIsHidden(false)
    }
    private func navBarIsHidden(_ on:Bool) {
        navigationController?.navigationBar.isHidden = on
    }
    @objc private func backPressed(_ sender:UIButton!){
        self.navigationController?.popToRootViewController(animated: true)
    }
//    private func addBackButton() {
//
//        self.view.addSubview(backButton)
//
//        func addConstraints(fromView: UIView, toView: UIView) {
//
//            fromView.translatesAutoresizingMaskIntoConstraints = false
//
//            NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
//                                         fromView.widthAnchor.constraint(equalToConstant: 50),
//                                         fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 40),
//                                         fromView.heightAnchor.constraint(equalToConstant: 50)])
//        }
//        addConstraints(fromView: backButton, toView: self.view)
//
//    }
    private func addTable() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
        
        func addConstraints(fromView: UIView, toView: UIView) {
            
            fromView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                         fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor ,constant: 0),
                                         fromView.topAnchor.constraint(equalTo: toView.layoutMarginsGuide.topAnchor, constant: 40),
                                         fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor,constant: 0)])
        }
        addConstraints(fromView: tableView, toView: self.view)
        
    }
    private func applyGradient(_ view: UIView) {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemBlue.withAlphaComponent(0.6).cgColor,
                           UIColor.systemGreen.withAlphaComponent(0.6).cgColor]
        gradient.startPoint = CGPoint(x: 1, y: 1)
        gradient.endPoint = CGPoint(x: 0, y: 0)
        gradient.frame = self.view.bounds
        view.layer.addSublayer(gradient)
    }
    
}
//MARK: - Tableview delegation
extension UserPageView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let quotes = quoteModel?.quotes {
            return quotes.count
        }else{
            return 10
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as! UserQuoteCell
        cell.backgroundColor = .clear
        if let quote = quoteModel?.quotes[indexPath.row]{
            cell.passData(quote: quote)
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let sizeHeight = self.view.frame.size.height / 3
        
        return CGFloat(sizeHeight)
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if let cell = tableView.cellForRow(at: indexPath) as? UserQuoteCell {
//
//        }
        
    }
    
}

