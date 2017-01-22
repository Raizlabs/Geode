//
//  OneShotViewController.swift
//  Example
//
//  Created by John Watson on 2/1/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Geode
import MapKit
import UIKit

final class OneShotViewController: LocationViewController {

    fileprivate var locator = Geode.GeoLocator(mode: .oneShot)

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "One-Shot"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(OneShotViewController.refreshAction)
        )

        // Accept all location values.
        locator.maxLocationAge = DBL_MAX
        locator.manager.requestWhenInUseAuthorization()
        locator.logHandler = type(of: self).logHandler
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        refreshLocation()
    }

}

// MARK: - Actions

extension OneShotViewController {

    /**
     Refresh the user's current location.
     */
    func refreshAction() {
        refreshLocation()
    }

}

// MARK: - Private

private extension OneShotViewController {

    func refreshLocation() {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
        spinner.startAnimating()

        let refreshItem = navigationItem.rightBarButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)

        locator.requestLocationUpdate { [weak self] location in
            if location.coordinate == kCLLocationCoordinate2DInvalid {
                self?.mapView.removeAnnotations(self?.mapView.annotations ?? [])
            }
            else {
                self?.mapView.setRegion(MKCoordinateRegionMakeWithDistance(location.coordinate, 1000.0, 1000.0), animated: true)
                self?.addAnnotation(forLocation: location)
            }

            spinner.stopAnimating()
            self?.navBarExtension.coordinate = location.coordinate
            self?.navigationItem.rightBarButtonItem = refreshItem
        }
    }

}
