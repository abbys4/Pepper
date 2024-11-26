import SwiftUI

enum ViewType {
    case list
    case calendar
}

class ViewStateManager: ObservableObject {
    @Published var currentView: ViewType = .list
} 