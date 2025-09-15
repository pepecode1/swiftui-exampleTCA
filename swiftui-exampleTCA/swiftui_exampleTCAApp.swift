//
//  swiftui_exampleTCAApp.swift
//  swiftui-exampleTCA
//
//  Created by Pepe Ruiz on 15/09/25.
//
import SwiftUI
import ComposableArchitecture

@main
struct swiftui_exampleTCAApp: App {
    var body: some Scene {
        WindowGroup {
            CounterView(
                store: Store(initialState: CounterFeature.State()) {
                    CounterFeature()
                }
            )
        }
    }
}
