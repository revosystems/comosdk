import SwiftUI
import PhoneNumberKit

@available(iOS 16.0, *)
struct CountryPickerView: View {
    @State private var searchText = ""
    @State private var countries: [CountryCodePickerViewController.Country] = []
    @Binding var selectedCountry: CountryCodePickerViewController.Country?
    
    private let utility: PhoneNumberUtility
    
    init(selectedCountry: Binding<CountryCodePickerViewController.Country?>, utility: PhoneNumberUtility) {
        self._selectedCountry = selectedCountry
        self.utility = utility
    }
    
    var filteredCountries: [CountryCodePickerViewController.Country] {
        let search = searchText.simplified.trim()
        return search.isEmpty ? countries : countries.filter { country in
            country.name.matchesSearch(search) ||
            country.code.matchesSearch(search) ||
            country.prefix.matchesSearch(search)
        }
    }
    
    var groupedCountries: [(String, [CountryCodePickerViewController.Country])] {
        Dictionary(grouping: filteredCountries) { country in
            String(country.name.prefix(1)).uppercased()
        }.sorted { $0.key < $1.key }
    }
    
    var sectionHeaders: [String] {
        groupedCountries.map { $0.0 }.sorted()
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(groupedCountries, id: \.0) { section in
                    Section(header: Text(section.0)
                        .font(.caption)
                        .foregroundColor(.gray)) {
                            ForEach(section.1, id: \.code) { country in
                                CountryRowView(
                                    country: country,
                                    isSelected: selectedCountry?.code == country.code
                                )
                                .onTapGesture { selectedCountry = country }
                            }
                        }
                }
            }
            .searchable(text: $searchText, placement: .automatic, prompt: Como.trans("search"))
            .listStyle(PlainListStyle())
        }
        .onAppear {
            loadCountries()
        }
    }
    
    private func loadCountries() {
        countries = utility
            .allCountries()
            .compactMap { CountryCodePickerViewController.Country(for: $0, with: utility, translated: true) }
            .sorted { $0.name < $1.name }
    }
}

struct CountryRowView: View {
    let country: CountryCodePickerViewController.Country
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Text(country.prefix)
                .font(.caption)
                .foregroundColor(.primary)
                .fontWeight(.light)
                .frame(width: 50, alignment: .trailing)
            
            Text(country.flag)
                .font(.title2)
                .frame(width: 30, alignment: .center)
            
            Text(country.name)
                .font(.body)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if isSelected {
                Image(systemName: "checkmark")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 16)
        .contentShape(Rectangle())
    }
}

extension CountryCodePickerViewController.Country {
    init?(for countryCode: String, with utility: PhoneNumberUtility, translated: Bool) {
        self.init(for: countryCode, with: utility)
        if translated, case let locale = Locale(identifier: Como.language) as NSLocale,
            let translatedName = locale.localizedString(forCountryCode: countryCode) as? String {
            self.name = translatedName
        }
    }
}

extension String {
    var simplified: String {
        folding(options: [.diacriticInsensitive, .widthInsensitive, .caseInsensitive], locale: nil)
    }
    
    func matchesSearch(_ searchText: String) -> Bool {
        simplified.contains(searchText)
    }
}

#Preview {
    let utility = PhoneNumberUtility()
    if #available(iOS 16.0, *) {
        CountryPickerView(
            selectedCountry: .constant(CountryCodePickerViewController.Country(for: "AD", with: utility, translated: true)),
            utility: utility
        )
    }
}
