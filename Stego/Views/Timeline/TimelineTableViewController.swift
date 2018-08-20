//
//  TimelineTableViewController.swift
//  Stego
//
//  Created by George Sealy on 16/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import UIKit
import CoreData
class TimelineTableViewController: UITableViewController {

    private let persistentContainer = NSPersistentContainer(name: "DataModels")

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Status> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Status> = Status.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        
        // Create Fetched Results Controller
        guard let databaseContext = Api.database.context as? NSManagedObjectContext else {
            fatalError("No context")
        }
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: databaseContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // TODO: (George) load database?
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
                
            } else {
//                self.setupView()
                
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("Unable to Perform Fetch Request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
                
                self.updateView()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Api.call(Timelines.home) { (result: Result<[Status]>) in
            switch result {

            case .success(let statuses):
                Log("\(type(of: self)) - \(#function): Statuses: ")


                self.updateView()
//                for status in statuses {
//                    Log("\(type(of: self)) - \(#function):   ")
//                    Log("\(type(of: self)) - \(#function):   \(String(describing: status.id))")
//                    //                    Log("\(type(of: self)) - \(#function):   \(status.account?.displayName)")
//                    Log("\(type(of: self)) - \(#function):   \(String(describing: status.content))")
//                }


            case .error(let error) :
                Log("\(type(of: self)) - \(#function): Error: \(error)")

            }
        }

        updateView()
        
    }
    
    private func updateView() {
        
//        var hasQuotes = false
//
//        if let quotes = fetchedResultsController.fetchedObjects {
//            hasQuotes = quotes.count > 0
//        }
//
//        tableView.isHidden = !hasQuotes
//        messageLabel.isHidden = hasQuotes
//
//        activityIndicatorView.stopAnimating()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let statuses = fetchedResultsController.fetchedObjects else { return 0 }
        return statuses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell", for: indexPath) as? TimelineTableViewCell else {
            fatalError("No cell of correct type")
        }

        let status = fetchedResultsController.object(at: indexPath)
        
        cell.userLabel.text = status.account?.displayName
        cell.contentLabel.text = status.content

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TimelineTableViewController: NSFetchedResultsControllerDelegate {
    
}
