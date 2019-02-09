//
//  BaseViewController.swift
//  ChessAR
//
//  Created by Adem Atalay on 6.02.2019.
//  Copyright © 2019 MAKU Teknoloji. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    let router: AppRouter
    init(router: AppRouter) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
