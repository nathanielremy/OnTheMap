//
//  MapViewDelegate.swift
//  OnTheMap
//
//  Created by Nathaniel Remy on 15/09/2017.
//  Copyright © 2017 Nathaniel Remy. All rights reserved.
//

import Foundation
import MapKit

extension MapVC: MKMapViewDelegate {
    
    func updateMapUI() {
        
        let locations = parseClient.studentInformation
        var annotations = [MKPointAnnotation]()
        
        for location in locations {
            
            guard let latitude = location.latitude, let longitude = location.longitude else { continue }
            let lat = CLLocationDegrees(latitude)
            let long = CLLocationDegrees(longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let firstName = location.firstName ?? "First name unavailable"
            let lastName = location.lastName ?? "Last name unavailable"
            let mediaURL = location.mediaURL ?? "URL unavailable"
            
            let annotation = MKPointAnnotation()
            annotation.title = firstName + " " + lastName
            annotation.subtitle = mediaURL
            annotation.coordinate = coordinate
            
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseIdentifier = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
        
        if let pinView = pinView {
            pinView.annotation = annotation
        } else {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            guard let urlString = view.annotation?.subtitle as? String, let url = URL(string: urlString) else {
                displayAlerView(withTitle: "Could not open URL", message: "User did not leave a valid URL", action: "Okay"); return }
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
