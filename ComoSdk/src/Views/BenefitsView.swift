import SwiftUI
import DejavuSwift

public struct BenefitsView : View {
    
    let membership:Como.Membership?
    
    @State private var selectedAssets:[String] = []
    
    public init(membership: Como.Membership?){
        self.membership = membership
    }
    
    public var body: some View {
        VStack(spacing: 16) {

            if let membership {
                MemberDetailsHeaderView(membership: membership)
            }
            
            Divider().overlay(Dejavu.headerLighter)
            
            
            if let assets = membership?.assets {
                ForEach(assets, id: \.key) {
                    AssetView(asset: $0, selectedAssets:$selectedAssets)
                }
            }
            
            Spacer()
            Divider().overlay(Dejavu.headerLighter)
            
            HStack {
                Spacer()
                ButtonPrimary("Redeem") {
                    print("redeem")
                }                
            }.padding()
        }
        //.background(Dejavu.background)
        .foregroundColor(Dejavu.textPrimary)
    }
}

private struct MemberDetailsHeaderView : View {
    
    let membership:Como.Membership
    
    var body: some View {
        VStack(spacing: 20) {
            //Text("Member since: \(membership.createdOn ?? Date())")
            //Text("Level: \(membership.pointsBalance?.balance.monetary ?? 0)")
          
            HStack(spacing: 4) {
                ForEach(membership.tags ?? [], id: \.self) { tag in
                    Text(tag)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.white)
                        .cornerRadius(4)
                        .font(.subheadline)
                }
            }
            
            HStack(spacing: 20) {
                HeaderStatsView(
                    title: "Puntos",
                    value: "\(membership.pointsBalance?.balance.monetary ?? 0)",
                    icon: "star.fill"
                )
                
                HeaderStatsView(
                    title: "Créditos",
                    value: "\((membership.creditBalance?.balance.monetary ?? 0) / 100)",
                    icon: "eurosign.circle.fill"
                )
            }
        }
    }
}

private struct HeaderStatsView : View {
    
    let title:String
    let value:String
    let icon:String
    
    var body: some View {
        HStack (alignment: .center) {
            Text(value)
                .font(.title)
            
            Text(title)
                .textCase(.uppercase)
                .font(.subheadline)
            
            Image(systemName: icon)
                .foregroundColor(.green)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(Color.white)
        .cornerRadius(12)
        
    }
}

private struct AssetView : View {
    let asset:Como.Asset
    @Binding var selectedAssets:[String]
    
    var body: some View {
        
        HStack (alignment: .top, spacing: 18) {
            if #available(iOS 15.0, *) {
                AsyncImage(url:URL(string: asset.image ?? "")) {
                    $0.image?.resizable()
                }
                .frame(width: 80, height: 80)
                .cornerRadius(12)
            }
            
            VStack (alignment: .leading){
                Text(asset.name)
                    .font(.system(size: 16, weight: .bold))
                Text(asset.description ?? "--")
                    .font(.subheadline)
                    .opacity(0.8)
                          
                Spacer()
                
                HStack {
                    if asset.redeemable {                        
                        Image(systemName: "lock.fill")
                            .foregroundColor(.orange)
                        Text(Como.trans("como_non_reedemable"))
                        Text(asset.nonRedeemableCause?.message ?? "")
                    }
                    else{
                        Image(systemName: asset.status == .active ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(asset.status == .active ? .green : .red)
                        Text(Como.trans("como_\(asset.status)"))
                        
                    }
                }
                .font(.subheadline)
                .opacity(0.8)
                
            }
            Spacer().frame(maxWidth: .infinity)
            
        }
        .padding()
        .background(selectedAssets.contains(asset.key) ? Dejavu.backgroundDarker : Color.white)
        .cornerRadius(12)
        .frame(height:110)
        .onTapGesture {
            selectedAssets.toggle(asset.key)
        }
    }
}

#Preview {
    BenefitsView(
        membership: Como.Membership(
            firstName: "Jordi",
            lastName: "Puigdellivol",
            birthday: "17-03-1984",
            email: "jordi.p@revo.works",
            gender: "male",
            phoneNumber: "669686571",
            status: .active,
            createdOn: Date(),
            allowSMS: true,
            allowEmail: true,
            termsOfUse: true,
            gdpr: true,
            commonExtId: "123456",
            tags: ["Level 1", "Awesome", "Vip"],
            assets: [
                Como.Asset(
                    key: "1234",
                    name: "Regalo bienvenida",
                    description: "5€ de descuento",
                    status: .active,
                    image: nil,
                    validFrom: Date(),
                    validUntil: nil,
                    redeemable: true,
                    nonRedeemableCause: nil
                ),
                Como.Asset(
                    key: "1235",
                    name: "Free item",
                    description: "With any burger",
                    status: .future,
                    image: nil,
                    validFrom: nil,
                    validUntil: nil,
                    redeemable: false,
                    nonRedeemableCause: Como.NonRedeemableCause(
                        code: "a",
                        message:"Not a valid user"
                    )
                ),
            ]
        )
    )
}
