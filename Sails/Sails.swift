//
//  Sails.swift
//  Sails
//
//  Created by Daniel Tomlinson on 03/10/2015.
//  Copyright © 2015 Daniel Tomlinson. All rights reserved.
//

public protocol Router {
    
}

public class Sails {
    private let router: Router
    
    init(router: Router) {
        self.router = router
    }
}