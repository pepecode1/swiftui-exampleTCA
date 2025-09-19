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
                
                if let result = viewStore.calculationResult {
                    Text("Calculation Result: \(result)")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                
                if viewStore.count >= viewStore.maxCount {
                    Text("Límite máximo alcanzado (\(viewStore.maxCount))")
                        .foregroundColor(.red)
                } else if viewStore.count <= viewStore.minCount {
                    Text("Límite mínimo alcanzado (\(viewStore.minCount))")
                        .foregroundColor(.red)
                }
                
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
                    
                    Button("Reset") {
                        viewStore.send(.resetButtonTapped)
                    }
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Button("Calculate") {
                        viewStore.send(.calculateButtonTapped)
                    }
                    .font(.title)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                Text("History")
                    .font(.headline)
                
                List(viewStore.history, id: \.self) { value in
                    Text("\(value)")
                }
                .frame(maxHeight: 200)
            }
            .padding()
        }
    }
}
