import SwiftUI
import BACKit

struct RootView: View {
    @State private var store = SessionStore()
    @State private var showsAddDrink = false
    @State private var showsProfile = false

    /// Ticks every half minute — this does not change the band, only where
    /// on it we read.
    private let clock = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                hero
                ScrollView {
                    VStack(spacing: 26) {
                        BACChartView(store: store)
                        statRow
                        drinkList
                        disclaimer
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 110)
                }
                .scrollIndicators(.hidden)
            }

            VStack {
                Spacer()
                addButton
            }
        }
        .preferredColorScheme(.dark)
        .onReceive(clock) { _ in store.tick() }
        .sheet(isPresented: $showsAddDrink) { AddDrinkSheet(store: store) }
        .sheet(isPresented: $showsProfile) { ProfileSheet(store: store) }
    }

    // MARK: Hero

    private var hero: some View {
        VStack(spacing: 6) {
            HStack {
                Button { showsProfile = true } label: {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 20))
                        .foregroundStyle(Theme.secondaryText)
                }
                .accessibilityLabel(Text("Profile"))

                Spacer()

                if !store.drinks.isEmpty {
                    Button { store.clearSession() } label: {
                        Text("End session")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(Theme.secondaryText)
                    }
                }
            }
            .padding(.horizontal, 20)

            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(verbatim: store.unit.formatRange(store.currentRange))
                    .font(.readout(store.drinks.isEmpty ? 64 : 48))
                    .foregroundStyle(Theme.tint(for: store.currentBAC))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .contentTransition(.numericText())
                    .animation(.easeInOut(duration: 0.3), value: store.currentBAC)

                Text(verbatim: store.unit.suffix)
                    .font(.system(size: 22, weight: .light, design: .rounded))
                    .foregroundStyle(Theme.secondaryText)
            }
            .padding(.horizontal, 20)

            Group {
                if store.drinks.isEmpty {
                    Text("estimated level")
                } else {
                    Text("estimated range")
                }
            }
            .font(.system(size: 11, weight: .medium, design: .rounded))
            .foregroundStyle(Theme.secondaryText)
            .textCase(.uppercase)
        }
        .padding(.top, 8)
        .padding(.bottom, 18)
    }

    // MARK: Stats

    private var statRow: some View {
        VStack(spacing: 12) {
            HStack(spacing: 0) {
                stat("Elapsed", store.sessionDuration.compactDuration)
                divider
                stat("Drinks", store.drinks.count.formatted())
                divider
                stat("Units", store.totalUnits.formatted(.number.precision(.fractionLength(1))))
            }

            if let sober = store.soberRange {
                Divider().overlay(Theme.hairline).padding(.horizontal, 14)

                VStack(spacing: 3) {
                    Text("Expected to clear")
                        .font(.system(size: 9, weight: .semibold, design: .rounded))
                        .textCase(.uppercase)
                        .foregroundStyle(Theme.secondaryText)
                    Text(verbatim: sober.hourMinuteRange)
                        .font(.system(size: 17, weight: .medium, design: .rounded).monospacedDigit())
                        .foregroundStyle(Theme.primaryText)
                }
            }
        }
        .padding(.vertical, 14)
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 16))
    }

    private var divider: some View {
        Rectangle()
            .fill(Theme.hairline)
            .frame(width: 1, height: 26)
    }

    private func stat(_ title: LocalizedStringKey, _ value: String) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 9, weight: .semibold, design: .rounded))
                .textCase(.uppercase)
                .foregroundStyle(Theme.secondaryText)
            Text(verbatim: value)
                .font(.system(size: 15, weight: .medium, design: .rounded).monospacedDigit())
                .foregroundStyle(Theme.primaryText)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: Drink list

    @ViewBuilder
    private var drinkList: some View {
        if store.drinks.isEmpty {
            emptyState
        } else {
            VStack(alignment: .leading, spacing: 10) {
                Text("Drinks this session")
                    .font(.sectionLabel)
                    .textCase(.uppercase)
                    .foregroundStyle(Theme.secondaryText)

                VStack(spacing: 1) {
                    ForEach(store.drinks.reversed()) { drink in
                        drinkRow(drink)
                    }
                }
                .background(Theme.surface, in: RoundedRectangle(cornerRadius: 16))
            }
        }
    }

    private func drinkRow(_ drink: Drink) -> some View {
        HStack(spacing: 13) {
            Image(systemName: DrinkCatalog.icon(for: drink))
                .font(.system(size: 15))
                .foregroundStyle(Theme.calm)
                .frame(width: 26)

            VStack(alignment: .leading, spacing: 2) {
                Text(DrinkCatalog.name(for: drink))
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Theme.primaryText)

                HStack(spacing: 4) {
                    Text(verbatim: "\(drink.volumeMl.formatted(.number.precision(.fractionLength(0)))) ml")
                    Text(verbatim: "·")
                    Text(verbatim: "\(drink.abvPercent.formatted(.number.precision(.fractionLength(1))))%")
                    Text(verbatim: "·")
                    Text(drink.stomach.shortLabel)
                }
                .font(.system(size: 11, design: .rounded))
                .foregroundStyle(Theme.secondaryText)
            }

            Spacer()

            Text(verbatim: drink.consumedAt.hourMinute)
                .font(.system(size: 13, design: .rounded).monospacedDigit())
                .foregroundStyle(Theme.secondaryText)

            Button {
                withAnimation { store.remove(drink) }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Theme.secondaryText.opacity(0.6))
                    .frame(width: 26, height: 26)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(Text("Remove drink"))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 26, weight: .light))
                .foregroundStyle(Theme.secondaryText.opacity(0.6))
            Text("No drinks logged yet")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(Theme.primaryText)
            Text("Add your first one and you'll see how your level develops over time.")
                .font(.system(size: 12, design: .rounded))
                .foregroundStyle(Theme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 34)
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: Disclaimer
    //
    // Not fine print at the bottom: the nature of the estimate is part of
    // the product.

    private var disclaimer: some View {
        VStack(spacing: 6) {
            Text("This is an estimate, not a measurement.")
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundStyle(Theme.secondaryText)
            Text("Actual values vary considerably between individuals. Never use this to decide whether you can drive.")
                .font(.system(size: 11, design: .rounded))
                .foregroundStyle(Theme.secondaryText.opacity(0.75))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 10)
    }

    // MARK: Add button

    private var addButton: some View {
        Button { showsAddDrink = true } label: {
            HStack(spacing: 9) {
                Image(systemName: "plus")
                    .font(.system(size: 15, weight: .bold))
                Text("Add drink")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
            }
            .foregroundStyle(Theme.background)
            .padding(.horizontal, 26)
            .padding(.vertical, 15)
            .background(Theme.calm, in: Capsule())
            .shadow(color: Theme.background.opacity(0.6), radius: 14, y: 6)
        }
        .buttonStyle(.plain)
        .padding(.bottom, 26)
    }
}

#Preview {
    RootView()
}
