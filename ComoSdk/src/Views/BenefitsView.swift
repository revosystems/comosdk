import SwiftUI
import DejavuSwift

public struct BenefitsView : View {
    
    let membership:Como.Membership?
    
    public init(membership: Como.Membership?){
        self.membership = membership
    }
    
    public var body: some View {
        VStack {
            Text("Member since: \(membership?.createdOn ?? Date())")
            Text("Credits: \(membership?.creditBalance?.balance.monetary ?? 0)")
            Text("Level: \(membership?.pointsBalance?.balance.monetary ?? 0)")
            
            Divider()
            
            Spacer().frame(height: 12)
            
            if let assets = membership?.assets {
                ForEach(assets, id: \.key) {
                    AssetView(asset: $0)
                }
            }
            
            Spacer()
            Divider()
            
            HStack {
                Spacer()
                Button("Redeem") {
                    print("redeem")
                }
                .padding()
                .cornerRadius(12)
                .background(Dejavu.brand)
                .foregroundColor(.white)
            }.padding()
        }
        .frame(maxWidth:.infinity)
    }
}

private struct AssetView : View {
    let asset:Como.Asset
    
    var body: some View {
        
        HStack (alignment: .top, spacing: 12) {
            if #available(iOS 15.0, *) {
                AsyncImage(url:URL(string: asset.image ?? "")) {
                    $0.image?.resizable()
                }
                .frame(width: 80, height: 80)
                .cornerRadius(12)
            }
            
            VStack (alignment: .leading){
                Text(asset.name).font(.system(size: 16, weight: .bold))
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
            
        }
        .padding()
        .background(Dejavu.headerLighter)
        .cornerRadius(12)
        .frame(height:110)
        .frame(maxWidth:.infinity)
        .foregroundColor(.white)
        
    }
}

#Preview {
    BenefitsView(membership: nil)
}
