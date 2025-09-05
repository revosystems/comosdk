import SwiftUI
import PhoneNumberKit

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
        searchText.isEmpty ? countries : countries.filter { country in
            country.name.localizedCaseInsensitiveContains(searchText) ||
            country.code.localizedCaseInsensitiveContains(searchText) ||
            country.prefix.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var groupedCountries: [(String, [CountryCodePickerViewController.Country])] {
        let grouped = Dictionary(grouping: filteredCountries) { country in
            String(country.name.prefix(1)).uppercased()
        }
        return grouped.sorted { $0.key < $1.key }
    }
    
    var sectionHeaders: [String] {
        groupedCountries.map { $0.0 }.sorted()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Always visible search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search Country Codes", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            // Countries list with sections
            List {
                ForEach(groupedCountries, id: \.0) { section in
                    Section(header: Text(section.0)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .textCase(nil)) {
                            ForEach(section.1, id: \.code) { country in
                                CountryRowView(
                                    country: country,
                                    isSelected: selectedCountry?.code == country.code
                                ) {
                                    selectedCountry = country
                                }
                            }
                        }
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Choose your country")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadCountries()
        }
    }
    
    private func loadCountries() {
        countries = utility
            .allCountries()
            .compactMap { CountryCodePickerViewController.Country(for: $0, with: utility) }
            .sorted { $0.name < $1.name }
    }
}

struct CountryRowView: View {
    let country: CountryCodePickerViewController.Country
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 0) {
                // Phone prefix - fixed width for alignment
                Text(country.prefix)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .fontWeight(.light)
                    .frame(width: 50, alignment: .trailing)
                
                // Flag - fixed width for alignment
                Text(country.flag)
                    .font(.title2)
                    .frame(width: 30, alignment: .center)
                
                // Country name - takes remaining space
                Text(country.name)
                    .font(.body)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Selection indicator
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.body)
                        .foregroundColor(.blue)
                }
                
                Spacer()
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}


#Preview {
    let utility = PhoneNumberUtility()
    CountryPickerView(
        selectedCountry: .constant(CountryCodePickerViewController.Country(for: "AD", with: utility)),
        utility: utility
    )
}
