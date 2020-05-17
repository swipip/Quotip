//
//  QuoteDetailViewModel.swift
//  Quotip
//
//  Created by Gautier Billard on 17/05/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import Foundation

class QuoteDetailsViewModel {
    
    weak var quoteController: DetailQuoteView?
    
    var userId: UserID?
    var userNotLoggedIn: (()->Void)?
    
    init(view: DetailQuoteView) {
        self.quoteController = view
    }
    
    func passuserID(userId: UserID) {
        self.userId = userId
    }
    
    func upVote(quoteID: String) {
        
    }
    func addToFavorite(quoteID: Int){
        

        QuotesManager.shared.userNotRegistered = {[weak self] in
            self?.userNotLoggedIn?()}
        
        QuotesManager.shared.addFavorite(quoteId: quoteID)

    }
    
}
