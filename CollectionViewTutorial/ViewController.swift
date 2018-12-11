//
//  ViewController.swift
//  CollectionViewTutorial
//
//  Created by Sreng Khorn on 8/12/18.
//  Copyright © 2018 Sreng Khorn. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var takeNoteTextField: UITextField!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var manageContext = appDelegate.persistentContainer.viewContext
    
    let reuseIdentifier = "CustomCollectionViewCell"
    var notes = [NSManagedObject]()
    var valueToPass = NSManagedObject()
    
    private func setupCell() {
        let columnLayout = ColumnFlowLayout(
            cellsPerRow: 2,
            minimumInteritemSpacing: 10,
            minimumLineSpacing: 10,
            sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        )

        collectionView.collectionViewLayout = columnLayout
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.register(UINib.init(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
    }
    
    private func addGuestures() {
        takeNoteTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(createNote)))
        
        collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
    }
    
    private func initNavigator() {
        navigationItem.title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .yellow
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigator()
        setupCell()
        addGuestures()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let manageContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NoteTable")
        do {
            notes = try manageContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    @objc fileprivate func createNote() {
        guard  let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateNoteController") as? CreateNoteController else {
            fatalError("View Controller not found")
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func deleteNote(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Are you sure want to delete this note?", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                // Delete Cell
                self.manageContext.delete(self.notes[indexPath.row])
                self.notes.remove(at: indexPath.row)
                self.collectionView.deleteItems(at: [indexPath])
                self.collectionView.reloadData()
                self.appDelegate.saveContext()
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
        if (gestureRecognizer.state != UIGestureRecognizer.State.ended){
            return
        }
        let p = gestureRecognizer.location(in: self.collectionView)
        if let indexPath : IndexPath = (self.collectionView.indexPathForItem(at: p)){
            deleteNote(indexPath: indexPath)
        }
    }
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.notes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomCollectionViewCell
        let note = notes[indexPath.row]
        cell.titleLabel.text = note.value(forKey: "title") as? String
        cell.descriptionLabel.text = note.value(forKey: "desc") as? String
        cell.backgroundColor = .white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        valueToPass = notes[indexPath.row]
        performSegue(withIdentifier: "goToDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail"
        {
            let viewController = segue.destination as! EditNoteController
            viewController.note = valueToPass
        }
    }
}

