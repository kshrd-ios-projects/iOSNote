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
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("\(titleTextField.text!)")
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
