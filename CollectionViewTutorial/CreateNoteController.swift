//
//  CreateNoteController.swift
//  CollectionViewTutorial
//
//  Created by Sreng Khorn on 11/12/18.
//  Copyright © 2018 Sreng Khorn. All rights reserved.
//

import UIKit
import CoreData

class CreateNoteController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTexView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTexView.delegate = self
        descriptionTexView.text = "Description..."
        descriptionTexView.textColor = UIColor.lightGray
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if titleTextField.text == "" {
            return print("Title is empty!")
        }
        saveNote()
    }
    
    func saveNote() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let manageContext = appDelegate.persistentContainer.viewContext
        
        let noteEntity = NSEntityDescription.entity(forEntityName: "NoteTable", in: manageContext)!
        
        let note = NSManagedObject(entity: noteEntity, insertInto: manageContext)
        
        note.setValue(titleTextField.text, forKey: "title")
        note.setValue(descriptionTexView.text, forKey: "desc")
        
        do {
            try manageContext.save()
        } catch let error as NSError {
            print("Could not save cos \(error)")
        }
        
    }
}

extension CreateNoteController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description..."
            textView.textColor = UIColor.lightGray
        }
    }
}
