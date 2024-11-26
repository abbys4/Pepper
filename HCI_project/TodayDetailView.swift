import SwiftUI

struct TodayDetailView: View {
    let colorCircles: [Color] = [.red, .orange, .yellow, .green, .blue, .brown]
    
    struct GoToItem: Identifiable {
        let id = UUID()
        let name: String
        let imageName: String
        let backgroundColor: Color
        
        var imageExists: Bool {
            UIImage(named: imageName) != nil
        }
    }
    
    let goToItems = [
        GoToItem(name: "Red Apple", imageName: "red-apple", backgroundColor: .red.opacity(0.1)),
        GoToItem(name: "Orange", imageName: "orange", backgroundColor: .orange.opacity(0.1)),
        GoToItem(name: "Yellow Banana", imageName: "yellow-banana", backgroundColor: .yellow.opacity(0.1)),
        GoToItem(name: "Savoy Cabbage", imageName: "savoy-cabbage", backgroundColor: .green.opacity(0.1)),
        GoToItem(name: "Eggplant", imageName: "eggplant", backgroundColor: .purple.opacity(0.1)),
        GoToItem(name: "Quinoa", imageName: "quinoa", backgroundColor: .brown.opacity(0.1))
    ].map { item in
        print("Created item: \(item.imageName), image exists: \(item.imageExists)")
        return item
    }
    
    struct DietItem: Identifiable {
        let id = UUID()
        let name: String
        let imageName: String
        let color: Color
    }
    
    struct ColorSection: Identifiable {
        let id = UUID()
        let color: Color
        var items: [DietItem]
    }
    
    @State private var dietSections: [ColorSection] = []
    @State private var consumedColors: Set<Color> = []
    @State private var isEditing: Bool = false
    @State private var showingAddItemPopup = false
    @State private var searchText = ""
    
