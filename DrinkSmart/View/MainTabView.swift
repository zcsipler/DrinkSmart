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

    enum Tab: Hashable {
        case history, live, profile
    }

    var body: some View {
        TabView(selection: $selection) {
            HistoryView(store: store)
                .tabItem {
                    Label {
                        Text("History")
                    } icon: {
                        Image(systemName: "calendar")
                    }
                }
                .tag(Tab.history)

            LiveView(store: store)
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
