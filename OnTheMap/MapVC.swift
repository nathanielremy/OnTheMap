//
//  MapVC.swift
//  OnTheMap
//
//  Created by Nathaniel Remy on 14/09/2017.
//  Copyright © 2017 Nathaniel Remy. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController  {
    
    // IB Outlets
    @IBOutlet weak var mapView: MKMapView!
    
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
        refresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.delegate = self
        setUpTabBar()
    }
    
    
    // IMPLEMENT
    func updateMapUI() {
        print("updateMapUI")
    }
    
    // Drop a pin on map
    func dropPin() {
        print("Cant drop Pin yet MAP VC")
    }
    
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
                    self.updateMapUI()
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
                print("MapVC/logOut: FAIL")
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

extension MapVC: MKMapViewDelegate {
    
    
    
    
}
