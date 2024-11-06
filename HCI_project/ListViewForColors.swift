import SwiftUI

struct ContentView2: View {
    var body: some View {
        TabView {
            ListView()
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
        }
        .tint(.green)
    }
}

struct ListView: View {
    var body: some View {
        NavigationView {
            List {
                ActivitySection(title: "Today", colorsConsumed: 0)
                ActivitySection(title: "Yesterday", colorsConsumed: 4, 
                              colors: [.red, .yellow, .green, .brown])
                ActivitySection(title: "October 22, 2024", colorsConsumed: 6, 
                              colors: [.red, .orange, .yellow, .green, .blue, .brown])
                ActivitySection(title: "October 21, 2024", colorsConsumed: 5, 
                              colors: [.red, .orange, .yellow, .green, .brown])
                ActivitySection(title: "October 20, 2024", colorsConsumed: 3, 
                              colors: [.orange, .yellow, .brown])
                ActivitySection(title: "October 19, 2024", colorsConsumed: 6, 
                              colors: [.red, .orange, .yellow, .green, .blue, .brown])
                ActivitySection(title: "October 18, 2024", colorsConsumed: 5, 
                              colors: [.red, .orange, .yellow, .green, .brown])
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Activity")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 12) {
                        Menu {
                            Button("List View", action: {})
                        } label: {
                            HStack {
                                Text("List View")
                                    .foregroundColor(.green)
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.green)
                            }
                        }
                        
                        Button(action: {}) {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Image(systemName: "person.crop.circle.fill")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 32))
                                )
                        }
                    }
                }
            }
        }
    }
}

struct ActivitySection: View {
    let title: String
    let colorsConsumed: Int
    var colors: [Color] = []
    
    var body: some View {
        NavigationLink(destination: Text("Detail View")) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                Text("\(colorsConsumed) Color\(colorsConsumed == 1 ? "" : "s") Consumed")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                if !colors.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(colors, id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 24, height: 24)
                        }
                    }
                    .padding(.top, 4)
                }
            }
            .padding(.vertical, 8)
        }
        .listRowSeparator(.visible)
        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
    }
}

#Preview {
    ContentView2()
}