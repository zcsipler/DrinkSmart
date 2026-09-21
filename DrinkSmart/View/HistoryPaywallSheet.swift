import SwiftUI

/// What stands between a free user and the rest of their history.
///
/// It says three things, in this order: what is behind the lock, that the
/// data is already there, and how to open it. The middle one matters most —
/// the flag gates the view, never the record (11.3), and a user deciding
/// whether to pay should know they are buying a window onto data they already
/// own, not a subscription to start collecting it.
///
/// There is no store behind the button yet. In debug builds it flips the
/// feature override, which is how the locked and unlocked screens get tested
/// side by side; in release it says so and does nothing.
struct HistoryPaywallSheet: View {
    @Environment(\.dismiss) private var dismiss

    private var flags: FeatureFlags { .shared }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 22) {
                Image(systemName: "chart.bar.xaxis")
                    .font(.system(size: 40, weight: .thin))
                    .foregroundStyle(Theme.calm)
                    .padding(.top, 36)

                Text("See further back")
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .foregroundStyle(Theme.primaryText)

                VStack(spacing: 14) {
                    Text("Weeks, months and years side by side — and every evening older than seven days.")
                    Text("Everything you have logged is already saved. Unlocking only shows it.")
                }
                .font(.system(size: 14, design: .rounded))
                .foregroundStyle(Theme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

                Spacer()

                #if DEBUG
                Button {
                    flags.setOverride(true, for: .historyTrends)
                    dismiss()
                } label: {
                    Text(verbatim: "Unlock (debug override)")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .tint(Theme.calm)
                .padding(.horizontal, 24)
                #else
                Text("Coming soon")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(Theme.secondaryText)
                #endif
            }
            .padding(.bottom, 28)
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    HistoryPaywallSheet()
}
