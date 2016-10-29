//
//  GCD.swift
//  OnTheMapProject
//
//  Created by Brittany Sprabery on 10/7/16.
//  Copyright © 2016 Brittany Sprabery. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
