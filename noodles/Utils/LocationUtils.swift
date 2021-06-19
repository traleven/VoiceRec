//
//  LocationUtils.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 19.06.21.
//

import Foundation
import CoreLocation

class LocationUtils : NSObject {

	private(set) static var shared: LocationUtils = LocationUtils()

	private var locationManager: CLLocationManager
	private var latestVisit: CLVisit?
	private var latestLocation: CLLocation?
	private var latestPlacemark: CLPlacemark?

	private override init() {
		locationManager = CLLocationManager()
		super.init()

		locationManager.delegate = self
		self.start()
	}

	deinit {
		self.stop()
	}

	func start() {
		guard locationManager.authorizationStatus != .denied else {
			return
		}

		if locationManager.authorizationStatus == .notDetermined {
			locationManager.requestWhenInUseAuthorization()
		}

		locationManager.startMonitoringVisits()
		locationManager.requestLocation()
	}

	func fetchLocationDescription(completionHandler: @escaping (CLPlacemark?) -> Void) {

		if let location = locationManager.location {
			if let latestLocation = latestLocation, let latestPlacemark = latestPlacemark {
				if location.distance(from: latestLocation) < 15 {
					completionHandler(latestPlacemark)
				} else {
					self.latestPlacemark = nil
				}
			}

			let geocoder = CLGeocoder()

			// Look up the location and pass it to the completion handler
			geocoder.reverseGeocodeLocation(location, completionHandler: { [weak self] (placemarks, error) in
				if error == nil {
					let firstLocation = placemarks?[0]
					self?.latestLocation = location
					self?.latestPlacemark = firstLocation
					completionHandler(firstLocation)
				} else {
				 // An error occurred during geocoding.
					self?.latestLocation = nil
					self?.latestPlacemark = nil
					completionHandler(nil)
				}
			})
		}
		else {
			// No location was available.
			latestLocation = nil
			latestPlacemark = nil
			completionHandler(nil)
		}
	}

	func stop() {
		locationManager.stopMonitoringVisits()
	}
}

extension LocationUtils : CLLocationManagerDelegate {

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		if let error = error as? CLError {
			if error.code == .denied {
			   // Location updates are not authorized.
				manager.stopMonitoringVisits()
			   return
			}
		}
	}


	func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {

		latestVisit = visit
		print("\(visit)")
	}


	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

		let location = locations.last
		if let location = location {
			if let latest = latestLocation, location.distance(from: latest) > 15 {
				latestLocation = location
				latestPlacemark = nil
			}
		}
	}
}
