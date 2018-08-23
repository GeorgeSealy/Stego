//
//  RootViewController.swift
//  Stego
//
//  Created by George Sealy on 23/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    private var coreDataManager: CoreDataManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if coreDataManager != nil {
            setupView()
            
        } else {
            coreDataManager = CoreDataManager(modelName: "DataModels", completion: {
                self.setupView()
            })
        }
        
    }

    private func setupView() {
        view.backgroundColor = .green
        
        Api.coreDataManager = coreDataManager
        let storyboard = UIStoryboard.init(name: "Registration", bundle: nil)
        let rootVC = storyboard.instantiateViewController(withIdentifier: "Registration")

        navigationController?.pushViewController(rootVC, animated: true)
    }

}
