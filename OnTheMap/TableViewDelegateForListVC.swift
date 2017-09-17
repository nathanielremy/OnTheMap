//
//  TableViewDelegateForListVC.swift
//  OnTheMap
//
//  Created by Nathaniel Remy on 15/09/2017.
//  Copyright © 2017 Nathaniel Remy. All rights reserved.
//

import Foundation
import UIKit

extension ListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parseClient.studentInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let student = parseClient.studentInformation[indexPath.row]
        
        let cellID = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)!
        
        let fullName = "\(student.firstName ?? "Name") \(student.lastName ?? "unavailable")"
        
        cell.textLabel?.text = fullName
        cell.imageView?.image = #imageLiteral(resourceName: "icon_pin")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let student = parseClient.studentInformation[indexPath.row]
        
        guard let urlString = student.mediaURL, let url = URL(string: urlString) else {
            displayAlerView(withTitle: "Could not open URL", message: "User did not leave a valid URL", action: "Okay")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
            if success == false {
                DispatchQueue.main.async {
                    self.displayAlerView(withTitle: "Could not open URL", message: "User did not leave a valid URL", action: "Okay")
                }
            }
        })
    }
}
