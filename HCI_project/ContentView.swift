//
//  ContentView.swift
//  HCI_project
//
//  Created by Abby Santos on 11/2/24.
//

import SwiftUI

struct ContentView2: View {
    @StateObject private var viewState = ViewStateManager()
    
    var body: some View {
        TabView {
            if viewState.currentView == .list {
                ListView(viewState: viewState)
                    .tabItem {
                        VStack {
                            Image(systemName: "circle.hexagongrid.fill")
                            Text("Activity")
                        }
                    }
            } else {
                ActivityCalendarView(viewState: viewState)
                    .tabItem {
                        VStack {
                            Image(systemName: "circle.hexagongrid.fill")
                            Text("Activity")
                        }
                    }
            }
            
            Text("Groceries")
                .tabItem {
                    VStack {
                        Image(systemName: "cart")
                        Text("Groceries")
                    }
                }
            
            Text("Recipes")
                .tabItem {
                    VStack {
                        Image(systemName: "book")
                        Text("Recipes")
                    }
                }
            
            Text("Delivery")
                .tabItem {
                    VStack {
                        Image(systemName: "bag")
                        Text("Delivery")
                    }
                }
        }
        .tint(.green)
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
    //ContentView()
    Cview()
    ToolbarSolutionView()
    
}
