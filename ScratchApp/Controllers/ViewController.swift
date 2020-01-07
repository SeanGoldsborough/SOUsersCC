//
//  ViewController.swift
//  ScratchApp
//
//  Created by Sean Goldsborough on 1/3/20.
//  Copyright © 2020 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedResultsController: NSFetchedResultsController<User>!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainActivityIndicator: UIActivityIndicatorView!
    let myCell = "MyCell"
    
    var api = APIClient()
    var users: [NSManagedObject] = []
    
    let methodParameters = ["site": "stackoverflow", "page" : "1"] as [String : AnyObject]
    
    fileprivate func setupFetchedResultsController() {

        let fetchRequest:NSFetchRequest<User> = User.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "userName", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self as NSFetchedResultsControllerDelegate

        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            AlertView.alertPopUp(view: self, alertMessage: "CVcould not fetch: \(error.localizedDescription)")
        }
    }
    
    func removeAllUsers() {
        print(fetchedResultsController.fetchedObjects!.count)
        for object in fetchedResultsController.fetchedObjects! {
            context.delete(object)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: myCell)
        
        performUpdatesOnMain {
            self.mainActivityIndicator.startAnimating()
        }
        
        if fetchedResultsController.fetchedObjects?.count == 0 {
            APIClient.sharedInstance().getData(completed: { result in
                switch result {
                case .success:
                    performUpdatesOnMain {
                        self.fetchData()
                        self.tableView.reloadData()
                        self.appDelegate.saveContext()
                        self.mainActivityIndicator.stopAnimating()
                        self.mainActivityIndicator.isHidden = true
                    }

                case .failure(let error):
                    performUpdatesOnMain {
                        self.mainActivityIndicator.stopAnimating()
                        self.mainActivityIndicator.isHidden = true
                        AlertView.alertPopUp(view: self, alertMessage: "Error on downloading photos")
                    }
                }
            })
            self.appDelegate.saveContext()
        } else {
            self.fetchData()
        }
    }
    
    func fetchData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do {
          users = try managedContext.fetch(fetchRequest)
          performUpdatesOnMain {
              self.tableView.reloadData()
              self.appDelegate.saveContext()
              self.mainActivityIndicator.stopAnimating()
              self.mainActivityIndicator.isHidden = true
          }
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
          self.mainActivityIndicator.stopAnimating()
          self.mainActivityIndicator.isHidden = true
          AlertView.alertPopUp(view: self, alertMessage: "\(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: myCell, for: indexPath) as! CustomTableViewCell
        cell.imageActivityIndicator.startAnimating()

        return cell
    }
    
   func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    let user = users[indexPath.row]
    let tableViewCell = cell as! CustomTableViewCell
    
    tableViewCell.imageUrl = (user.value(forKeyPath: "avatarURL") as? String) ?? "N/A"
    tableViewCell.userNameLabel?.text = user.value(forKeyPath: "userName") as? String ?? "N/A"
    
    var goldCount: Int
    goldCount = user.value(forKeyPath: "goldBadgeCount") as! Int
    tableViewCell.goldBadgeCount.text = "\(goldCount.abbreviateNumber())" ?? "N/A"
    
    var silverCount: Int
    silverCount = user.value(forKeyPath: "silverBadgeCount") as! Int
    tableViewCell.silverBadgeCount.text = "\(silverCount.abbreviateNumber())" ?? "N/A"
    
    var bronzeCount: Int
    bronzeCount = user.value(forKeyPath: "bronzeBadgeCount") as! Int
    tableViewCell.bronzeBadgeCount.text = "\(bronzeCount.abbreviateNumber())" ?? "N/A"

        performUpdatesOnMain {
            self.configImage(cell: tableViewCell, user: user as! User, tableView: tableView, indexPath: indexPath)
            self.appDelegate.saveContext()
        }
    }
    
    private func configImage(cell: CustomTableViewCell, user: User, tableView: UITableView, indexPath: IndexPath) {

        if let imageData = user.avatarData {
         
            cell.imageActivityIndicator.stopAnimating()
            cell.imageActivityIndicator.isHidden = true
            cell.userAvatarImage.image = UIImage(data: Data(referencing: imageData as NSData))
        } else {
            if let imageUrl = user.avatarURL {
                cell.imageActivityIndicator.startAnimating()
                APIClient.sharedInstance().getImage(urlString: imageUrl, completed: { (data, error) in
                        if let _ = error {
                            performUpdatesOnMain {
                                cell.imageActivityIndicator.stopAnimating()
                                cell.imageActivityIndicator.isHidden = true
                            }
                            return
                        } else if let data = data {
                            performUpdatesOnMain {
                                if let currentCell = tableView.cellForRow(at: indexPath) as? CustomTableViewCell {
                                    if currentCell.imageUrl == imageUrl {
                                        currentCell.userAvatarImage.image = UIImage(data: data as Data)
                                        cell.imageActivityIndicator.stopAnimating()
                                        cell.imageActivityIndicator.isHidden = true
                                    }
                                }
                                user.avatarData = NSData(data: data as Data) as Data
                                self.appDelegate.saveContext()
                            }
                        }
                    })
                }
            }
        }
}

extension ViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

}
