//
//  ListVC.swift
//  OnTheMap
//
//  Created by Nathaniel Remy on 14/09/2017.
//  Copyright © 2017 Nathaniel Remy. All rights reserved.
//

import UIKit

class ListVC: UIViewController {
    
    // Stored Properties
    lazy var udacityClient: UdacityClient = {
        let client = UdacityClient.singleton()
        return client
    }()
    
    lazy var parseClient: ParseClient = {
        let client = ParseClient.singleton()
        return client
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpTabBar()
    }
    
    // Drop a pin on map
    func dropPin() {
        print("Cant drop Pin yet LIST VC")
    }
    
    func refresh() {
        print("you cant refresh yet LIST VC")
    }
    
    func logout() {
        udacityClient.logout { (success, error) in
            if success {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                print("ListVC/logOut: FAIL")
            }
        }
    }
    
    func setUpTabBar() {
        
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
