//
//  MapController.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 6/15/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

class MapController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: - ViewController Properties
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Object Variables
    var everyLostPeople: [Lost]?
    var locationManager: CLLocationManager?
    
    // MARK: - Interface Objects
    lazy var mapView: MKMapView = {
        let mv = MKMapView()
        mv.delegate = self
        mv.showsUserLocation = true
        mv.translatesAutoresizingMaskIntoConstraints = false
        return mv
    }()
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
//        button.tintColor = UIColor(white: 0.5, alpha: 0.8)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupLostPins()
        setupDismissButton()
    }
    
    // MARK: - Setup Methods
    
    fileprivate func setupMapView() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.requestAlwaysAuthorization()
            locationManager?.startUpdatingLocation()
        }
    }
    fileprivate func setupLostPins() {
        guard let losts = everyLostPeople else {
            print("Mapa: No se encontraron desaparecidos")
            return
        }
        print("Mapa: Se encontraron desaparecidos")
        for lost in losts {
            let coordinate = CLLocationCoordinate2D(latitude: lost.latitude, longitude: lost.longitude)
//            let circle = MKCircle(center: coordinate, radius: 50)
            let lostAnnotation = LostAnnotation(title: lost.lastname, coordinate: coordinate)
            mapView.addAnnotation(lostAnnotation)
//            mapView.add(circle)
        }
    }
    fileprivate func setupDismissButton() {
        view.addSubview(dismissButton)
        dismissButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.top.equalTo(self.view).offset(12)
            make.right.equalTo(self.view).offset(-12)
        }
    }
    
    // MARK: - Handle Methods
    
    func handleDismiss() {
        dismiss(animated: true)
    }
    
    
    // MARK: - Delegate Methods
    
    // set the screen for the first time
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.0075, longitudeDelta: 0.0075))
        mapView.setRegion(region, animated: true)
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circleOverlay = overlay as? MKCircle {
            let overlayRenderer = MKCircleRenderer(overlay: circleOverlay)
            overlayRenderer.lineWidth = 1
            overlayRenderer.fillColor = UIColor.blue.withAlphaComponent(0.1)
            overlayRenderer.strokeColor = .gray
            return overlayRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
}
