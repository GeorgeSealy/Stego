//
//  RegistrationViewController.swift
//  Stego
//
//  Created by George Sealy on 16/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(currentUserUpdated), name: stego.userUpdated, object: nil)

        Log("\(type(of: self)) - \(#function): REGISTER")
        Api.register()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func currentUserUpdated() {
        
        Log("\(type(of: self)) - \(#function): GOT LOGGED IN USER")

//        Api.database.load { (error) in
//
//            guard error == nil else {
//                fatalError("Unable to load database")
//            }
        
            let storyboard = UIStoryboard.init(name: "Timeline", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Timeline")
            
            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
        
    }
}
