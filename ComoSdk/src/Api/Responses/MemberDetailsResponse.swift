import Foundation

public class MemberDetailsResponse : ComoApi.Response  {
    //let membership:String? = nil
    let memberNotes:[MemberNote]
    
    private enum CodingKeys: String, CodingKey {
        case memberNotes
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.memberNotes = try container.decode([MemberNote].self, forKey: .memberNotes)
        try super.init(from: decoder)
    }
}

public class MemberNote:Codable {
    let content:String
    let type:String
}
