import Foundation

struct PhoneCountry {
    let flag:String
    let name:String
    let prefix:String
}

enum PhoneCountryEnum: CaseIterable {
    case afghanistan, albania, algeria, andorra, angola, antiguaAndBarbuda, argentina, armenia, australia, austria, azerbaijan
    case bahamas, bahrain, bangladesh, barbados, belarus, belgium, belize, benin, bhutan, bolivia, bosniaAndHerzegovina, botswana, brazil, brunei, bulgaria, burkinaFaso, burundi
    case cambodia, cameroon, canada, capeVerde, centralAfricanRepublic, chad, chile, china, colombia, comoros, congoBrazzaville, congoKinshasa, costaRica, croatia, cuba, cyprus, czechia
    case denmark, djibouti, dominica, dominicanRepublic
    case eastTimor, ecuador, egypt, elSalvador, equatorialGuinea, eritrea, estonia, eswatini, ethiopia
    case fiji, finland, france
    case gabon, gambia, georgia, germany, ghana, greece, grenada, guatemala, guinea, guineaBissau, guyana
    case haiti, honduras, hungary
    case iceland, india, indonesia, iran, iraq, ireland, israel, italy
    case jamaica, japan, jordan
    case kazakhstan, kenya, kiribati, koreaNorth, koreaSouth, kosovo, kuwait, kyrgyzstan
    case laos, latvia, lebanon, lesotho, liberia, libya, liechtenstein, lithuania, luxembourg
    case madagascar, malawi, malaysia, maldives, mali, malta, marshallIslands, mauritania, mauritius, mexico, micronesia, moldova, monaco, mongolia, montenegro, morocco, mozambique, myanmar
    case namibia, nauru, nepal, netherlands, newZealand, nicaragua, niger, nigeria, northMacedonia, norway
    case oman
    case pakistan, palau, palestine, panama, papuaNewGuinea, paraguay, peru, philippines, poland, portugal
    case qatar
    case romania, russia, rwanda
    case saintKittsAndNevis, saintLucia, saintVincentAndTheGrenadines, samoa, sanMarino, saoTomeAndPrincipe, saudiArabia, senegal, serbia, seychelles, sierraLeone, singapore, slovakia, slovenia, solomonIslands, somalia, southAfrica, southSudan, spain, sriLanka, sudan, suriname, sweden, switzerland, syria
    case taiwan, tajikistan, tanzania, thailand, timorLeste, togo, tonga, trinidadAndTobago, tunisia, turkey, turkmenistan, tuvalu
    case uganda, ukraine, unitedArabEmirates, unitedKingdom, unitedStates, uruguay, uzbekistan
    case vanuatu, vaticanCity, venezuela, vietnam
    case yemen
    case zambia, zimbabwe