    private var filteredGoToItems: [GoToItem] {
        if searchText.isEmpty {
            return goToItems
        } else {
            return goToItems.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    private func addItem(_ item: GoToItem) {
        if let baseColor = colorCircles.first(where: { $0.description == item.backgroundColor.description.split(separator: " ").last?.lowercased() }) {
            consumedColors.insert(baseColor)
        }
        
        if let sectionIndex = dietSections.firstIndex(where: { $0.color == item.backgroundColor }) {
            var updatedSection = dietSections[sectionIndex]
            updatedSection.items.append(DietItem(
                name: item.name,
                imageName: item.imageName,
                color: item.backgroundColor
            ))
            dietSections[sectionIndex] = updatedSection
        } else {
            let newSection = ColorSection(
                color: item.backgroundColor,
                items: [DietItem(
                    name: item.name,
                    imageName: item.imageName,
                    color: item.backgroundColor
                )]
            )
            dietSections.append(newSection)
            dietSections.sort { $0.color.description < $1.color.description }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Color circles
                VStack(spacing: 8) {
                    HStack(spacing: 12) {
                        ForEach(colorCircles, id: \.self) { color in
                            Circle()
                                .fill(color.opacity(consumedColors.contains(color) ? 1.0 : 0.2))
                                .frame(width: 32, height: 32)
                        }
                    }
                    
                    Text("\(consumedColors.count) Color\(consumedColors.count == 1 ? "" : "s") Consumed")
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                
                // Your Diet Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Your Diet")
                            .font(.title2)
                            .bold()
                        Spacer()
                        if !dietSections.isEmpty {  // Only show Edit button if there are items
                            Button(action: {
                                isEditing.toggle()
                            }) {
                                Text(isEditing ? "Done" : "Edit")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    
                    if dietSections.isEmpty {
                        // Add New Item button for empty state
                        Button(action: {
                            showingAddItemPopup = true
                        }) {
                            VStack(spacing: 8) {
                                Image(systemName: "plus")
                                    .imageScale(.large)
                                    .foregroundColor(.green)
                                    .frame(width: 100, height: 100)
                                    .background(Color(UIColor.systemGray6))
                                    .cornerRadius(12)
                                
                                Text("Add New\nItem")
                                    .foregroundColor(.green)
                                    .multilineTextAlignment(.center)
                                    .font(.caption)
                            }
                            .frame(width: 100)  // Fixed width to match other items
                        }
                        
                        // Go To Section - only show when diet is empty
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Your Go-Tos")
                                .font(.title2)
                                .bold()
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(goToItems) { item in
                                    VStack(spacing: 4) {
                                        if item.imageExists {
                                            Image(item.imageName)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 100, height: 100)
                                                .background(item.backgroundColor.opacity(0.1))
                                                .cornerRadius(12)
                                        } else {
                                            Rectangle()
                                                .fill(item.backgroundColor.opacity(0.1))
                                                .frame(width: 100, height: 100)
                                                .overlay(
                                                    Text("No image")
                                                        .font(.caption)
                                                        .foregroundColor(.gray)
                                                )
                                                .cornerRadius(12)
                                        }
                                        
                                        Text(item.name)
                                            .font(.caption)
                                            .multilineTextAlignment(.center)
                                        
                                        Button(action: {
                                            addItem(item)
                                        }) {
                                            Image(systemName: "plus")
                                                .foregroundColor(.green)
                                                .frame(width: 32, height: 32)
                                                .background(Color.gray.opacity(0.05))
                                                .clipShape(Circle())
                                        }
                                    }
                                }
                            }
                            .padding(.top)
                        }
                    } else {
                        if isEditing {
                            Button(action: {
                                showingAddItemPopup = true
                            }) {
                                VStack(spacing: 8) {
                                    Image(systemName: "plus")
                                        .imageScale(.large)
                                        .foregroundColor(.green)
                                        .frame(width: 100, height: 100)
                                        .background(Color(UIColor.systemGray6))
                                        .cornerRadius(12)
                                    
                                    Text("Add New\nItem")
                                        .foregroundColor(.green)
                                        .multilineTextAlignment(.center)
                                        .font(.caption)
                                }
                            }
                        }
                        
                        ForEach(dietSections) { section in
                            VStack(alignment: .leading, spacing: 12) {
                                Text(section.color.description.split(separator: " ").last?.capitalized ?? "")
                                    .font(.title3)
                                    .bold()
                                
                                LazyVGrid(columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ], spacing: 12) {
                                    ForEach(section.items) { item in
                                        VStack(spacing: 8) {
                                            if let image = UIImage(named: item.imageName) {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 100, height: 100)
                                                    .background(item.color.opacity(0.1))
                                                    .cornerRadius(12)
                                            } else {
                                                Rectangle()
                                                    .fill(item.color.opacity(0.1))
                                                    .frame(width: 100, height: 100)
                                                    .cornerRadius(12)
                                            }
                                            
                                            Text(item.name)
                                                .font(.caption)
                                            
                                            if isEditing {
                                                Button(action: {
                                                    // Delete logic remains the same
                                                    if let sectionIndex = dietSections.firstIndex(where: { $0.color == section.color }),
                                                       let itemIndex = dietSections[sectionIndex].items.firstIndex(where: { $0.id == item.id }) {
                                                        dietSections[sectionIndex].items.remove(at: itemIndex)
                                                        
                                                        if dietSections[sectionIndex].items.isEmpty {
                                                            dietSections.remove(at: sectionIndex)
                                                            if let baseColor = colorCircles.first(where: { $0.description == section.color.description.split(separator: " ").last?.lowercased() }) {
                                                                consumedColors.remove(baseColor)
                                                            }
                                                        }
                                                    }
                                                }) {
                                                    Image(systemName: "trash")
                                                        .imageScale(.medium)
                                                        .foregroundStyle(.green)
                                                        .padding(8)
                                                        .background(Circle().fill(Color(UIColor.systemGray6)))
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("Today")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddItemPopup) {
            NavigationView {
                VStack {
                    SearchBar(text: $searchText)
                        .padding()
                    
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach(filteredGoToItems) { item in
                                VStack(spacing: 8) {
                                    if let image = UIImage(named: item.imageName) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                            .background(item.backgroundColor.opacity(0.1))
                                            .cornerRadius(12)
                                    }
                                    
                                    Text(item.name)
                                        .font(.caption)
                                    
                                    Button(action: {
                                        addItem(item)
                                        showingAddItemPopup = false
                                    }) {
                                        Image(systemName: "plus")
                                            .imageScale(.medium)
                                            .foregroundStyle(.green)
                                            .padding(8)
                                            .background(Circle().fill(Color(UIColor.systemGray6)))
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
                .navigationTitle("Add New Item")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            showingAddItemPopup = false
                        }
                    }
                }
                .background(Color(.systemBackground))  // This ensures the content area is white
            }
            .background(Color.black.opacity(0.5))  // This adds the black background
            .presentationBackground(.black.opacity(0.5))  // This makes the sheet background black
        }
    }
}

struct TodayDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TodayDetailView()
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}
