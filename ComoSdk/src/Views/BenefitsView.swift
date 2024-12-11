import SwiftUI
import DejavuSwift

public struct BenefitsView : View {
    
    let membership:Como.Membership?
    
    public init(membership: Como.Membership?){
        self.membership = membership
    }
    
    public var body: some View {
        VStack {

            if let membership {
                MemberDetailsHeaderView(membership: membership)
            }
            
            Divider().overlay(Dejavu.headerDark)
            
            Spacer().frame(height: 12)
            
            if let assets = membership?.assets {
                ForEach(assets, id: \.key) {
                    AssetView(asset: $0)
                }
            }
            
            Spacer()
            Divider().overlay(Dejavu.headerDark)
            
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
        .background(Dejavu.headerLighter)
        .foregroundColor(.white)
    }
}

private struct MemberDetailsHeaderView : View {
    
    let membership:Como.Membership
    
    var body: some View {
        VStack {
            //Text("Member since: \(membership.createdOn ?? Date())")
            //Text("Level: \(membership.pointsBalance?.balance.monetary ?? 0)")
          
            HStack(spacing: 20) {
                HStack (alignment: .center) {
                    Text("\(membership.pointsBalance?.balance.monetary ?? 0)")
                        .font(.title)
                    Text("Puntos")
                        .textCase(.uppercase)
                        .font(.subheadline)
                }
                            
                HStack (alignment: .center) {
                    Text("\(membership.creditBalance?.balance.monetary ?? 0)")
                        .font(.title)
                    Text("Créditos")
                        .textCase(.uppercase)
                        .font(.subheadline)
                }
            }            
        }
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
