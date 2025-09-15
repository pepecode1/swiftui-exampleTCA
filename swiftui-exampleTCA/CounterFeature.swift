//
//  CounterFeature.swift
//  swiftui-exampleTCA
//
//  Created by Pepe Ruiz on 15/09/25.
//
import ComposableArchitecture
@Reducer
struct CounterFeature {
    /// State: El estado de la aplicación (datos que la vista necesita).
    @ObservableState
    struct State: Equatable {
        var count = 0
    }
    /// Action: Las acciones que el usuario o el sistema puede realizar.
    enum Action {
        case incrementButtonTapped
        case decrementButtonTapped
        case delayedIncrement
    }
    /// Reducer: Una función que describe cómo el estado cambia en respuesta a las acciones.
    /// body es donde defines la lógica del reducer usando el protocolo Reducer.
    /// Reduce es un bloque que toma el estado actual y una acción, y actualiza el estado.
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .incrementButtonTapped:
                return .run { send in
                    try await Task.sleep(nanoseconds: 1_000_000_000) // 1 segundo
                    await send(.delayedIncrement)
                }
            case .decrementButtonTapped:
                state.count -= 1
                return .none
            case .delayedIncrement:
                state.count += 1
                return .none
            }
        }
    }
}
