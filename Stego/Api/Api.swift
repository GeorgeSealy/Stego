//
//  Api.swift
//  Stego
//
//  Created by George Sealy on 13/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

struct AfApiRequest: ApiRequest {
    fileprivate var request: Request
    
    func cancel() {
        self.request.cancel()
    }
}

// Handling Oauth, this has been very handy: https://github.com/spaceottercode/Mastodon-OAuth-Documentation

class Api {
    
    static let basePath = "https://mastodon.social/"
    
    static var app: AppModel?
    static var accessCode: String?
    static var accessToken: String?
    
    static let database = CoreDataDatabase()
    
//    static private(set) var managedObjectContext: NSManagedObjectContext?
//
//    static func initialize(managedObjectContext: NSManagedObjectContext? = setUpInMemoryManagedObjectContext()) {
//        Api.managedObjectContext = managedObjectContext
//    }

    static func initialize() {
        // TODO: (George) Can remove?
    }

    static func register() {
        
        guard let app = Api.app else {
            
            registerApp()
            return
        }
        
        if let code = Api.accessCode {
            
            registerAccessCode(code, app: app)
            
        } else if let accessToken = Api.accessToken {
            
            verifyCredentials(accessToken: accessToken)
            
        } else {
            
            authorizeApp(app)

        }

    }
    
    static private func registerApp() {
        Api.call(Apps.get) { (result: Result<AppModel>) in
            
            switch result {
                
            case .success(let app):
                Log("\(type(of: self)) - \(#function): APP REGISTERED: \(app)")
                
                Api.app = app
                register()
                
            case .error(let error) :
                Log("\(type(of: self)) - \(#function): Error: \(error)")
                
                // TODO: (George) Try again?
            }
        }
    }
    
    static private func authorizeApp(_ app: AppModel) {
        
        var path = Api.basePath + "oauth/authorize"
        
        path = path + "?response_type=code"
        path = path + "&scope=read+write+follow"
        path = path + "&redirect_uri=\(app.redirectUri)"
        path = path + "&client_id=\(app.clientId)"
        
        guard let url = URL(string: path) else {
            Log("\(type(of: self)) - \(#function): ERROR WITH PATH: \(path)")
            return
        }
        
        let options: [String: Any] = [:]
        
        Log("\(type(of: self)) - \(#function): Redirecting to : \(url.absoluteString)")
        
        UIApplication.shared.open(url, options: options, completionHandler: { (success) in
        })
    }
    
    static private func registerAccessCode(_ code: String, app: AppModel) {
        
        let endPoint = Oauth.accessToken(clientId: app.clientId,
                                         clientSecret: app.clientSecret,
                                         code: code,
                                         redirectUri: app.redirectUri)

        // Clear this, as it can't be used again
        Api.accessCode = nil
        
        Api.call(endPoint, completion: { (result: Result<AccessModel>) in
            
            switch result {
                
            case .success(let accessModel):
                Log("\(type(of: self)) - \(#function): Access token returned")
                Api.accessToken = accessModel.accessToken
                
                register()
                
            case .error(let error) :
                Log("\(type(of: self)) - \(#function): Error: \(error)")
                // TODO: (George) Try again?
            }
        })
        
    }
    
    static private func verifyCredentials(accessToken: String) {
        
        Api.call(Accounts.verifyCredentials) { (result: Result<AccountModel>) in
            switch result {
                
            case .success(let account):
                Log("\(type(of: self)) - \(#function): Verify credentials: \(account.displayName)")
                
                getHomeTimeline()
                
            case .error(let error) :
                Log("\(type(of: self)) - \(#function): Error: \(error)")
                
                Api.accessCode = nil
                Api.accessToken = nil
                
                // TODO: (George) potential loop here!
                register()
            }
        }
    }
    
