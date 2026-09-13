import SwiftUI
import BACKit

struct RootView: View {
    @State private var store = SessionStore()
    @State private var showsAddDrink = false
    @State private var showsProfile = false

    /// Percenként lép — a görbe nem változik tőle, csak a leolvasás pontja.
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

                Spacer()

                if !store.drinks.isEmpty {
                    Button { store.clearSession() } label: {
                        Text("Alkalom lezárása")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(Theme.secondaryText)
                    }
                }
            }
            .padding(.horizontal, 20)

            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(store.unit.formatRange(store.currentRange))
                    .font(.readout(store.drinks.isEmpty ? 64 : 48))
                    .foregroundStyle(Theme.tint(for: store.currentBAC))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .contentTransition(.numericText())
                    .animation(.easeInOut(duration: 0.3), value: store.currentBAC)

                Text(store.unit.suffix)
                    .font(.system(size: 22, weight: .light, design: .rounded))
                    .foregroundStyle(Theme.secondaryText)
            }
            .padding(.horizontal, 20)

            Text(store.drinks.isEmpty ? "becsült szint" : "becsült tartomány")
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundStyle(Theme.secondaryText)
                .textCase(.uppercase)
        }
        .padding(.top, 8)
        .padding(.bottom, 18)
    }

    // MARK: Statisztikák

    private var statRow: some View {
        VStack(spacing: 12) {
            HStack(spacing: 0) {
                stat("Tartam", store.sessionDuration.compactDuration)
                divider
                stat("Italok", "\(store.drinks.count)")
                divider
                stat("Egység", store.totalUnits.formatted(.number.precision(.fractionLength(1))))
            }

            if let sober = store.soberRange {
                Divider().overlay(Theme.hairline).padding(.horizontal, 14)

                VStack(spacing: 3) {
                    Text("Várhatóan ekkorra ürül ki".uppercased())
                        .font(.system(size: 9, weight: .semibold, design: .rounded))
                        .foregroundStyle(Theme.secondaryText)
                    Text(sober.hourMinuteRange)
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

    private func stat(_ title: String, _ value: String) -> some View {
        VStack(spacing: 4) {
            Text(title.uppercased())
                .font(.system(size: 9, weight: .semibold, design: .rounded))
                .foregroundStyle(Theme.secondaryText)
            Text(value)
                .font(.system(size: 15, weight: .medium, design: .rounded).monospacedDigit())
                .foregroundStyle(Theme.primaryText)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: Italok listája

    @ViewBuilder
    private var drinkList: some View {
        if store.drinks.isEmpty {
            emptyState
        } else {
            VStack(alignment: .leading, spacing: 10) {
                Text("Az alkalom italai".uppercased())
                    .font(.sectionLabel)
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
                Text(drink.name ?? "Ital")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Theme.primaryText)
                Text("\(Int(drink.volumeMl)) ml · \(drink.abvPercent.formatted(.number.precision(.fractionLength(1))))% · \(drink.stomach.shortLabel)")
                    .font(.system(size: 11, design: .rounded))
                    .foregroundStyle(Theme.secondaryText)
            }

            Spacer()

            Text(drink.consumedAt.hourMinute)
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
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 26, weight: .light))
                .foregroundStyle(Theme.secondaryText.opacity(0.6))
            Text("Még nincs felvitt ital")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(Theme.primaryText)
            Text("Vidd fel az elsőt, és látni fogod, hogyan alakul a szinted az idő múlásával.")
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
    // Nem apró betű a lap alján: a becslés természete a termék része.

    private var disclaimer: some View {
        VStack(spacing: 6) {
            Text("Ez egy becslés, nem mérés.")
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundStyle(Theme.secondaryText)
            Text("A tényleges érték egyénenként jelentősen eltérhet. Soha ne használd annak eldöntésére, hogy vezethetsz-e — Magyarországon a határ nulla.")
                .font(.system(size: 11, design: .rounded))
                .foregroundStyle(Theme.secondaryText.opacity(0.75))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 10)
    }

    // MARK: Hozzáadás

    private var addButton: some View {
        Button { showsAddDrink = true } label: {
            HStack(spacing: 9) {
                Image(systemName: "plus")
                    .font(.system(size: 15, weight: .bold))
                Text("Ital hozzáadása")
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
