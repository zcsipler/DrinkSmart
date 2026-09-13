import SwiftUI

/// The app's three places: what happened before, what is happening now, and
/// who the app thinks you are.
///
/// Live sits in the middle and is selected at launch. It is what the app is
/// for, and a centre position keeps the two others one step away in either
/// direction rather than stacking them on one side.
struct MainTabView: View {
    let store: SessionStore

    @Environment(\.scenePhase) private var scenePhase
    @State private var selection: Tab = .live

    /// Bumped whenever the user asks for the Live tab, including a re-tap on
    /// the tab they are already on.
    ///
    /// Live keeps which day you paged to in its own state, and `TabView` does
    /// not discard the view when you switch away. Without this you come back
    /// from History still parked three days in the past — with no chart and no
    /// add button, since that only belongs to today. Coming back to Live means
    /// coming back to now.
    @State private var liveHomeToken = 0

    enum Tab: Hashable {
        case history, live, profile
    }

    /// Fires even when the selection does not change, which is what makes the
    /// re-tap work.
    private var selectionBinding: Binding<Tab> {
        Binding(
            get: { selection },
            set: { newValue in
                if newValue == .live { liveHomeToken += 1 }
                selection = newValue
            }
        )
    }

    var body: some View {
        TabView(selection: selectionBinding) {
            HistoryView(store: store)
                .tabItem {
                    Label {
                        Text("History")
                    } icon: {
                        Image(systemName: "calendar")
                    }
                }
                .tag(Tab.history)

            LiveView(store: store, homeToken: liveHomeToken)
                .tabItem {
                    Label {
                        Text("Live")
                    } icon: {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                    }
                }
                .tag(Tab.live)

            ProfileView(store: store)
                .tabItem {
                    Label {
                        Text("Profile")
                    } icon: {
                        Image(systemName: "person.crop.circle")
                    }
                }
                .tag(Tab.profile)
        }
        .tint(Theme.calm)
        .preferredColorScheme(.dark)
        // A session left open overnight has to be closed when the app comes
        // back, not only when the next drink is logged.
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { store.refreshFromStore() }
        }
    }
}

#Preview {
    MainTabView(store: .preview)
}