    static private func getHomeTimeline() {
        
//        Api.call(Timelines.home) { (result: Result<[StatusModel]>) in
        Api.call(Timelines.home) { (result: Result<[Status]>) in
            switch result {
                
            case .success(let statuses):
                Log("\(type(of: self)) - \(#function): Statuses: ")
                
                for status in statuses {
                    Log("\(type(of: self)) - \(#function):   ")
                    Log("\(type(of: self)) - \(#function):   \(status.id)")
//                    Log("\(type(of: self)) - \(#function):   \(status.account?.displayName)")
                    Log("\(type(of: self)) - \(#function):   \(status.content)")
                }

                
            case .error(let error) :
                Log("\(type(of: self)) - \(#function): Error: \(error)")
               
            }
        }
    }
    // MARK: - making Api calls
    
    @discardableResult
    static func call<T: Decodable>(_ endpoint: ApiEndpoint, allowCancelCallback: Bool = false, completion: @escaping (Result<T>) -> Void) -> ApiRequest? {

        guard type(of: T.self) == type(of: endpoint.resultType) else {
            assertionFailure("Endpoint \(type(of: endpoint.resultType)) and closure \(type(of: T.self)) return types do not match")
            return nil
        }
        
//        guard let managedObjectContext = Api.managedObjectContext else {
//            fatalError("Cannot call the api before it has been initialized.")
//        }

        let route = endpoint.route
        let fullPath = route.isFullPath ? route.path : String(format: "%@%@%@", basePath, route.isApiCall ? "api/v1/" : "", route.path)
        
        Log("\(fullPath) [\(route.method.rawValue)]")
        
        let parameters = route.parameters
        
//        print("\(type(of: self)) - \(#function): Params: \(parameters)")
        let method = route.method
        let encoding: ParameterEncoding = ([Alamofire.HTTPMethod.head, Alamofire.HTTPMethod.get, Alamofire.HTTPMethod.delete].contains(method) ? URLEncoding.default  : JSONEncoding.default)
        
        // Authorization: Bearer <access_token>
        var headers: [String: String] = [:]
        
        if let accessToken = Api.accessToken {
            headers["Authorization"] = "Bearer " + accessToken
        }
//        let headers = ["Authorization": "Basic \(base64Credentials)"]
//
//        Alamofire.request(.GET, "https://httpbin.org/basic-auth/user/password", headers: headers)

        let request = Alamofire.request(fullPath, method: method, parameters: parameters, encoding: encoding, headers: headers).validate().responseString { (responseString) in
//            print("Got response: \(responseString)")
        }.responseData { (response) in
            
            do {
                guard let data = response.data else {
                    let userInfo: [String: Any] = [
                        NSLocalizedDescriptionKey: "Sorry, there was an error deserializing the api response",
                        ]
                    
                    let error = NSError(domain: "ApiDomain", code: -1, userInfo: userInfo)
                    
                    self.handleResponse(fullPath: fullPath, allowCancelCallback: allowCancelCallback, completion: completion, result: .error(error as NSError))
                    return
                }
                
                guard let databaseKey = CodingUserInfoKey.databaseKey else {
                    fatalError("Failed to retrieve managed object context")
                }
                
                let jsonDecoder = JSONDecoder()
//                jsonDecoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
                jsonDecoder.userInfo[databaseKey] = database

                let result: T = try data.decoded(using: jsonDecoder)
                
                try database.save()
                
                self.handleResponse(fullPath: fullPath, allowCancelCallback: allowCancelCallback, completion: completion, result: .success(result))
            } catch let error {
                
                if
                    let data = response.data,
                    let apiError: ApiError = try? data.decoded() {
                
                    let userInfo: [String: Any] = [
                        NSLocalizedDescriptionKey: "\(apiError.error): \(apiError.description)",
                        ]
                    
                    let error = NSError(domain: "ApiErrorDomain", code: -1, userInfo: userInfo)
                    self.handleResponse(fullPath: fullPath, allowCancelCallback: allowCancelCallback, completion: completion, result: .error(error))

                    return
                }

                Log("\(type(of: self)) - \(#function): ERROR: \(error)")
                self.handleResponse(fullPath: fullPath, allowCancelCallback: allowCancelCallback, completion: completion, result: .error(error as NSError))
            }
        }
        
 
        return AfApiRequest(request: request)
    }
    
    private static func handleResponse<T>(fullPath: String, allowCancelCallback: Bool = false, completion: @escaping (Result<T>) -> Void, result: Result<T>) {
        
        completion(result)
        
    }
    
}

