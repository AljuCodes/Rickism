import Foundation

struct RMGetAllEpisodesResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let preve: String?
    }
    
    let info: Info
    let results: [RMEpisode]
}
