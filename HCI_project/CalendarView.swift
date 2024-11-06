//
//  CalendarView.swift
//  HCI_project
//
//  Created by Abby Santos on 11/6/24.
//

import SwiftUI



struct ActivityCalendarView: View {
    @State private var selectedDate = Date()
    @State private var showingCalendarOptions = false
    
    // Sample activity data structure
    struct DayActivity: Identifiable {
        let id = UUID()
        let date: Date
        let activities: [ActivityType]
    }
    
    enum ActivityType {
        case red, orange, yellow, green, blue, brown
    }
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 0) {
              // NavigationLink("ListView", destination: ContentView2())
                // Calendar header
                HStack {
                    Text("Activity")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Menu {
                        
                        //Button("List View", action: {
                        NavigationLink("ListView", destination: ContentView())
                            
                            
                        //})
                    } label: {
                        HStack {
                            Text("Calendar View")
                                .foregroundColor(.green)
                            Image(systemName: "chevron.down")
                                .foregroundColor(.green)
                            
                        }
                    }
                    
                    // Profile image
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                        )
                }
                .padding()
                
                // Calendar grid
                VStack(spacing: 20) {
                    // Weekday headers
                    HStack {
                        ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                            Text(day)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Month label
                    HStack {
                        Text("October")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // Calendar days
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 15) {
                        ForEach(1...31, id: \.self) { day in
                            VStack(spacing: 8) {
                                Text("\(day)")
                                    .font(.system(size: 16))
                                
                                // Activity dots
                                if day <= 24 {
                                    ActivityDotsView(activities: sampleActivities(for: day))
                                }
                            }
                            .frame(height: 50)
                            .opacity(day > 24 ? 0.3 : 1.0)
                        }
                    }
                }
                .padding()
                
                Spacer()
                
                // Tab bar
                // CustomTabBar()
                TabView {
                    
                Spacer()
                    .tabItem {
                        VStack {
                            Image(systemName: "circle.hexagongrid.fill")
                            Text("Activity")
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
                }.tint(.green)
            }
        }
    }
    
    // Helper to generate sample activities
    private func sampleActivities(for day: Int) -> [ActivityType] {
        let possibilities: [ActivityType] = [.red, .orange, .yellow, .green, .blue, .brown]
        return Array(possibilities.shuffled().prefix(Int.random(in: 3...5)))
    }
}

struct ActivityDotsView: View {
    let activities: [ActivityCalendarView.ActivityType]
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<min(activities.count, 3), id: \.self) { index in
                Circle()
                    .fill(color(for: activities[index]))
                    .frame(width: 6, height: 6)
            }
        }
        if activities.count > 3 {
            HStack(spacing: 4) {
                ForEach(3..<activities.count, id: \.self) { index in
                    Circle()
                        .fill(color(for: activities[index]))
                        .frame(width: 6, height: 6)
                }
            }
        }
    }
    
    private func color(for activity: ActivityCalendarView.ActivityType) -> Color {
        switch activity {
        case .red: return .red
        case .orange: return .orange
        case .yellow: return .yellow
        case .green: return .green
        case .blue: return .blue
        case .brown: return .brown
        }
    }
}

//struct CustomTabBar: View {
//    var body: some View {
//        HStack(spacing: 0) {
//            TabBarItem(icon: "circles.hexagonpath.fill", text: "Activity", isSelected: true)
//            TabBarItem(icon: "cart", text: "Groceries")
//            TabBarItem(icon: "book", text: "Recipes")
//            TabBarItem(icon: "shippingbox", text: "Delivery")
//        }
//        .padding(.vertical, 10)
//        .background(Color.white)
//        .overlay(
//            Rectangle()
//                .frame(height: 1)
//                .foregroundColor(.gray.opacity(0.2)),
//            alignment: .top
//        )
//    }
//}

struct TabBarItem: View {
    let icon: String
    let text: String
    var isSelected: Bool = false
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
            Text(text)
                .font(.system(size: 12))
        }
        .foregroundColor(isSelected ? .green : .gray)
        .frame(maxWidth: .infinity)
    }
}

struct ActivityCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityCalendarView()
        //ContentView2()
    }
}
