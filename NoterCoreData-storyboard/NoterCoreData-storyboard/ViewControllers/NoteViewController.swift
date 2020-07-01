//
//  NoteViewController.swift
//  NoterCoreData-storyboard
//
//  Created by Rdm on 24/06/2020.
//  Copyright © 2020 Rdm. All rights reserved.
//

import UIKit
import CoreData

class NoteViewController: UIViewController {
    
    
    @IBOutlet weak var simpleNoteLabel: UILabel!
    @IBOutlet weak var simpleAppLabel: UILabel!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var bottomStackConstraint: NSLayoutConstraint!
    
    let mainTableView = MainTableViewController()
    private let notificationCenter = NotificationCenter.default
    var managedContext: NSManagedObjectContext!
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextViewDelegate()
        setupKeyboardAdjustment()
        holdNoteContent()
        
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        
        dismissAndResign()
        
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        // MARK: Saving note data
        guard let title = noteTextView.text, !title.isEmpty else { return }
        
        if let note = self.note {
            note.title = title
            note.date = Date()
            
            do {
                try managedContext.save()
                dismissAndResign()
                
            } catch {
                print(error)
            }
            
        } else {
            let note = Note(context: managedContext)
            
            note.title = title
            note.date = Date()
            
            do {
                try managedContext.save()
                dismissAndResign()
            } catch {
                print("Error saving note: \(error)")
            }
        }
    }
    
}


extension NoteViewController: UITextViewDelegate {
    
    fileprivate func setupLabelsAnimation() {
    }
    
    //MARK: Buttons action refactored
    fileprivate func dismissAndResign() {
        
        dismiss(animated: true, completion: nil)
        noteTextView.resignFirstResponder()
        
    }
    
    fileprivate func setupTextViewDelegate() {
        noteTextView.delegate = self
    }
    
    fileprivate func holdNoteContent() {
        
        if let note = note {
            noteTextView.text = note.title
            noteTextView.text = note.title
        }
        
    }
    
    // MARK: Keyboard Adjustment
    
    fileprivate func setupKeyboardAdjustment() {
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    @objc func adjustForKeyboard(notification: Notification) {
        
        guard let keyboardValue = notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrame = keyboardValue.cgRectValue
        
        bottomStackConstraint.constant = keyboardFrame.height - view.safeAreaInsets.bottom + 5
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            
            bottomStackConstraint.constant = 5
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: Note TextView selection configuration
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        
        if saveButton.isHidden == true {
            
            noteTextView.text = ""
            noteTextView.textColor = .white
            noteTextView.alpha = 0.9
            saveButton.isHidden = false
            
            UIView.animate(withDuration: 0.4, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}






