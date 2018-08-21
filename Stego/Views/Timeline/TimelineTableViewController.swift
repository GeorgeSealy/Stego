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

//    private let persistentContainer = NSPersistentContainer(name: "DataModels")

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Status> = {

        let fetchRequest: NSFetchRequest<Status> = Status.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        guard let databaseContext = Api.database.context as? NSManagedObjectContext else {
            fatalError("No context")
        }
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: databaseContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Api.call(Timelines.home) { (result: Result<[Status]>) in
            switch result {

            case .success(let statuses):
                Log("\(type(of: self)) - \(#function): Statuses: [\(statuses.count)]")

            case .error(let error) :
                Log("\(type(of: self)) - \(#function): Error: \(error)")

            }
        }

//        updateView()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let statuses = fetchedResultsController.fetchedObjects else {
            return 0
            
        }
        
        Log("\(type(of: self)) - \(#function): STATUS COUNT: \(statuses.count)")
        return statuses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell", for: indexPath) as? TimelineTableViewCell else {
            fatalError("No cell of correct type")
        }

        let status = fetchedResultsController.object(at: indexPath)
        
//        Log("\(type(of: self)) - \(#function): \(indexPath.row) -> \(status.content)")
        
        cell.userLabel.text = status.account?.displayName
//        cell.contentLabel.text = status.content
        cell.contentLabel.attributedText = status.attributedContent

        if let created = status.createdAt {
            cell.dateLabel.text = TimelineTableViewCell.dateFormatter.string(from: created as Date)
        } else {
            cell.dateLabel.text = nil
        }
        
        return cell
    }

}

extension TimelineTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // TODO: (George) Be more efficient!
        tableView.reloadData()
    }
}
