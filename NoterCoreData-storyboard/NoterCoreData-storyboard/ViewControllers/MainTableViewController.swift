//
//  MainTableViewController.swift
//  NoterCoreData-storyboard
//
//  Created by Rdm on 24/06/2020.
//  Copyright © 2020 Rdm. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController {
    
    @IBOutlet var notesTableView: UITableView!
    @IBOutlet weak var addNoteButton: UIBarButtonItem!
    
    var resultsController: NSFetchedResultsController<Note>!
    let coreDataStack = CoreDataStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataRequestConfiguration()
        setupDelegateAndDataSource()
        
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resultsController.sections?[section].objects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = notesTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NoteCell
        
        let note = resultsController.object(at: indexPath)
        
        cell!.noteTitle.text = note.title
        
        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            
            let note = self.resultsController.object(at: indexPath)
            
            self.resultsController.managedObjectContext.delete(note)
            
            do {
                try self.resultsController.managedObjectContext.save()
                completion(true)
            } catch {
                print("Delete failed: \(error)")
                completion(false)
            }
        }
        
        action.image = UIImage(systemName: "bin.xmark")
        action.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "noteSegue", sender: notesTableView.cellForRow(at: indexPath))
        notesTableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let _ = sender as? UIBarButtonItem, let vc = segue.destination as? NoteViewController {
            
            vc.managedContext = resultsController.managedObjectContext
            
        }
        
        if let cell = sender as? NoteCell, let vc = segue.destination as? NoteViewController {
            
            vc.managedContext = resultsController.managedObjectContext
            
            if let indexPath = notesTableView.indexPath(for: cell) {
                
                let note = resultsController.object(at: indexPath)
                
                vc.note = note
            }
        }
    }
}

extension MainTableViewController: NSFetchedResultsControllerDelegate {
    
    fileprivate func setupDelegateAndDataSource() {
        
        notesTableView.delegate = self
        notesTableView.dataSource = self
        resultsController.delegate = self
        
    }
    
    // MARK: Data request configuration
    
    fileprivate func dataRequestConfiguration() {
        
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        
        let sortDescriptors = NSSortDescriptor(key: "date", ascending: true)
        
        // MARK: Initialize request
        request.sortDescriptors = [sortDescriptors]
        
        resultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataStack.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try resultsController.performFetch()
        } catch {
            print("Error: error performing fetch request")
        }
    }
    
    // MARK: TableView's data reload
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        notesTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        notesTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                notesTableView.insertRows(at: [indexPath], with: .automatic)
            }
            
        case .delete:
            if let indexPath = indexPath {
                notesTableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
        case .update:
            if let indexPath = indexPath, let cell = notesTableView.cellForRow(at: indexPath) as? NoteCell {
                let note = resultsController.object(at: indexPath)
                cell.noteTitle?.text = note.title
            }
            
        default:
            break
        }
        
    }
    
}



