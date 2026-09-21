import SwiftUI
import UIKit

/// The app's language — named here, changed in Settings.
///
/// iOS gives every app that ships more than one localization its own
/// "Preferred Language" entry in Settings, and switching it there relaunches
/// the app in the new language, independently of the system language. That is
/// the whole feature, already built and already understood by users.
///
/// The alternative would be an in-app picker writing `AppleLanguages` into
/// UserDefaults behind the system's back. It needs the same relaunch, except
/// the app cannot perform one — `exit(0)` reads as a crash and is grounds for
/// rejection — so it would end in asking the user to kill the app by hand, and
/// it would leave the app's idea of its language disagreeing with the system's.
///
/// So this section does not own the setting. It names the language in force,
/// says what happens next, and hands over.
struct LanguageSection: View {
    @Environment(\.openURL) private var openURL

    var body: some View {
        Section {
            Button {
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                openURL(url)
            } label: {
                HStack {
                    Text("Language")
                        .foregroundStyle(Theme.primaryText)
                    Spacer()
                    Text(verbatim: currentLanguage)
                        .foregroundStyle(Theme.calm)
                    Image(systemName: "arrow.up.forward.app")
                        .font(.footnote)
                        .foregroundStyle(Theme.secondaryText)
                }
            }
        } footer: {
            Text("Opens this app in Settings, where “Preferred Language” sets the app's own language — the system's stays as it is. iOS restarts the app when you change it.")
        }
        .listRowBackground(Theme.surface)
    }

    /// The language the app is actually running in.
    ///
    /// `Bundle.main.preferredLocalizations` rather than `Locale.current`: the
    /// latter follows the region too, so it would say "English" on a Hungarian
    /// phone set to a US region while the interface was still Hungarian. Named
    /// in itself — "Magyar", not "Hungarian" — the way Settings names it, so
    /// the row still reads to someone who has just switched away from a
    /// language they understand.
    private var currentLanguage: String {
        let code = Bundle.main.preferredLocalizations.first ?? "en"
        let name = Locale(identifier: code).localizedString(forLanguageCode: code)
        return (name ?? code).localizedCapitalized
    }
}

#Preview {
    Form {
        LanguageSection()
    }
    .scrollContentBackground(.hidden)
    .background(Theme.background)
}
