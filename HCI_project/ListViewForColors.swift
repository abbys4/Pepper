import SwiftUI

struct ListView: View {
    @ObservedObject var viewState: ViewStateManager
    
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
                    Menu {
                        Button("Calendar View") {
                            viewState.currentView = .calendar
                        }
                    } label: {
                        HStack {
                            Text("List View")
                                .foregroundColor(.green)
                            Image(systemName: "chevron.down")
                                .foregroundColor(.green)
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
        NavigationLink(destination: TodayDetailView()) {
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
    ListView(viewState: ViewStateManager())
}