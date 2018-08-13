//
//  ViewController.swift
//  Stego
//
//  Created by George Sealy on 13/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import UIKit
import WebKit
import MastodonKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        gatMastodonApp()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


// MARK: - MASTODON

extension ViewController {
    
    func gatMastodonApp() {
        
//        let client = Client(baseURL: "https://mastodon.social")
//        let appRequest = Clients.register(clientName: "Stego", redirectURI: "stego://auth", scopes: [.read, .write, .follow], website: "http://google.com")
//
//        client.run(appRequest) { (app, error) in
//            if let error = error {
//                print("ERROR: \(error)")
//            } else if let app = app {
//                print(app.clientID)
//                print(app.redirectURI)
//            } else {
//                print("NOTHING!")
//            }
//        }
        
        Api.register()
        
    }
    
//    func authorize(_ app: AppModel) {
//        
//        DispatchQueue.main.async {
//            
////            let client = Client(baseURL: "https://mastodon.technology")
////
////            let request = Clients.register(
////                clientName: "MastodonKit Test Client",
////                scopes: [.read, .write, .follow],
////                website: "https://github.com/MastodonKit/MastodonKit"
////            )
////
////            client.run(request) { application, error in
////                if let application = application {
////                    print("id: \(application.id)")
////                    print("redirect uri: \(application.redirectURI)")
////                    print("client id: \(application.clientID)")
////                    print("client secret: \(application.clientSecret)")
////                }
////            }
//            
//            
//            var path = Api.basePath + "oauth/authorize"
//
////            if let scope = "?scope=read write follow".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
////            if
////                let scope = "?scope=read".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
//////                let redirect = "&redirect_uri=https://google.com".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
////                let redirect = "&redirect_uri=\(app.redirectUri)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
//////                let redirect = "&redirect_uri=urn:ietf:wg:oauth:2.0:oob".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
////
////                path = path + scope
//            path = path + "?response_type=code"
//            path = path + "&scope=read+write+follow"
//            path = path + "&redirect_uri=\(app.redirectUri)"
//            path = path + "&client_id=\(app.clientId)"
////            }
//
//            guard let url = URL(string: path) else {
//                print("ERROR WITH PATH: \(path)")
//                return
//            }
//
//            let options: [String: Any] = [:]
//
//            print("Redirecting to : \(url.absoluteString)")
//            UIApplication.shared.open(url, options: options, completionHandler: { (success) in
//                print("Redirected \(success)")
//            })
//        }
//    }
}
