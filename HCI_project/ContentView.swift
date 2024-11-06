//
//  ContentView.swift
//  HCI_project
//
//  Created by Abby Santos on 11/2/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Updated Hello PEPPER")
            
        }
        .padding()
    }
}


struct ToolbarSolutionView: View {
    var body: some View {
        NavigationView{ //NavigationStack
            Text("Content")
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button("Activity") {
                            print("Hello Activity!")
                        }
                        Button("Groceries") {
                            print("Hello Groceries!")
                        }
                        Button("Recipes") {
                            print("Hello Recipes!")
                        }
                        Button("Delivery") {
                            print("Hello Delivery!")
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
    ToolbarSolutionView()
}
