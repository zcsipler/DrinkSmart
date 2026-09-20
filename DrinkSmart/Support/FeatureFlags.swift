import Foundation
import Observation

/// What this *build* is provisioned for — as opposed to what the user has
/// bought, which is `FeatureFlags`.
///
/// Deliberately not a `Feature`. `FeatureFlags.isEnabled` falls through to
/// `isPurchased`, so anything listed there becomes a paid feature the moment
/// StoreKit lands. Syncing is not something anyone buys; it is something the
/// target either carries an entitlement for or does not.
///
/// A compile-time constant rather than a debug toggle, for the same reason:
/// flipping a switch at runtime cannot conjure an entitlement, and the store is
/// opened once at launch, before any switch could be read.
enum BuildCapabilities {

    /// Whether to open the store with CloudKit mirroring.
    ///
    /// **Off, and this is the only line to change.** Turning it on requires the
    /// iCloud capability on the target, which requires a paid Apple Developer
    /// Program membership — a Personal Team cannot add it, and Xcode does not
    /// even list it. See 11.4 in CLAUDE.md for the full checklist.
    ///
    /// With this off the app opens a local store and behaves exactly as it did
    /// before any of the sync work: nothing is gated, nothing is hidden, and no
    /// code is dead — `DrinkSmartApp.makeContainer` and the remote-change
    /// observer in `SessionStore` are both written and waiting.
    static let cloudSync = false
}

/// A feature that can be switched off.
///
/// The set is deliberately short, and the Live screen will never be in it: the
/// running session is what the app is for, and it stays free and always
/// reachable. Everything that could one day sit behind a purchase goes here.
enum Feature: String, CaseIterable, Identifiable {

    /// Recording drinks for more than one person, and switching between them.
    case multiPerson

    var id: String { rawValue }

    var title: LocalizedStringResource {
        switch self {
        case .multiPerson: "Multiple people"
        }
    }
}

/// The one place that decides what is switched on.
///
/// The views ask, they never decide — `if flags.multiPerson`. That is the
/// entire point: when StoreKit arrives, the entitlement lookup goes into
/// `isPurchased` and no view changes.
///
/// What a flag must **not** gate is the schema. A model behind a flag would
/// need the same migration the moment the flag went on, and would hide
/// existing rows the moment it went off — two shapes of the database to keep
/// alive, for no gain. Migrations run for everyone; the flag hides UI. See
/// 11.5 in CLAUDE.md.
@Observable
@MainActor
final class FeatureFlags {

    static let shared = FeatureFlags()

    private init() {
        #if DEBUG
        overrides = Self.loadOverrides()
        #endif
    }

    // MARK: Asking

    func isEnabled(_ feature: Feature) -> Bool {
        #if DEBUG
        if let override = overrides[feature] { return override }
        #endif
        return isPurchased(feature)
    }

    /// Named accessors, because `flags.multiPerson` reads better at a call
    /// site inside a view body than a lookup does.
    var multiPerson: Bool { isEnabled(.multiPerson) }

    // MARK: Entitlements
    //
    // Always false: nothing has been bought, because nothing can be yet. When
    // StoreKit lands, this is the only method that changes.

    private func isPurchased(_ feature: Feature) -> Bool { false }

    // MARK: Debug overrides
    //
    // Debug builds only. A flag you cannot turn on by hand is a flag nobody
    // tests, but a release build must not carry a switch that hands out paid
    // features.

    #if DEBUG
    private static let storageKey = "drinksmart.featureFlags.debug.v1"

    private var overrides: [Feature: Bool] = [:]

    /// `nil` clears the override and lets the entitlement decide again.
    func setOverride(_ value: Bool?, for feature: Feature) {
        overrides[feature] = value
        persistOverrides()
    }

    func override(for feature: Feature) -> Bool? { overrides[feature] }

    private func persistOverrides() {
        let raw = Dictionary(uniqueKeysWithValues: overrides.map { ($0.key.rawValue, $0.value) })
        UserDefaults.standard.set(raw, forKey: Self.storageKey)
    }

    private static func loadOverrides() -> [Feature: Bool] {
        let raw = UserDefaults.standard.dictionary(forKey: storageKey) as? [String: Bool] ?? [:]
        return raw.reduce(into: [:]) { result, pair in
            guard let feature = Feature(rawValue: pair.key) else { return }
            result[feature] = pair.value
        }
    }
    #endif
}
