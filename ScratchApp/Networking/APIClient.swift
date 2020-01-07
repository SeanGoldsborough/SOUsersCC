//
//  APIClient.swift
//  ScratchApp
//
//  Created by Sean Goldsborough on 1/3/20.
//  Copyright © 2020 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class APIClient : NSObject {
    
    class func sharedInstance() -> APIClient {
        struct Singleton {
            static var sharedInstance = APIClient()
        }
        return Singleton.sharedInstance
    }

    var session = URLSession.shared
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override init() {
        super.init()
    }
    
    enum CustomError: String, Error {
        
        case badConnection = "Unable to complete your request"
        case badResponse  = "Invalid response from the server"
        case noData = "No data was received from the server"
        case noImage = "Unable to get image"
    }
    
    func getData(completed: @escaping (Result<[Items], CustomError>) -> Void) {
        var parameters = ["site": "stackoverflow", "page" : "1"]
        var url = APIClient.sharedInstance().soURLFromParameters(parameters as [String : AnyObject])

        let task = session.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.badConnection))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.badResponse))
                return
            }

            guard let data = data else {
                completed(.failure(.noData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let items = try decoder.decode(Base.self, from: data)
                self.mapDataToCoreData(items: items.items!)
                completed(.success(items.items!))
            } catch {
                completed(.failure(.noData))
            }
        }
        task.resume()
    }
    
    func mapDataToCoreData(items: [Items]) {
        performUpdatesOnMain {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appDelegate.persistentContainer.viewContext
            let userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)
            
            for user in items {
                
                let users = NSManagedObject(entity: userEntity!, insertInto: managedContext)
                users.setValue(user.profile_image, forKey: "avatarURL")
                users.setValue(user.display_name, forKey: "userName")
                users.setValue(user.badge_counts?.gold, forKey: "goldBadgeCount")
                users.setValue(user.badge_counts?.silver, forKey: "silverBadgeCount")
                users.setValue(user.badge_counts?.bronze, forKey: "bronzeBadgeCount")
                
                do {
                    try managedContext.save()
                } catch {
                    print("MDTCD error on trying to save to core data in parse method")
                }
            }
        }
    }
    
    func getImage(urlString: String, completed: @escaping (_ results: Data?,_ error:NSError?) -> ()){
        do{
            let url = URL(string: urlString)
            let imageData = try Data(contentsOf: url!)
            completed(imageData,nil)
        }
        catch let error as NSError {
            completed(nil,error)
        }
    }
}
