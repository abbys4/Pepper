//
//  CalendarView.swift
//  HCI_project
//
//  Created by Abby Santos on 11/6/24.
//

import SwiftUI

let formatter = DateFormatter()

extension Date {
    func startOfMonth () -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year,.month],from:self)
        return calendar.date(from: components) ?? self
    }
    
    func endOfMonth() -> Date {
        let calendar = Calendar.current
        let components = DateComponents(month: 1, day: -1)
        return calendar.date(byAdding: components, to: self.startOfMonth()) ?? self
    }
    
    var dayOfMonth: Int {
        Calendar.current.component(.day, from: self)
    }
}

struct ActivityDot: View {
    let color: Color
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 6, height: 6)
    }
}

struct CalendarDay: View {
    let date: Date?
    let dots: [(Color, UUID)]
    let isSelected: Bool
    let isToday: Bool
    
    var body: some View {
        if let date = date {
            VStack(spacing: 4) {
                Text("\(date.dayOfMonth)")
                    .font(.system(size: 16))
                    .foregroundColor(isSelected ? .white : .primary)
                
                // Activity dots
                HStack(spacing: 4) {
                    ForEach(dots, id: \.1) {
                        dot in ActivityDot(color: isSelected ? .white : dot.0)
                    }
                }
            }
            .frame(height: 45)
            .background(
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 32, height: 32)
                    }
                    if isToday && !isSelected {
                        Circle()
                            .stroke(Color.green, lineWidth: 1)
                            .frame(width: 32, height: 32)
                    }
                }
            )
            .contentShape(Rectangle())
        } else {
            Color.clear
                .frame(height: 45)
        }
    }
}

struct CalendarView: View {
    @ObservedObject var viewState: ViewStateManager
    @State private var selectedDate: Date = Date()
    @State private var currentMonth: Date = Date()
    @State private var selectedMonthActivities: [DayActivity] = []
    @State private var selectedColors: [Color] = [.red,.orange]
    @State private var selectedActivities: [(Color, UUID)] = []
    
    // Sample activity data structure
    struct DayActivity {
        let date: Date
        let activities: [(Color, UUID)]
    }
    
    let calendar = Calendar.current
    let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    let weekdays = ["S", "M", "T", "W", "T", "F", "S"]
    
    // Generate dates for the current month view
    func datesInMonth() -> [Date?] {
        let monthStart = currentMonth.startOfMonth()
        let monthEnd = currentMonth.endOfMonth()
        
        let firstWeekday = calendar.component(.weekday, from: monthStart)
        let daysInMonth = calendar.component(.day, from: monthEnd)
        
        var dates: [Date?] = Array(repeating: nil, count: firstWeekday - 1)
        
        for day in 1...daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart) {
                dates.append(date)
            }
        }
        
        // Add padding to complete the last week
        while dates.count % 7 != 0 {
            dates.append(nil)
        }
        
        return dates
    }
    
    // Sample data generator for the current month
    func generateActivitiesForMonth() {
        let dates = datesInMonth().compactMap { $0 }
        selectedMonthActivities = dates.map { date in
            // Generate random activities for demonstration
            let numberOfActivities = Int.random(in: 1...4)
            let colors: [Color] = [.blue, .green, .orange, .red, .yellow, .brown]
            let activities = (0..<numberOfActivities).map { _ in
                (colors.randomElement() ?? .blue, UUID())
            }
            return DayActivity(date: date, activities: activities)
        }
    }
    
    var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Month navigation and label
                HStack {
                    Button(action: previousMonth) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.green)
                    }
                    
                    Text(monthYearString)
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity)
                    
                    Button(action: nextMonth) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.green)
                    }
                }
                .padding(.horizontal)
                
                // Weekday headers
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(weekdays, id: \.self) { day in
                        Text(day)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.gray)
                            .frame(height: 40)
                    }
                }
                
                // Calendar grid
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(Array(datesInMonth().enumerated()), id: \.offset) { _, date in
                        if let date = date {
                            let activities = selectedMonthActivities.first(where: {
                                calendar.isDate($0.date, inSameDayAs: date)
                            })?.activities ?? []
                            
                            
                            CalendarDay(
                                date: date,
                                dots: activities,
                                isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                                isToday: calendar.isDateInToday(date)
                            )
                            .onTapGesture {
                                print(date)
                               
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedDate = date
                                }
                            }
                        } else {
                            CalendarDay(date: nil, dots: [], isSelected: false, isToday: false)
                        }
                    }
                }
                .padding(.horizontal)
                
                //display colors from selected day
                Text(formatter.string(from: selectedDate))
                
                
               
                var selectedActivities = selectedMonthActivities.first(where: {
                    calendar.isDate($0.date, inSameDayAs: selectedDate)
                })?.activities ?? []
                
                if !selectedColors.isEmpty {
                    HStack(spacing: 6) {

                        ForEach(selectedActivities.indices, id: \.self) {index in
                            Circle()
                                .fill(.red)
                                .fill(selectedActivities[index].0)
                                .frame(width: 24, height: 24)
                        }
                        
                       
                    }
                                        .padding(.top, 4)
                }
                Spacer()
                //bottom bar
                //ToolbarSolutionView()
                
                
            }
            .navigationTitle("Activity")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("List View") {
                            viewState.currentView = .list
                        }
                    } label: {
                        HStack {
                            Text("Calendar View")
                                .foregroundColor(.green)
                            Image(systemName: "chevron.down")
                                .foregroundColor(.green)
                        }
                    }
                }
            }
            .onAppear {
                
                formatter.dateFormat = "E, d MMM y"
                generateActivitiesForMonth()
            }
        }
    }
    
    // Month navigation functions
    func nextMonth() {
        withAnimation {
            currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
            generateActivitiesForMonth()
        }
    }
    
    func previousMonth() {
        withAnimation {
            currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
            generateActivitiesForMonth()
        }
    }
}


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
struct ContentView4: View {
    @StateObject private var viewState = ViewStateManager()
    
    var body: some View {
        TabView {
            CalendarView(viewState: viewState)
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
struct ActivityCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView4()
    }
}



//func nextMonth() {
//    withAnimation {
//        currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
//        generateActivitiesForMonth()
//    }
//}

