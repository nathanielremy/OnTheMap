//
//  ListVC.swift
//  OnTheMap
//
//  Created by Nathaniel Remy on 14/09/2017.
//  Copyright © 2017 Nathaniel Remy. All rights reserved.
//

import UIKit

class ListVC: UIViewController {
    
    // Interface Builder Outlets
    @IBOutlet weak var tableView: UITableView!
    
   // Stored Properties
    lazy var udacityClient: UdacityClient = {
        let client = UdacityClient.singleton()
        return client
    }()
    
    lazy var parseClient: ParseClient = {
        let client = ParseClient.singleton()
        return client
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
        setUpNavBar()
    }
    
    //Present informationPostingVC to add location and link
    func dropPin() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "InformationPostingVC")
        
        guard let VC = controller else { displayAlerView(withTitle: "Report", message: "Cannot open view, please report this problem", action: "Okay"); return }
        
        self.present(VC, animated: true, completion: nil)
    }
    
    //refresh tableView with recent locations
    func refresh() {
        parseClient.loadRecents { (success, error) in
            guard (error == nil) else {
                DispatchQueue.main.async {
                    self.displayAlerView(withTitle: "Could not load Data", message: "Try joining a better network", action: "Okay")
                }
                return
            }
            
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .none, animated: true)
                }
            }
        }
    }
    
    func logout() {
        udacityClient.logout { (success, error) in
            if success {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.displayAlerView(withTitle: "Logout Fail", message: "Try again", action: "Okay")
                }
            }
        }
    }
    
    func setUpNavBar() {
        
        let refreshBaritem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_refresh"), style: .plain, target: self, action: #selector(refresh))
        let pinDropitem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_pin"), style: .plain, target: self, action: #selector(dropPin))
        
        parent?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        parent?.navigationItem.rightBarButtonItems = [refreshBaritem, pinDropitem]
    }
    
    // Display UIAlertControllers in case of errors
    func displayAlerView(withTitle title: String, message: String, action: String) {
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: action, style: .cancel, handler: nil)
        alertView.addAction(action)
        
        self.present(alertView, animated: true, completion: nil)
    }
}
