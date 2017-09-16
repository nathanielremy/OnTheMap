//
//  InformationPostingVC.swift
//  OnTheMap
//
//  Created by Nathaniel Remy on 16/09/2017.
//  Copyright © 2017 Nathaniel Remy. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingVC: UIViewController {
    
    // Interface Builder stored properties
    @IBOutlet weak var findOrSubmitButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Stored Properties
    var locationString: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setFindLocationUI()
    }
    
    @IBAction func findOrSubmit(_ sender: Any) {
        if textField.text == "" {
            displayAlerView(withTitle: "Invalid request", message: "Text cannot be blank", action: "Okay")
            return
        
        }
        if mapView.isHidden {
            activityIndicator.startAnimating()
            
            getCoordinates(from: textField.text!, completionHandlerForCoordinates: { (success, coordinate) in
                if !success {
                    DispatchQueue.main.async {
                        
                        self.displayAlerView(withTitle: "Location could not be found.", message: "Try entering a different location", action: "Okay")
                        self.activityIndicator.stopAnimating()
                    }
                } else {
                    self.activityIndicator.stopAnimating()
                    self.setMediaURLUI()
                    self.placePinAt(coordinate: coordinate!)
                }
                
            })
        }
    }
    
    //Dismiss view
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //UI when geoCoding location
    func setFindLocationUI() {
        self.mapView.isHidden = true
        self.findOrSubmitButton.setTitle("Find", for: .normal)
        self.textLabel.text = "Where are you located ?"
        self.textField.text = ""
        self.textField.placeholder = "Enter location here"
    }
    
    func setMediaURLUI() {
        self.mapView.isHidden = false
        self.findOrSubmitButton.setTitle("Submit", for: .normal)
        self.textLabel.text = "Share a link"
        self.textField.placeholder = "Enter link here"
    }
    
    // Display UIAlertControllers in case of errors
    func displayAlerView(withTitle title: String, message: String, action: String) {
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: action, style: .cancel, handler: nil)
        alertView.addAction(action)
        
        self.present(alertView, animated: true, completion: nil)
    }
}

extension InformationPostingVC: MKMapViewDelegate {
    
    func getCoordinates(from string: String, completionHandlerForCoordinates: @escaping (_ success: Bool, _ location: CLLocationCoordinate2D?) -> Void) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(string) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                    completionHandlerForCoordinates(false, nil)
                    return
            }
            completionHandlerForCoordinates(true, location.coordinate)
        }
    }
    
    func placePinAt(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        self.mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseIdentifier = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
        
        if let pinView = pinView {
            pinView.annotation = annotation
        } else {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pinView!.pinTintColor = .red
        }
        return pinView
    }
}

extension InformationPostingVC: UITextFieldDelegate {
    
    //Text field delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
