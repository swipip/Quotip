//
//  QuotesTableViewModel.swift
//  Quotip
//
//  Created by Gautier Billard on 17/05/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import Foundation

class QuotesTableViewModel {
    
    weak var viewController: ViewController?
    
    private(set) var quoteModel: QuoteModel?
    private(set) var typeheads: Typeheads?
    
    var currentUser: UserID?
    
    init(view: ViewController) {
        viewController = view
        QuotesManager.shared.fetchTags()
        QuotesManager.shared.tags = self.tags(data:)
        
    }
    func fetchUserQuotes(url: String) {
        QuotesManager.shared.fetchQuotes(url: url, type: .quotes)
        
    }
    func decodedJson(data: QuoteModel) {
        
        quoteModel = data
        viewController?.tableView.reloadData()
        
    }
    func tags(data: Typeheads){
        
        typeheads = data
        viewController?.tableView.reloadData()
        if let cell = viewController?.tableView.cellForRow(at: IndexPath(item: 1, section: 0)) as? TagCell {
            cell.magnify(on: true)
        }
        
    }
    
}
