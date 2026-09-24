import SwiftUI

/// Jump straight to a page of history, instead of paging there a step at a
/// time — "what did September look like three years ago" should be three
/// taps, not thirty-six.
///
/// Opened from the window title, the way the Calendar app's title opens a
/// picker. The chevrons stay for the next page over; this is for the far
/// ones. What the sheet offers depends on the range: a calendar for the week
/// and day views (the page holding the day you pick), a grid of months for the month
/// view, a list of years for the year view. Nothing before records began and
/// nothing after today is offered — there is no page there to land on.
struct HistoryJumpSheet: View {
    let range: HistoryRange
    /// A day inside the page currently on screen.
    let current: Date
    let recordsBegan: Date
    let now: Date
    let onPick: (Date) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var picked: Date
    @State private var year: Int

    private let calendar = Calendar.current

    init(range: HistoryRange, current: Date, recordsBegan: Date, now: Date, onPick: @escaping (Date) -> Void) {
        self.range = range
        self.current = current
        self.recordsBegan = recordsBegan
        self.now = now
        self.onPick = onPick
        _picked = State(initialValue: current)
        _year = State(initialValue: Calendar.current.component(.year, from: current))
    }

    private var firstYear: Int { calendar.component(.year, from: min(recordsBegan, now)) }
    private var lastYear: Int { calendar.component(.year, from: now) }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                switch range {
                case .day, .week: weekPicker
                case .month: monthPicker
                case .year: yearPicker
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button { dismiss() } label: { Text("Cancel") }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button { choose(now) } label: { Text("Today") }
                }
            }
            .tint(Theme.calm)
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    private func choose(_ date: Date) {
        onPick(date)
        dismiss()
    }

    // MARK: Week — a calendar

    /// Picking a day closes the sheet; on a calendar the tap *is* the choice.
    private var weekPicker: some View {
        DatePicker(
            selection: $picked,
            in: min(recordsBegan, now)...now,
            displayedComponents: .date
        ) {
            Text(range.title)
        }
        .datePickerStyle(.graphical)
        .labelsHidden()
        .padding(.horizontal, 12)
        // The picker may nudge its own selection into range on appear; only
        // a day the user actually moved to counts as a choice.
        .onChange(of: picked) { _, date in
            guard !calendar.isDate(date, inSameDayAs: current) else { return }
            choose(date)
        }
    }

    // MARK: Month — a year and its twelve months

    private var monthPicker: some View {
        VStack(spacing: 18) {
            yearStepper

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                ForEach(1...12, id: \.self) { month in
                    let start = calendar.date(from: DateComponents(year: year, month: month, day: 1)) ?? now
                    let enabled = isOffered(start, unit: .month)
                    let isCurrent = calendar.isDate(start, equalTo: current, toGranularity: .month)
                    Button { choose(start) } label: {
                        Text(verbatim: calendar.shortMonthSymbols[month - 1])
                            .font(.system(size: 15, weight: isCurrent ? .semibold : .regular, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                isCurrent ? Theme.calm.opacity(0.18) : Theme.surface,
                                in: RoundedRectangle(cornerRadius: 10)
                            )
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(enabled ? Theme.primaryText : Theme.secondaryText.opacity(0.35))
                    .disabled(!enabled)
                }
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        .padding(.top, 16)
    }

    private var yearStepper: some View {
        HStack {
            stepButton("chevron.left", enabled: year > firstYear) { year -= 1 }
            Spacer()
            Text(verbatim: String(year))
                .font(.system(size: 17, weight: .semibold, design: .rounded).monospacedDigit())
                .foregroundStyle(Theme.primaryText)
            Spacer()
            stepButton("chevron.right", enabled: year < lastYear) { year += 1 }
        }
        .padding(.horizontal, 20)
    }

    private func stepButton(_ systemName: String, enabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 13, weight: .semibold))
                .frame(width: 34, height: 30)
                .background(Theme.surface, in: RoundedRectangle(cornerRadius: 9))
        }
        .buttonStyle(.plain)
        .foregroundStyle(enabled ? Theme.primaryText : Theme.secondaryText.opacity(0.35))
        .disabled(!enabled)
    }

    // MARK: Year — a list

    private var yearPicker: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(Array(stride(from: lastYear, through: firstYear, by: -1)), id: \.self) { candidate in
                    let start = calendar.date(from: DateComponents(year: candidate, month: 1, day: 1)) ?? now
                    let isCurrent = calendar.component(.year, from: current) == candidate
                    Button { choose(start) } label: {
                        Text(verbatim: String(candidate))
                            .font(.system(size: 16, weight: isCurrent ? .semibold : .regular, design: .rounded).monospacedDigit())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(
                                isCurrent ? Theme.calm.opacity(0.18) : Theme.surface,
                                in: RoundedRectangle(cornerRadius: 12)
                            )
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(Theme.primaryText)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }

    // MARK: Helpers

    /// Whether the calendar unit starting at `start` overlaps the recorded
    /// span at all — a month with one recorded day at its end is still a page.
    private func isOffered(_ start: Date, unit: Calendar.Component) -> Bool {
        guard let interval = calendar.dateInterval(of: unit, for: start) else { return false }
        return interval.end > min(recordsBegan, now) && interval.start <= now
    }
}
