import SwiftUI
import DejavuSwift

public protocol BenefitsViewDelegate {
    func benefitsViewOnRedeemPressed()
}


public struct BenefitsView : View {
    
    let membership:Como.Membership?
    let delegate:BenefitsViewDelegate?
    
    @State private var selectedAssets:[String] = []
    
    public init(membership: Como.Membership?, delegate:BenefitsViewDelegate? = nil){
        self.membership = membership
        self.delegate = delegate
    }
    
    public var body: some View {
        VStack(spacing: 16) {

            if let membership {
                MemberDetailsHeaderView(membership: membership)
            }
                                    
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "gift")
                    Text(Como.trans("rewards")).textCase(.uppercase)
                }
                .foregroundColor(Dejavu.textSecondary)
                .font(.subheadline)
                
                if let assets = membership?.assets {
                    ForEach(assets, id: \.key) {
                        AssetView(asset: $0, selectedAssets:$selectedAssets)
                        Divider().overlay(Dejavu.backgroundDarker)
                    }
                }
                
                Spacer()
                
                Divider().overlay(Dejavu.backgroundDarker)
                HStack {
                    Spacer()
                    ButtonPrimary("Redeem") {
                        redeemSelectedAssets()
                    }
                }.padding()
            }
        }
        .foregroundColor(Dejavu.textPrimary)
    }
    
    private func redeemSelectedAssets(){
        Como.shared.currentSale?.redeemAssets = selectedAssets.map {
            Como.RedeemAsset(key: $0, appliedAmount: nil, code:nil)
        }
        delegate?.benefitsViewOnRedeemPressed()
    }
}

private struct MemberDetailsHeaderView : View {
    
    let membership:Como.Membership
    
    var body: some View {
        VStack(spacing: 20) {
          
            /*HStack(spacing: 4) {
                ForEach(membership.tags ?? [], id: \.self) { tag in
                    Text(tag)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.white)
                        .cornerRadius(4)
                        .font(.subheadline)
                }
            }*/

            
            HStack(spacing: 16) {

                Image(systemName: "bolt.circle.fill")
                    .foregroundColor(.orange)
                
                MemberTags(membership: membership)
                
                MemberSince(membership: membership)
                
                Spacer()
                
                HeaderStatsView(
                    title: Como.trans("points"),
                    value: "\(membership.pointsBalance?.balance.monetary ?? 0)"
                )
                
                HeaderStatsView(
                    title: Como.trans("credits"),
                    value: "\((membership.creditBalance?.balance.monetary ?? 0) / 100)"
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(8)
        
    }
}

private struct MemberTags : View {
    let membership:Como.Membership
    
    var body: some View{
        
        HStack(spacing: 4) {
            ForEach(membership.tags ?? [], id: \.self) { tag in
                Text(tag)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Dejavu.backgroundDarker)
                    .cornerRadius(4)
                    .font(.subheadline)
            }
        }
    }
}

private struct MemberSince : View {
    let membership:Como.Membership
    
    var body: some View {
        if #available(iOS 15.0, *) {
            if let memberSince = membership.createdOn {
                HStack {
                    Text(Como.trans("since"))
                    Text(memberSince, format: .dateTime.day().month().year())
                }
                .font(.caption)
                .foregroundColor(Dejavu.textSecondary)
            }
        }
    }
}

private struct HeaderStatsView : View {
    let title:String
    let value:String
    
    var body: some View {
        HStack (alignment: .center) {
            Text(value)
                .font(.title)
            
            Text(title)
                .textCase(.uppercase)
                .font(.subheadline)
                .foregroundColor(Dejavu.textSecondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
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
                    if !asset.redeemable {
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

        .background(selectedAssets.contains(asset.key) ? Dejavu.backgroundDarker : .white)
        .cornerRadius(8)
        .frame(height:110)
        .onTapGesture {
            guard asset.redeemable, asset.status == .active else { return }
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
    ).background(Dejavu.background)
}
