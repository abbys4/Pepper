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
            Text("Updated Hello World")
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
                        Button("Greeting") {
                            print("Hello world!")
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
