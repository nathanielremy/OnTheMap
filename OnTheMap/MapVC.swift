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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.delegate = self
        setUpTabBar()
    }
    
    // Drop a pin on map
    func dropPin() {
        print("Cant drop Pin yet MAP VC")
    }
    
    func refresh() {
        print("you cant refresh yet MAP VC")
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
}

extension MapVC: MKMapViewDelegate {
    
    
    
    
}













