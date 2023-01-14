//
//  DetailsViewController.swift
//  ArtBook
//
//  Created by Türker Berk Topçu on 6.01.2023.
//

import UIKit
import CoreData
import PhotosUI

class DetailsViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  
    
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artNameText: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var artistNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        imageView.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageGestureRecognizer)
        
    }
    
 
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        present(picker, animated: true)
        
        print("1.2debug")

        
        
    }
    
    
    
    
    @objc func hideKeyboard(){
        view.endEditing(true)
        
    }
    
   
    
   
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        if imageView.image == UIImage(named: "select"){
            let alertController = UIAlertController(title: "Something is Empty", message: "", preferredStyle: .alert)
            let alertBtn = UIAlertAction(title: "OK", style: .default) {
                UIAlertAction in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(alertBtn)
            present(alertController, animated: true)
        }
        if  artNameText.text == "" {
            let alertController = UIAlertController(title: "Something is Empty", message: "", preferredStyle: .alert)
            let alertBtn = UIAlertAction(title: "OK", style: .default) {
                UIAlertAction in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(alertBtn)
            present(alertController, animated: true)
        }
        if  artistNameField.text == "" {
            let alertController = UIAlertController(title: "Something is Empty", message: "", preferredStyle: .alert)
            let alertBtn = UIAlertAction(title: "OK", style: .default) {
                UIAlertAction in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(alertBtn)
            present(alertController, animated: true)
        }
        if yearField.text == "" {
            let alertController = UIAlertController(title: "Something is Empty", message: "", preferredStyle: .alert)
            let alertBtn = UIAlertAction(title: "OK", style: .default) {
                UIAlertAction in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(alertBtn)
            present(alertController, animated: true)
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newPainting = NSEntityDescription.insertNewObject(forEntityName: "Entity", into: context)
        
        newPainting.setValue(artNameText.text!, forKey: "artName")
        newPainting.setValue(artistNameField.text!, forKey: "artistName")
        
        if let year = Int(yearField.text!) {
            newPainting.setValue(year, forKey: "year")
        }
        newPainting.setValue(UUID(), forKey: "id")

        let data = imageView.image!.jpegData(compressionQuality: 0.5)
        newPainting.setValue(data, forKey: "image")
        
        do {
            try context.save()
            let alertController = UIAlertController(title: "Saved", message: "", preferredStyle: .alert)
            let alertBtn = UIAlertAction(title: "OK", style: .default) {
                UIAlertAction in
                NotificationCenter.default.post(name: NSNotification.Name("newValueCame"), object: nil)
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(alertBtn)
            present(alertController, animated: true)
            
        }
        catch{
            print("Error !!")
        }
    }
    
  
    

}
