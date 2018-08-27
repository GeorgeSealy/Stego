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
    
    static var accessCode: String?
    static var coreDataManager: CoreDataManager?
    
//    static let database = CoreDataDatabase(storageType: .memoryBased)
//    static let database = CoreDataDatabase(storageType: .fileBased)

    static let dateFormatter: DateFormatter = {
        let result = DateFormatter()
        
        // SWAPI dates look like: "2014-12-10T16:44:31.486000Z"
        result.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
        result.timeZone = TimeZone(abbreviation: "UTC")
        result.locale = Locale(identifier: "en_US_POSIX")
        
        return result
    }()
}

// MARK: - Register

extension Api {
    
    static func register() {
        
//        guard let app = Api.app else {
        guard
            let clientId = LocalUser.getString(.appClientId),
            let clientSecret = LocalUser.getString(.appClientSecret),
            let clientRedirectUri = LocalUser.getString(.appClientRedirectUri) else {

            registerApp()
            return
        }
        
        if let code = Api.accessCode {
            
            registerAccessCode(code, clientId: clientId, clientSecret: clientSecret, redirectUri: clientRedirectUri)
            
        } else if let accessToken = LocalUser.getString(.accessToken) {
            
            verifyCredentials(accessToken: accessToken)
            
        } else {
            
            authorizeApp(clientId: clientId, redirectUri: clientRedirectUri)

        }

    }
    
    static private func registerApp() {
        Api.call(Apps.get) { (result: Result<AppModel>) in
            
            switch result {
                
            case .success(let app):
                Log("\(type(of: self)) - \(#function): APP REGISTERED: \(app)")
                
                LocalUser.saveString(.appClientId, value: app.clientId)
                LocalUser.saveString(.appClientSecret, value: app.clientSecret)
                LocalUser.saveString(.appClientRedirectUri, value: app.redirectUri)
//                Api.app = app
                register()
                
            case .error(let error) :
                Log("\(type(of: self)) - \(#function): Error: \(error)")
                
                // TODO: (George) Try again?
            }
        }
    }
    
    static private func authorizeApp(clientId: String, redirectUri: String) {
        
        var path = Api.basePath + "oauth/authorize"
        
        path = path + "?response_type=code"
        path = path + "&scope=read+write+follow"
        path = path + "&redirect_uri=\(redirectUri)"
        path = path + "&client_id=\(clientId)"
        
        guard let url = URL(string: path) else {
            Log("\(type(of: self)) - \(#function): ERROR WITH PATH: \(path)")
            return
        }
        
        let options: [String: Any] = [:]
        
        Log("\(type(of: self)) - \(#function): Redirecting to : \(url.absoluteString)")
        
        UIApplication.shared.open(url, options: options, completionHandler: { (success) in
        })
    }
    
    static private func registerAccessCode(_ code: String, clientId: String, clientSecret: String, redirectUri: String) {
        
        let endPoint = Oauth.accessToken(clientId: clientId,
                                         clientSecret: clientSecret,
                                         code: code,
                                         redirectUri: redirectUri)

        // Clear this, as it can't be used again
        Api.accessCode = nil
        
        Api.call(endPoint, completion: { (result: Result<AccessModel>) in
            
            switch result {
                
            case .success(let accessModel):
                Log("\(type(of: self)) - \(#function): Access token returned")
                LocalUser.saveString(.accessToken, value: accessModel.accessToken)
//                Api.accessToken = accessModel.accessToken
                
                register()
                
            case .error(let error) :
                Log("\(type(of: self)) - \(#function): Error: \(error)")
                // TODO: (George) Try again?
            }
        })
        
    }
    
