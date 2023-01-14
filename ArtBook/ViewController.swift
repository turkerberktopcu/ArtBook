//
//  ViewController.swift
//  ArtBook
//
//  Created by Türker Berk Topçu on 6.01.2023.
//
import CoreData
import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
   
    

    
    var selectedID = 0
    var names = [String]()
    var id = [UUID]()
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        getData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newDataCame"), object: nil)
    }
   
    
    @objc func addButtonClicked(){
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.names[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.names.count
    }
    
    @objc func getData(){
        var startIndex = 0
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(fetchRequest)
            
            for i in results as! [NSManagedObject]{
                if let newName = i.value(forKey: "artName") as? String {
                    self.names.append(newName)
                }

                if let id = i.value(forKey: "id") as? UUID {
                    self.id.append(id)
                }
                
                self.tableView.reloadData()
                startIndex += 1
            }
            
        }
        catch{
            print("Error !")
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let newId = id[indexPath.row] as? Int {
            self.selectedID = newId
        }
        performSegue(withIdentifier: "showSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSegue" {
            let destination = segue.destination as! ShowViewController
            destination.selectedId = self.selectedID
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let idString = self.id[indexPath.row].uuidString
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
            fetchRequest.predicate = NSPredicate(format: "id = %@",  idString)
            
            fetchRequest.returnsObjectsAsFaults = false
            
            do{
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject]{
                        if let id = result.value(forKey: "id") as? UUID {
                            if id == self.id[indexPath.row] {
                                context.delete(result)
                                self.names.remove(at: indexPath.row)
                                self.id.remove(at: indexPath.row)
                                self.tableView.reloadData()
                                try context.save()
                            }
                        }
                        
                    }
                    
                    
                }
            }
            catch {
                print("Error while deleting !!")
            }
            
            
        }
    }
    
}

