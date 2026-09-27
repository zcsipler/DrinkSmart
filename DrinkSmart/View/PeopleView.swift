import SwiftUI

/// Everyone the app records, on one screen — and the one place to remove
/// someone.
///
/// Reached from the Profile tab. Removing lives here, in a list, and not in
/// the switcher menu: that menu is on all three tabs, opened in a bar with a
/// thumb, and a destructive item next to the names is how someone's year
/// disappears by accident. A list you have to navigate to, with a swipe or
/// Edit mode, is the same distance as deleting a contact — and it scales:
/// three guests are three rows, not three buttons at the bottom of Profile.
///
/// The owner is the first row and cannot be removed: the app is built around
/// there being one (`Person`), and a swipe that always refuses would be worse
/// than no swipe. Tapping a row switches to that person, the way the menu
/// does, so the list is also a switcher with more room.
///
/// The confirmation states what goes — occasions, drinks, monthly totals —
/// because "Remove Nada?" on its own asks the user to accept consequences
/// nobody has shown them, and there is no undo.
struct PeopleView: View {
    let store: SessionStore

    @State private var plan: SessionStore.RemovalPlan?
    @State private var showsAddPerson = false

    var body: some View {
        List {
            Section {
                ForEach(store.people) { person in
                    row(person)
                }
                .onDelete(perform: requestRemoval)
            } footer: {
                Text("Swipe left on a guest to remove them with everything recorded under them. You cannot be removed.")
            }
            .listRowBackground(Theme.surface)

            Section {
                Button {
                    showsAddPerson = true
                } label: {
                    Label { Text("Add person") } icon: { Image(systemName: "person.badge.plus") }
                }
            }
            .listRowBackground(Theme.surface)
            .tint(Theme.calm)
        }
        .scrollContentBackground(.hidden)
        .background(Theme.background)
        .navigationTitle(Text("People"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) { EditButton() }
        }
        .sheet(isPresented: $showsAddPerson) {
            AddPersonSheet(store: store)
        }
        .confirmationDialog(
            Text("Remove \(removingName)?"),
            isPresented: presenting($plan),
            titleVisibility: .visible,
            presenting: plan
        ) { plan in
            Button(role: .destructive) {
                store.removePerson(plan.person)
            } label: {
                Text("Remove")
            }
            Button(role: .cancel) {} label: { Text("Cancel") }
        } message: { plan in
            if plan.monthlyTotals > 0 {
                Text("Deletes \(count(plan.sessions)) occasions, \(count(plan.drinks)) drinks and \(count(plan.monthlyTotals)) monthly totals. This cannot be undone.")
            } else {
                Text("Deletes \(count(plan.sessions)) occasions and \(count(plan.drinks)) drinks. This cannot be undone.")
            }
        }
    }

    // MARK: Rows

    private func row(_ person: Person) -> some View {
        Button {
            store.activate(person)
        } label: {
            HStack(spacing: 12) {
                Text(verbatim: person.monogram)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.background)
                    .frame(width: 30, height: 30)
                    .background(Theme.accent(for: person.accent), in: Circle())

                VStack(alignment: .leading, spacing: 2) {
                    if let name = person.displayName {
                        Text(verbatim: name)
                            .foregroundStyle(Theme.primaryText)
                    } else {
                        Text("You")
                            .foregroundStyle(Theme.primaryText)
                    }
                    if person.isOwner {
                        Text("Owner")
                            .font(.footnote)
                            .foregroundStyle(Theme.secondaryText)
                    }
                }

                Spacer()

                if person.id == store.person.id {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Theme.calm)
                }
            }
        }
        // The owner's row does not offer the swipe at all, rather than
        // offering one that refuses: `deleteDisabled` also keeps the minus
        // out of Edit mode for that row.
        .deleteDisabled(person.isOwner)
    }

    /// The swipe (or Edit-mode minus) does not delete — it asks. `onDelete`
    /// hands over offsets into `store.people`, the same order the rows use.
    private func requestRemoval(at offsets: IndexSet) {
        let people = store.people
        guard let index = offsets.first, people.indices.contains(index) else { return }
        plan = store.removalPlan(for: people[index])
    }

    // MARK: Helpers

    /// Kept out of the string literal: a quote inside an interpolation trips
    /// the catalog checker's scan of the source.
    private var removingName: String { plan?.person.displayName ?? "" }

    private func presenting<T>(_ value: Binding<T?>) -> Binding<Bool> {
        Binding(
            get: { value.wrappedValue != nil },
            set: { if !$0 { value.wrappedValue = nil } }
        )
    }

    private func count(_ value: Int) -> String {
        value.formatted(.number)
    }
}

/// The Profile tab's way in: one row, with how many people there are.
struct PeopleSection: View {
    let store: SessionStore

    var body: some View {
        Section {
            NavigationLink {
                PeopleView(store: store)
            } label: {
                HStack {
                    Label { Text("People") } icon: { Image(systemName: "person.2") }
                    Spacer()
                    Text(verbatim: store.people.count.formatted(.number))
                        .foregroundStyle(Theme.secondaryText)
                }
            }
        } footer: {
            Text("Everyone this app records. Switch, add, or remove someone.")
        }
        .listRowBackground(Theme.surface)
        .tint(Theme.calm)
    }
}

#Preview {
    NavigationStack {
        PeopleView(store: .preview)
    }
    .preferredColorScheme(.dark)
}
