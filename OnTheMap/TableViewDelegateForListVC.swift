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
    
    //DataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInformation.studentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let student = StudentInformation.studentArray[indexPath.row]
        
        let cellID = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)!
        
        let fullName = "\(student.firstName ?? "Name") \(student.lastName ?? "unavailable")"
        
        cell.textLabel?.text = fullName
        cell.imageView?.image = #imageLiteral(resourceName: "icon_pin")
        
        return cell
    }
    
    //Delegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let student = StudentInformation.studentArray[indexPath.row]
        
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
