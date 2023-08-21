//
//  opiniaoplayApp.swift
//  opiniaoplay
//
//  Created by Diego Moreira on 20/08/23.
//

import SwiftUI

@main
struct OpiniaoplayApp: App {
    @StateObject private var configService = ConfigService.shared
        
        var body: some Scene {
            WindowGroup {
                ContentView()
                    .environmentObject(configService)
            }
        }
}
