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
    var body2: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Updated Hello PEPPER")
            
        }
        .padding()
        
        
    }
}


struct Cview: View {
    @State var selectedDate: Date = Date()
   var body: some View {
       VStack() {
           Text(selectedDate.formatted(date: .abbreviated, time: .omitted))
               .font(.system(size: 28))
               .bold()
               .foregroundColor(Color.accentColor)
               .padding()
               .animation(.spring(), value: selectedDate)
               .frame(width: 500)
           Divider().frame(height: 1)
           DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
               .padding(.horizontal)
               .datePickerStyle(.graphical)
           Divider()
       }
       .padding(.vertical, 100)
    }
}
struct ToolbarSolutionView: View {
    var body: some View {
        NavigationView{ //NavigationStack
            Text("")
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
    Cview()
    ToolbarSolutionView()
    
}