    static private func verifyCredentials(accessToken: String) {
        
        Api.call(Accounts.verifyCredentials) { (result: Result<Account>) in
            switch result {
                
            case .success(let account):
//                Log("\(type(of: self)) - \(#function): Verify credentials:)")
//                Log("\(type(of: self)) - \(#function):   User name: \(String(describing: account.username))")
//                Log("\(type(of: self)) - \(#function):   Display name: \(String(describing: account.displayName))")
//                Log("\(type(of: self)) - \(#function):   Avatar: \(String(describing: account.avatar))")
//                Log("\(type(of: self)) - \(#function):   Static avatar: \(String(describing: account.avatarStatic))")
//                Log("\(type(of: self)) - \(#function):   Header: \(String(describing: account.header))")
//                Log("\(type(of: self)) - \(#function):   Note: \(String(describing: account.note))")
//                Log("\(type(of: self)) - \(#function):   Bot: \(String(describing: account.bot))")
//                Log("\(type(of: self)) - \(#function):   Locked: \(String(describing: account.locked))")
//                Log("\(type(of: self)) - \(#function):   Followers: \(String(describing: account.followersCount))")
//                Log("\(type(of: self)) - \(#function):   Following: \(String(describing: account.followingCount))")
//                Log("\(type(of: self)) - \(#function):   Status count: \(String(describing: account.statusesCount))")
//                Log("\(type(of: self)) - \(#function):   Status count: \(String(describing: account.statuses?.count))")

                NotificationCenter.default.post(name: stego.userUpdated, object: nil, userInfo: nil)

                // TODO: (George) Save local user, somewhere

                
            case .error(let error) :
                Log("\(type(of: self)) - \(#function): Error: \(error)")
                
                Api.accessCode = nil
//                Api.accessToken = nil
                LocalUser.saveString(.accessToken, value: nil)
                
                // TODO: (George) potential loop here!
                register()
            }
        }
    }
}

// MARK: - Call

extension Api {
    
    @discardableResult
    static func call<T: Decodable>(_ endpoint: ApiEndpoint, allowCancelCallback: Bool = false, completion: @escaping (Result<T>) -> Void) -> ApiRequest? {
        
        guard type(of: T.self) == type(of: endpoint.resultType) else {
            assertionFailure("Endpoint \(type(of: endpoint.resultType)) and closure \(type(of: T.self)) return types do not match")
            return nil
        }
        
        let route = endpoint.route
        let fullPath = route.isFullPath ? route.path : String(format: "%@%@%@", basePath, route.isApiCall ? "api/v1/" : "", route.path)
        
        Log("\(fullPath) [\(route.method.rawValue)]")
        
        let parameters = route.parameters
        
        //        print("\(type(of: self)) - \(#function): Params: \(parameters)")
        let method = route.method
        let encoding: ParameterEncoding = ([Alamofire.HTTPMethod.head, Alamofire.HTTPMethod.get, Alamofire.HTTPMethod.delete].contains(method) ? URLEncoding.default  : JSONEncoding.default)
        
        // Authorization: Bearer <access_token>
        var headers: [String: String] = [:]
        
        if let accessToken = LocalUser.getString(.accessToken) {
            headers["Authorization"] = "Bearer " + accessToken
        }
        
        let request = Alamofire.request(fullPath, method: method, parameters: parameters, encoding: encoding, headers: headers).validate()
//            .responseJSON { (jsonData) in
//                print("Got JSON: \(jsonData)")
//            }
            .responseData { (response) in
                
                guard let data = response.data else {
                    let userInfo: [String: Any] = [
                        NSLocalizedDescriptionKey: "Sorry, there was an error deserializing the api response",
                        ]
                    
                    let error = NSError(domain: "ApiDomain", code: -1, userInfo: userInfo)
                    
                    self.handleResponse(fullPath: fullPath, allowCancelCallback: allowCancelCallback, completion: completion, result: .error(error as NSError))
                    return
                }
                
                guard let databaseKey = CodingUserInfoKey.databaseKey else {
                    fatalError("Failed to retrieve key value")
                }
                
                guard let managedObjectContext = coreDataManager?.workerManagedObjectContext() else {
                    fatalError("Failed to retrieve managed object context")
                }
                
                managedObjectContext.perform {
                    do {
                        let jsonDecoder = JSONDecoder()
                        jsonDecoder.userInfo[databaseKey] = managedObjectContext
                        
                        let result: T = try data.decoded(using: jsonDecoder)
                        
                        endpoint.preSave(result)
                        
                        try managedObjectContext.save()
                        //                    coreDataManager?.saveChanges()
                        //                    try database.save()
                        
                        Api.coreDataManager?.saveChanges()

                        self.handleResponse(fullPath: fullPath, allowCancelCallback: allowCancelCallback, completion: completion, result: .success(result))
                        
                    } catch let error {
                        
                        if
                            let data = response.data,
                            let apiError: ApiError = try? data.decoded() {
                            
                            print("Response data was: \(String(describing: String(data: data, encoding: .utf8)))")
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
        }
        
        
        return AfApiRequest(request: request)
    }
    
    private static func handleResponse<T>(fullPath: String, allowCancelCallback: Bool = false, completion: @escaping (Result<T>) -> Void, result: Result<T>) {
        
        DispatchQueue.main.async {
            completion(result)
        }
        
    }
}