    var country: PhoneCountry {
        switch self {
        case .afghanistan:                  PhoneCountry(flag: "🇦🇫", name: "Afghanistan", prefix: "+93")
        case .albania:                      PhoneCountry(flag: "🇦🇱", name: "Albania", prefix: "+355")
        case .algeria:                      PhoneCountry(flag: "🇩🇿", name: "Algeria", prefix: "+213")
        case .andorra:                      PhoneCountry(flag: "🇦🇩", name: "Andorra", prefix: "+376")
        case .angola:                       PhoneCountry(flag: "🇦🇴", name: "Angola", prefix: "+244")
        case .antiguaAndBarbuda:            PhoneCountry(flag: "🇦🇬", name: "Antigua and Barbuda", prefix: "+1-268")
        case .argentina:                    PhoneCountry(flag: "🇦🇷", name: "Argentina", prefix: "+54")
        case .armenia:                      PhoneCountry(flag: "🇦🇲", name: "Armenia", prefix: "+374")
        case .australia:                    PhoneCountry(flag: "🇦🇺", name: "Australia", prefix: "+61")
        case .austria:                      PhoneCountry(flag: "🇦🇹", name: "Austria", prefix: "+43")
        case .azerbaijan:                   PhoneCountry(flag: "🇦🇿", name: "Azerbaijan", prefix: "+994")
                    
        case .bahamas:                      PhoneCountry(flag: "🇧🇸", name: "Bahamas", prefix: "+1-242")
        case .bahrain:                      PhoneCountry(flag: "🇧🇭", name: "Bahrain", prefix: "+973")
        case .bangladesh:                   PhoneCountry(flag: "🇧🇩", name: "Bangladesh", prefix: "+880")
        case .barbados:                     PhoneCountry(flag: "🇧🇧", name: "Barbados", prefix: "+1-246")
        case .belarus:                      PhoneCountry(flag: "🇧🇾", name: "Belarus", prefix: "+375")
        case .belgium:                      PhoneCountry(flag: "🇧🇪", name: "Belgium", prefix: "+32")
        case .belize:                       PhoneCountry(flag: "🇧🇿", name: "Belize", prefix: "+501")
        case .benin:                        PhoneCountry(flag: "🇧🇯", name: "Benin", prefix: "+229")
        case .bhutan:                       PhoneCountry(flag: "🇧🇹", name: "Bhutan", prefix: "+975")
        case .bolivia:                      PhoneCountry(flag: "🇧🇴", name: "Bolivia", prefix: "+591")
        case .bosniaAndHerzegovina:         PhoneCountry(flag: "🇧🇦", name: "Bosnia and Herzegovina", prefix: "+387")
        case .botswana:                     PhoneCountry(flag: "🇧🇼", name: "Botswana", prefix: "+267")
        case .brazil:                       PhoneCountry(flag: "🇧🇷", name: "Brazil", prefix: "+55")
        case .brunei:                       PhoneCountry(flag: "🇧🇳", name: "Brunei", prefix: "+673")
        case .bulgaria:                     PhoneCountry(flag: "🇧🇬", name: "Bulgaria", prefix: "+359")
        case .burkinaFaso:                  PhoneCountry(flag: "🇧🇫", name: "Burkina Faso", prefix: "+226")
        case .burundi:                      PhoneCountry(flag: "🇧🇮", name: "Burundi", prefix: "+257")
                    
        case .cambodia:                     PhoneCountry(flag: "🇰🇭", name: "Cambodia", prefix: "+855")
        case .cameroon:                     PhoneCountry(flag: "🇨🇲", name: "Cameroon", prefix: "+237")
        case .canada:                       PhoneCountry(flag: "🇨🇦", name: "Canada", prefix: "+1")
        case .capeVerde:                    PhoneCountry(flag: "🇨🇻", name: "Cape Verde", prefix: "+238")
        case .centralAfricanRepublic:       PhoneCountry(flag: "🇨🇫", name: "Central African Republic", prefix: "+236")
        case .chad:                         PhoneCountry(flag: "🇹🇩", name: "Chad", prefix: "+235")
        case .chile:                        PhoneCountry(flag: "🇨🇱", name: "Chile", prefix: "+56")
        case .china:                        PhoneCountry(flag: "🇨🇳", name: "China", prefix: "+86")
        case .colombia:                     PhoneCountry(flag: "🇨🇴", name: "Colombia", prefix: "+57")
        case .comoros:                      PhoneCountry(flag: "🇰🇲", name: "Comoros", prefix: "+269")
        case .congoBrazzaville:             PhoneCountry(flag: "🇨🇬", name: "Congo (Brazzaville)", prefix: "+242")
        case .congoKinshasa:                PhoneCountry(flag: "🇨🇩", name: "Congo (Kinshasa)", prefix: "+243")
        case .costaRica:                    PhoneCountry(flag: "🇨🇷", name: "Costa Rica", prefix: "+506")
        case .croatia:                      PhoneCountry(flag: "🇭🇷", name: "Croatia", prefix: "+385")
        case .cuba:                         PhoneCountry(flag: "🇨🇺", name: "Cuba", prefix: "+53")
        case .cyprus:                       PhoneCountry(flag: "🇨🇾", name: "Cyprus", prefix: "+357")
        case .czechia:                      PhoneCountry(flag: "🇨🇿", name: "Czechia", prefix: "+420")
                    
        case .denmark:                      PhoneCountry(flag: "🇩🇰", name: "Denmark", prefix: "+45")
        case .djibouti:                     PhoneCountry(flag: "🇩🇯", name: "Djibouti", prefix: "+253")
        case .dominica:                     PhoneCountry(flag: "🇩🇲", name: "Dominica", prefix: "+1-767")
        case .dominicanRepublic:            PhoneCountry(flag: "🇩🇴", name: "Dominican Republic", prefix: "+1-809")
                    
        case .eastTimor:                    PhoneCountry(flag: "🇹🇱", name: "East Timor", prefix: "+670")
        case .ecuador:                      PhoneCountry(flag: "🇪🇨", name: "Ecuador", prefix: "+593")
        case .egypt:                        PhoneCountry(flag: "🇪🇬", name: "Egypt", prefix: "+20")
        case .elSalvador:                   PhoneCountry(flag: "🇸🇻", name: "El Salvador", prefix: "+503")
        case .equatorialGuinea:             PhoneCountry(flag: "🇬🇶", name: "Equatorial Guinea", prefix: "+240")
        case .eritrea:                      PhoneCountry(flag: "🇪🇷", name: "Eritrea", prefix: "+291")
        case .estonia:                      PhoneCountry(flag: "🇪🇪", name: "Estonia", prefix: "+372")
        case .eswatini:                     PhoneCountry(flag: "🇸🇿", name: "Eswatini", prefix: "+268")
        case .ethiopia:                     PhoneCountry(flag: "🇪🇹", name: "Ethiopia", prefix: "+251")
                    
        case .fiji:                         PhoneCountry(flag: "🇫🇯", name: "Fiji", prefix: "+679")
        case .finland:                      PhoneCountry(flag: "🇫🇮", name: "Finland", prefix: "+358")
        case .france:                       PhoneCountry(flag: "🇫🇷", name: "France", prefix: "+33")
        case .gabon:                        PhoneCountry(flag: "🇬🇦", name: "Gabon", prefix: "+241")
        case .gambia:                       PhoneCountry(flag: "🇬🇲", name: "Gambia", prefix: "+220")
        case .georgia:                      PhoneCountry(flag: "🇬🇪", name: "Georgia", prefix: "+995")
        case .germany:                      PhoneCountry(flag: "🇩🇪", name: "Germany", prefix: "+49")
        case .ghana:                        PhoneCountry(flag: "🇬🇭", name: "Ghana", prefix: "+233")
        case .greece:                       PhoneCountry(flag: "🇬🇷", name: "Greece", prefix: "+30")
        case .grenada:                      PhoneCountry(flag: "🇬🇩", name: "Grenada", prefix: "+1-473")
        case .guatemala:                    PhoneCountry(flag: "🇬🇹", name: "Guatemala", prefix: "+502")
        case .guinea:                       PhoneCountry(flag: "🇬🇳", name: "Guinea", prefix: "+224")
        case .guineaBissau:                 PhoneCountry(flag: "🇬🇼", name: "Guinea-Bissau", prefix: "+245")
        case .guyana:                       PhoneCountry(flag: "🇬🇾", name: "Guyana", prefix: "+592")
                
        case .haiti:                        PhoneCountry(flag: "🇭🇹", name: "Haiti", prefix: "+509")
        case .honduras:                     PhoneCountry(flag: "🇭🇳", name: "Honduras", prefix: "+504")
        case .hungary:                      PhoneCountry(flag: "🇭🇺", name: "Hungary", prefix: "+36")
                
        case .iceland:                      PhoneCountry(flag: "🇮🇸", name: "Iceland", prefix: "+354")
        case .india:                        PhoneCountry(flag: "🇮🇳", name: "India", prefix: "+91")
        case .indonesia:                    PhoneCountry(flag: "🇮🇩", name: "Indonesia", prefix: "+62")
        case .iran:                         PhoneCountry(flag: "🇮🇷", name: "Iran", prefix: "+98")
        case .iraq:                         PhoneCountry(flag: "🇮🇶", name: "Iraq", prefix: "+964")
        case .ireland:                      PhoneCountry(flag: "🇮🇪", name: "Ireland", prefix: "+353")
        case .israel:                       PhoneCountry(flag: "🇮🇱", name: "Israel", prefix: "+972")
        case .italy:                        PhoneCountry(flag: "🇮🇹", name: "Italy", prefix: "+39")
                
        case .jamaica:                      PhoneCountry(flag: "🇯🇲", name: "Jamaica", prefix: "+1-876")
        case .japan:                        PhoneCountry(flag: "🇯🇵", name: "Japan", prefix: "+81")
        case .jordan:                       PhoneCountry(flag: "🇯🇴", name: "Jordan", prefix: "+962")
                
        case .kazakhstan:                   PhoneCountry(flag: "🇰🇿", name: "Kazakhstan", prefix: "+7")
        case .kenya:                        PhoneCountry(flag: "🇰🇪", name: "Kenya", prefix: "+254")
        case .kiribati:                     PhoneCountry(flag: "🇰🇮", name: "Kiribati", prefix: "+686")
        case .koreaNorth:                   PhoneCountry(flag: "🇰🇵", name: "North Korea", prefix: "+850")
        case .koreaSouth:                   PhoneCountry(flag: "🇰🇷", name: "South Korea", prefix: "+82")
        case .kosovo:                       PhoneCountry(flag: "🇽🇰", name: "Kosovo", prefix: "+383")
        case .kuwait:                       PhoneCountry(flag: "🇰🇼", name: "Kuwait", prefix: "+965")
        case .kyrgyzstan:                   PhoneCountry(flag: "🇰🇬", name: "Kyrgyzstan", prefix: "+996")
                
        case .laos:                         PhoneCountry(flag: "🇱🇦", name: "Laos", prefix: "+856")
        case .latvia:                       PhoneCountry(flag: "🇱🇻", name: "Latvia", prefix: "+371")
        case .lebanon:                      PhoneCountry(flag: "🇱🇧", name: "Lebanon", prefix: "+961")
        case .lesotho:                      PhoneCountry(flag: "🇱🇸", name: "Lesotho", prefix: "+266")
        case .liberia:                      PhoneCountry(flag: "🇱🇷", name: "Liberia", prefix: "+231")
        case .libya:                        PhoneCountry(flag: "🇱🇾", name: "Libya", prefix: "+218")
        case .liechtenstein:                PhoneCountry(flag: "🇱🇮", name: "Liechtenstein", prefix: "+423")
        case .lithuania:                    PhoneCountry(flag: "🇱🇹", name: "Lithuania", prefix: "+370")
        case .luxembourg:                   PhoneCountry(flag: "🇱🇺", name: "Luxembourg", prefix: "+352")

        case .madagascar:                   PhoneCountry(flag: "🇲🇬", name: "Madagascar", prefix: "+261")
        case .malawi:                       PhoneCountry(flag: "🇲🇼", name: "Malawi", prefix: "+265")
        case .malaysia:                     PhoneCountry(flag: "🇲🇾", name: "Malaysia", prefix: "+60")
        case .maldives:                     PhoneCountry(flag: "🇲🇻", name: "Maldives", prefix: "+960")
        case .mali:                         PhoneCountry(flag: "🇲🇱", name: "Mali", prefix: "+223")
        case .malta:                        PhoneCountry(flag: "🇲🇹", name: "Malta", prefix: "+356")
        case .marshallIslands:              PhoneCountry(flag: "🇲🇭", name: "Marshall Islands", prefix: "+692")
        case .mauritania:                   PhoneCountry(flag: "🇲🇷", name: "Mauritania", prefix: "+222")
        case .mauritius:                    PhoneCountry(flag: "🇲🇺", name: "Mauritius", prefix: "+230")
        case .mexico:                       PhoneCountry(flag: "🇲🇽", name: "Mexico", prefix: "+52")
        case .micronesia:                   PhoneCountry(flag: "🇫🇲", name: "Micronesia", prefix: "+691")
        case .moldova:                      PhoneCountry(flag: "🇲🇩", name: "Moldova", prefix: "+373")
        case .monaco:                       PhoneCountry(flag: "🇲🇨", name: "Monaco", prefix: "+377")
        case .mongolia:                     PhoneCountry(flag: "🇲🇳", name: "Mongolia", prefix: "+976")
        case .montenegro:                   PhoneCountry(flag: "🇲🇪", name: "Montenegro", prefix: "+382")
        case .morocco:                      PhoneCountry(flag: "🇲🇦", name: "Morocco", prefix: "+212")
        case .mozambique:                   PhoneCountry(flag: "🇲🇿", name: "Mozambique", prefix: "+258")
        case .myanmar:                      PhoneCountry(flag: "🇲🇲", name: "Myanmar", prefix: "+95")
            
        case .namibia:                      PhoneCountry(flag: "🇳🇦", name: "Namibia", prefix: "+264")
        case .nauru:                        PhoneCountry(flag: "🇳🇷", name: "Nauru", prefix: "+674")
        case .nepal:                        PhoneCountry(flag: "🇳🇵", name: "Nepal", prefix: "+977")
        case .netherlands:                  PhoneCountry(flag: "🇳🇱", name: "Netherlands", prefix: "+31")
        case .newZealand:                   PhoneCountry(flag: "🇳🇿", name: "New Zealand", prefix: "+64")
        case .nicaragua:                    PhoneCountry(flag: "🇳🇮", name: "Nicaragua", prefix: "+505")
        case .niger:                        PhoneCountry(flag: "🇳🇪", name: "Niger", prefix: "+227")
        case .nigeria:                      PhoneCountry(flag: "🇳🇬", name: "Nigeria", prefix: "+234")
        case .northMacedonia:               PhoneCountry(flag: "🇲🇰", name: "North Macedonia", prefix: "+389")
        case .norway:                       PhoneCountry(flag: "🇳🇴", name: "Norway", prefix: "+47")
            
        case .oman:                         PhoneCountry(flag: "🇴🇲", name: "Oman", prefix: "+968")
            
        case .pakistan:                     PhoneCountry(flag: "🇵🇰", name: "Pakistan", prefix: "+92")
        case .palau:                        PhoneCountry(flag: "🇵🇼", name: "Palau", prefix: "+680")
        case .palestine:                    PhoneCountry(flag: "🇵🇸", name: "Palestine", prefix: "+970")
        case .panama:                       PhoneCountry(flag: "🇵🇦", name: "Panama", prefix: "+507")
        case .papuaNewGuinea:               PhoneCountry(flag: "🇵🇬", name: "Papua New Guinea", prefix: "+675")
        case .paraguay:                     PhoneCountry(flag: "🇵🇾", name: "Paraguay", prefix: "+595")
        case .peru:                         PhoneCountry(flag: "🇵🇪", name: "Peru", prefix: "+51")
        case .philippines:                  PhoneCountry(flag: "🇵🇭", name: "Philippines", prefix: "+63")
        case .poland:                       PhoneCountry(flag: "🇵🇱", name: "Poland", prefix: "+48")
        case .portugal:                     PhoneCountry(flag: "🇵🇹", name: "Portugal", prefix: "+351")
            
        case .qatar:                        PhoneCountry(flag: "🇶🇦", name: "Qatar", prefix: "+974")
            
        case .romania:                      PhoneCountry(flag: "🇷🇴", name: "Romania", prefix: "+40")
        case .russia:                       PhoneCountry(flag: "🇷🇺", name: "Russia", prefix: "+7")
        case .rwanda:                       PhoneCountry(flag: "🇷🇼", name: "Rwanda", prefix: "+250")

        case .saintKittsAndNevis:           PhoneCountry(flag: "🇰🇳", name: "Saint Kitts and Nevis", prefix: "+1-869")
        case .saintLucia:                   PhoneCountry(flag: "🇱🇨", name: "Saint Lucia", prefix: "+1-758")
        case .saintVincentAndTheGrenadines: PhoneCountry(flag: "🇻🇨", name: "Saint Vincent and the Grenadines", prefix: "+1-784")
        case .samoa:                        PhoneCountry(flag: "🇼🇸", name: "Samoa", prefix: "+685")
        case .sanMarino:                    PhoneCountry(flag: "🇸🇲", name: "San Marino", prefix: "+378")
        case .saoTomeAndPrincipe:           PhoneCountry(flag: "🇸🇹", name: "São Tomé and Príncipe", prefix: "+239")
        case .saudiArabia:                  PhoneCountry(flag: "🇸🇦", name: "Saudi Arabia", prefix: "+966")
        case .senegal:                      PhoneCountry(flag: "🇸🇳", name: "Senegal", prefix: "+221")
        case .serbia:                       PhoneCountry(flag: "🇷🇸", name: "Serbia", prefix: "+381")
        case .seychelles:                   PhoneCountry(flag: "🇸🇨", name: "Seychelles", prefix: "+248")
        case .sierraLeone:                  PhoneCountry(flag: "🇸🇱", name: "Sierra Leone", prefix: "+232")
        case .singapore:                    PhoneCountry(flag: "🇸🇬", name: "Singapore", prefix: "+65")
        case .slovakia:                     PhoneCountry(flag: "🇸🇰", name: "Slovakia", prefix: "+421")
        case .slovenia:                     PhoneCountry(flag: "🇸🇮", name: "Slovenia", prefix: "+386")
        case .solomonIslands:               PhoneCountry(flag: "🇸🇧", name: "Solomon Islands", prefix: "+677")
        case .somalia:                      PhoneCountry(flag: "🇸🇴", name: "Somalia", prefix: "+252")
        case .southAfrica:                  PhoneCountry(flag: "🇿🇦", name: "South Africa", prefix: "+27")
        case .southSudan:                   PhoneCountry(flag: "🇸🇸", name: "South Sudan", prefix: "+211")
        case .spain:                        PhoneCountry(flag: "🇪🇸", name: "Spain", prefix: "+34")
        case .sriLanka:                     PhoneCountry(flag: "🇱🇰", name: "Sri Lanka", prefix: "+94")
        case .sudan:                        PhoneCountry(flag: "🇸🇩", name: "Sudan", prefix: "+249")
        case .suriname:                     PhoneCountry(flag: "🇸🇷", name: "Suriname", prefix: "+597")
        case .sweden:                       PhoneCountry(flag: "🇸🇪", name: "Sweden", prefix: "+46")
        case .switzerland:                  PhoneCountry(flag: "🇨🇭", name: "Switzerland", prefix: "+41")
        case .syria:                        PhoneCountry(flag: "🇸🇾", name: "Syria", prefix: "+963")

        case .taiwan:                       PhoneCountry(flag: "🇹🇼", name: "Taiwan", prefix: "+886")
        case .tajikistan:                   PhoneCountry(flag: "🇹🇯", name: "Tajikistan", prefix: "+992")
        case .tanzania:                     PhoneCountry(flag: "🇹🇿", name: "Tanzania", prefix: "+255")
        case .thailand:                     PhoneCountry(flag: "🇹🇭", name: "Thailand", prefix: "+66")
        case .timorLeste:                   PhoneCountry(flag: "🇹🇱", name: "Timor-Leste", prefix: "+670")
        case .togo:                         PhoneCountry(flag: "🇹🇬", name: "Togo", prefix: "+228")
        case .tonga:                        PhoneCountry(flag: "🇹🇴", name: "Tonga", prefix: "+676")
        case .trinidadAndTobago:            PhoneCountry(flag: "🇹🇹", name: "Trinidad and Tobago", prefix: "+1-868")
        case .tunisia:                      PhoneCountry(flag: "🇹🇳", name: "Tunisia", prefix: "+216")
        case .turkey:                       PhoneCountry(flag: "🇹🇷", name: "Turkey", prefix: "+90")
        case .turkmenistan:                 PhoneCountry(flag: "🇹🇲", name: "Turkmenistan", prefix: "+993")
        case .tuvalu:                       PhoneCountry(flag: "🇹🇻", name: "Tuvalu", prefix: "+688")
    
        case .uganda:                       PhoneCountry(flag: "🇺🇬", name: "Uganda", prefix: "+256")
        case .ukraine:                      PhoneCountry(flag: "🇺🇦", name: "Ukraine", prefix: "+380")
        case .unitedArabEmirates:           PhoneCountry(flag: "🇦🇪", name: "United Arab Emirates", prefix: "+971")
        case .unitedKingdom:                PhoneCountry(flag: "🇬🇧", name: "United Kingdom", prefix: "+44")
        case .unitedStates:                 PhoneCountry(flag: "🇺🇸", name: "United States", prefix: "+1")
        case .uruguay:                      PhoneCountry(flag: "🇺🇾", name: "Uruguay", prefix: "+598")
        case .uzbekistan:                   PhoneCountry(flag: "🇺🇿", name: "Uzbekistan", prefix: "+998")
    
        case .vanuatu:                      PhoneCountry(flag: "🇻🇺", name: "Vanuatu", prefix: "+678")
        case .vaticanCity:                  PhoneCountry(flag: "🇻🇦", name: "Vatican City", prefix: "+379")
        case .venezuela:                    PhoneCountry(flag: "🇻🇪", name: "Venezuela", prefix: "+58")
        case .vietnam:                      PhoneCountry(flag: "🇻🇳", name: "Vietnam", prefix: "+84")
    
        case .yemen:                        PhoneCountry(flag: "🇾🇪", name: "Yemen", prefix: "+967")
    
        case .zambia:                       PhoneCountry(flag: "🇿🇲", name: "Zambia", prefix: "+260")
        case .zimbabwe:                     PhoneCountry(flag: "🇿🇼", name: "Zimbabwe", prefix: "+263")

        }
    }
}
