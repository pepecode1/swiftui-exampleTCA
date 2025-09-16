//
//  swiftui_exampleTCATests.swift
//  swiftui-exampleTCATests
//
//  Created by Pepe Ruiz on 15/09/25.
//

import ComposableArchitecture
import XCTest
@testable import swiftui_exampleTCA

@MainActor
final class CounterFeatureTests: XCTestCase {
    func testCounterBasics() async {
        // Crear el TestStore con el estado inicial y el reducer
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        
        // Verificar el estado inicial
        XCTAssertEqual(store.state.count, 0, "El contador inicial debe ser 0")
        
        // Probar el incremento
        await store.send(.incrementButtonTapped)
        await store.receive(.delayedIncrement) {
            $0.count = 1
        }
        
        // Probar un segundo incremento
        await store.send(.incrementButtonTapped)
        await store.receive(.delayedIncrement) {
            $0.count = 2
        }
        
        // Probar el decremento
        await store.send(.decrementButtonTapped) {
            $0.count = 1
        }
        
        // Probar volver al estado inicial
        await store.send(.decrementButtonTapped) {
            $0.count = 0
        }
    }
    
    func testCounterNegativeValues() async {
        // Probar el comportamiento con valores negativos
        let store = TestStore(initialState: CounterFeature.State(count: 0)) {
            CounterFeature()
        }
        
        // Decrementar desde 0
        await store.send(.decrementButtonTapped) {
            $0.count = -1
        }
        
        // Decrementar nuevamente
        await store.send(.decrementButtonTapped) {
            $0.count = -2
        }
        
        // Incrementar para volver a -1
        await store.send(.incrementButtonTapped)
        await store.receive(.delayedIncrement) {
            $0.count = -1
        }
    }
    
    func testDelayedIncrement() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        
        await store.send(.incrementButtonTapped)
        await store.receive(.delayedIncrement) {
            $0.count = 1
        }
    }
}
