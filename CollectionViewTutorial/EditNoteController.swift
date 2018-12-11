//
//  EditNoteController.swift
//  CollectionViewTutorial
//
//  Created by Sreng Khorn on 9/12/18.
//  Copyright © 2018 Sreng Khorn. All rights reserved.
//

import UIKit
import CoreData

class EditNoteController: UIViewController {
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    var note = NSManagedObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextfield.text = note.value(forKey: "title") as? String
        descriptionTextView.text = note.value(forKey: "desc") as? String
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveNote()
    }
    
    func saveNote() {
        note.setValue(titleTextfield.text, forKey: "title")
        note.setValue(descriptionTextView.text, forKey: "desc")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let manageContext = appDelegate.persistentContainer.viewContext
        
        do {
            try manageContext.save()
        } catch let error as NSError {
            print("Could not save cos \(error)")
        }
        
    }

}
