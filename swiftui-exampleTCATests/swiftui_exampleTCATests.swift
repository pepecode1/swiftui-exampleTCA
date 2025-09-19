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
        // Crear un TestScheduler para controlar el tiempo
        let mainQueue = DispatchQueue.test
        
        // Crear el TestStore con el estado inicial y el reducer
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.mainQueue = mainQueue.eraseToAnyScheduler()
        }
        
        // Verificar estado inicial
        XCTAssertEqual(store.state.count, 0, "El contador inicial debe ser 0")
        XCTAssertEqual(store.state.history, [], "El historial inicial debe estar vacío")
        XCTAssertNil(store.state.calculationResult, "El resultado inicial debe ser nulo")
        
        // Probar incremento
        await store.send(.incrementButtonTapped)
        await mainQueue.advance(by: .seconds(1)) // Avanzar el tiempo 1 segundo
        await store.receive(.delayedIncrement) {
            $0.count = 1
            $0.history = [1]
        }
        
        // Probar otro incremento
        await store.send(.incrementButtonTapped)
        await mainQueue.advance(by: .seconds(1)) // Avanzar el tiempo 1 segundo
        await store.receive(.delayedIncrement) {
            $0.count = 2
            $0.history = [1, 2]
        }
        
        // Probar decremento
        await store.send(.decrementButtonTapped) {
            $0.count = 1
            $0.history = [1, 2, 1]
        }
        
        // Probar reinicio
        await store.send(.resetButtonTapped) {
            $0.count = 0
            $0.history = [1, 2, 1, 0]
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
            $0.history = [-1]
        }
        
        // Decrementar nuevamente
        await store.send(.decrementButtonTapped) {
            $0.count = -2
            $0.history = [-1, -2]
        }
        
        // Incrementar para volver a -1
        await store.send(.incrementButtonTapped)
        await store.receive(.delayedIncrement) {
            $0.count = -1
            $0.history = [-1, -2, -1]
        }
        
        // Reiniciar
        await store.send(.resetButtonTapped) {
            $0.count = 0
            $0.history = [-1, -2, -1, 0]
        }
    }
    
    func testDelayedIncrement() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        
        await store.send(.incrementButtonTapped)
        await store.receive(.delayedIncrement) {
            $0.count = 1
            $0.history = [1]
        }
    }
    
    func testCounterLimits() async {
        let store = TestStore(initialState: CounterFeature.State(count: 99)) {
            CounterFeature()
        }
        
        // Incrementar hasta el límite
        await store.send(.incrementButtonTapped)
        await store.receive(.delayedIncrement) {
            $0.count = 100
            $0.history = [100]
        }
        
        // Intentar incrementar más allá del límite (no debería cambiar)
        await store.send(.incrementButtonTapped)
        
        // Decrementar
        await store.send(.decrementButtonTapped) {
            $0.count = 99
            $0.history = [100, 99]
        }
    }
    
    func testCalculation() async {
        let mainQueue = DispatchQueue.test
        
        let store = TestStore(initialState: CounterFeature.State(count: 5)) {
            CounterFeature()
        } withDependencies: {
            $0.mainQueue = mainQueue.eraseToAnyScheduler()
        }
        
        // Probar cálculo
        await store.send(.calculateButtonTapped)
        await mainQueue.advance() // Avanzar el scheduler para ejecutar DispatchQueue.global y DispatchQueue.main
        await store.receive(.calculationCompleted(25)) {
            $0.calculationResult = 25
            $0.history = [25]
        }
        
        // Probar reinicio después del cálculo
        await store.send(.resetButtonTapped) {
            $0.count = 0
            $0.history = [25, 0]
            $0.calculationResult = nil
        }
    }
}
