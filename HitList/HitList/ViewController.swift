//
//  ViewController.swift
//  HitList
//
//  Created by Eaman Fatima on 2023-10-19.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var people: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "The List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
    }

    @IBAction func addName(_ sender: Any) {
        let alert = UIAlertController(
            title: "New Name",
            message: "Add a new name",
            preferredStyle: .alert)
        
        let saveAction = UIAlertAction(
            title: "Save",
            style: .default) { [weak self] action in
                guard let textField = alert.textFields?.first,
                      let nameToSave = textField.text else {
                          return
                      }
                self?.save(name: nameToSave)
                self?.tableView.reloadData()
            }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func save(name: String) {
        // 1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // 2
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        // 3
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedObjectContext)
        
        // 4
        let person = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
        person.setValue(name, forKeyPath: "name")
        
        do {
            try managedObjectContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func fetch() {
        // 1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // 2
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        // 3
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do {
            people = try managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
}

// MARK: UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = people[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = person.value(forKeyPath: "name") as? String
        return cell
    }
}

