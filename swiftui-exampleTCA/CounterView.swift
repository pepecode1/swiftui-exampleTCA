//
//  CounterView.swift
//  swiftui-exampleTCA
//
//  Created by Pepe Ruiz on 15/09/25.
//
import SwiftUI
import ComposableArchitecture

struct CounterView: View {
    let store: StoreOf<CounterFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 20) {
                Text("Count: \(viewStore.count)")
                    .font(.title)
                
                HStack {
                    Button("-") {
                        viewStore.send(.decrementButtonTapped)
                    }
                    .font(.title)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    
                    Button("+") {
                        viewStore.send(.incrementButtonTapped)
                    }
                    .font(.title)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                }
            }
        }
    }
}
