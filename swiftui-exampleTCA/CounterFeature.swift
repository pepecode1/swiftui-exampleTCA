//
//  CounterFeature.swift
//  swiftui-exampleTCA
//
//  Created by Pepe Ruiz on 15/09/25.
//
import ComposableArchitecture
import Foundation
@Reducer
struct CounterFeature {
    /// State: El estado de la aplicación (datos que la vista necesita).
    @ObservableState
    struct State: Equatable {
        var count = 0
        var history: [Int] = []
        var calculationResult: Int?
        let maxCount = 100
        let minCount = -100
    }
    /// Action: Las acciones que el usuario o el sistema puede realizar.
    enum Action: Equatable {
        case incrementButtonTapped
        case decrementButtonTapped
        case delayedIncrement
        case resetButtonTapped
        case calculateButtonTapped
        case calculationCompleted(Int)
        
        /// Implementación manual de Equatable para manejar valores asociados
        static func == (lhs: Action, rhs: Action) -> Bool {
            switch (lhs, rhs) {
            case (.incrementButtonTapped, .incrementButtonTapped),
                 (.decrementButtonTapped, .decrementButtonTapped),
                 (.resetButtonTapped, .resetButtonTapped),
                 (.delayedIncrement, .delayedIncrement),
                 (.calculateButtonTapped, .calculateButtonTapped):
                return true
            case let (.calculationCompleted(lhsValue), .calculationCompleted(rhsValue)):
                return lhsValue == rhsValue
            default:
                return false
            }
        }
    }
    /// Inyectar la cola principal para manejo de tareas asyn y sync
    @Dependency(\.mainQueue) var mainQueue
    /// Reducer: Una función que describe cómo el estado cambia en respuesta a las acciones.
    /// body es donde defines la lógica del reducer usando el protocolo Reducer.
    /// Reduce es un bloque que toma el estado actual y una acción, y actualiza el estado.
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .incrementButtonTapped:
                if state.count < state.maxCount {
                    return .run { send in
                        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 segundo
                        await send(.delayedIncrement)
                    }
                }
                return .none
            case .decrementButtonTapped:
                state.count -= 1
                state.history.append(state.count)
                return .none
            case .delayedIncrement:
                if state.count < state.maxCount {
                    state.count += 1
                    state.history.append(state.count)
                }
                return .none
            case .resetButtonTapped:
                state.count = 0
                state.history.append(state.count)
                state.calculationResult = nil
                return .none
            case .calculateButtonTapped:
                let currentCount = state.count
                return .run { send in
                    /// Simular cálculo pesado en una cola en segundo plano
                    await withCheckedContinuation { continuation in
                        DispatchQueue.global(qos: .userInitiated).async {
                            /// Simular trabajo pesado (por ejemplo, calcular el cuadrado)
                            let result = currentCount * currentCount
                            /// Volver a la cola principal para enviar el resultado
                            DispatchQueue.main.async {
                                send(.calculationCompleted(result))
                                continuation.resume()
                            }
                        }
                    }
                }
            case .calculationCompleted(let result):
                state.calculationResult = result
                state.history.append(result)
                return .none
            }
        }
    }
}
