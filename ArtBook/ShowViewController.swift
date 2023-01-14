//
//  ShowViewController.swift
//  ArtBook
//
//  Created by Türker Berk Topçu on 14.01.2023.
//

import UIKit
import CoreData

class ShowViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    var selectedId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setData()
    }
    
    func setData(){
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
