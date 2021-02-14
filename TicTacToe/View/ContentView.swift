//
//  ContentView.swift
//  TicTacToe
//
//  Created by William Santoso on 12/02/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    
    let columns: [GridItem] = [
        .init(.flexible(), spacing: 30, alignment: .center),
        .init(.flexible(), spacing: 30, alignment: .center),
        .init(.flexible(), spacing: 30, alignment: .center),
    ]
    
    var body: some View {
        VStack {
            Text("\(viewModel.status.rawValue)")
                .font(.title)
            
            Text("\(viewModel.turn.rawValue)")
                .font(.title)
                .padding(.bottom)
            
                
            LazyVGrid(columns: columns,  spacing: 30) {
                ForEach(0 ..< 3) { i in
                    ForEach(0 ..< 3) { j in
                        Image(systemName: getImage(viewModel.inputs[i][j]))
                            .resizable()
                            .frame(width: 100, height: 100)
                            .onTapGesture {
                                viewModel.updateInput(i, j)
                            }
                            
                    }
                }
            }
            .background(
                ZStack {
                    HStack {
                        Spacer()
                        
                        Rectangle()
                            .frame(width: 2.0)
                        
                        
                        Spacer()
                        
                        
                        Rectangle()
                            .frame(width: 2.0)
                        
                        Spacer()
                    }
                    
                    VStack {
                        Spacer()
                        
                        Rectangle()
                            .frame(height: 2.0)
                        
                        Spacer()
                        
                        Rectangle()
                            .frame(height: 2.0)
                        
                        Spacer()
                    }
                }
            )
            
            Button(action: {
                viewModel.reset()
            }) {
                Text("Reset")
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                    .padding()
                    .background(
                        Capsule()
                            .foregroundColor(.secondary)
                    )
            }
            .padding()
        }
        .alert(isPresented: $viewModel.isShowAlert) {
            Alert(title: Text("\(viewModel.status.rawValue)"),
                  dismissButton: .default(Text("Restart"), action: {
                    viewModel.reset()
                  })
             )
        }
        .padding(20)
    }
    
    func getImage(_ input: Int) -> String {
        switch input {
        case 1:
            return "xmark"
        case -1:
            return "circle"
        default:
            return "square"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
