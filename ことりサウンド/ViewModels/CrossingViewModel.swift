import SwiftUI

@MainActor
final class BirdSoundViewModel: ObservableObject {
    let items = BirdSoundItem.all
}

enum BirdGroup: String, CaseIterable, Identifiable {
    case town
    case nature
    case world
    case pet

    var id: String { rawValue }

    var title: String {
        switch self {
        case .town:
            return "まち・身近な鳥"
        case .nature:
            return "公園・野山・水辺"
        case .world:
            return "世界の鳥"
        case .pet:
            return "人と暮らす鳥"
        }
    }

    var subtitle: String {
        switch self {
        case .town:
            return "家の近くで出会える鳥たち"
        case .nature:
            return "季節と自然を感じる鳥たち"
        case .world:
            return "海外で暮らす個性豊かな鳥たち"
        case .pet:
            return "飼い鳥や家禽として親しまれる鳥たち"
        }
    }

    var symbol: String {
        switch self {
        case .town:
            return "house.fill"
        case .nature:
            return "leaf.fill"
        case .world:
            return "globe.asia.australia.fill"
        case .pet:
            return "heart.fill"
        }
    }

    var color: Color {
        switch self {
        case .town:
            return Color(hex: 0xE78B3C)
        case .nature:
            return Color(hex: 0x3B9D73)
        case .world:
            return Color(hex: 0x6F72B8)
        case .pet:
            return Color(hex: 0xD96991)
        }
    }
}

struct BirdSoundItem: Identifiable, Hashable {
    typealias ID = String

    enum Marking: String, Hashable {
        case plain
        case eyeRing
        case whiteCheek
        case darkCap
        case crest
        case longTail
    }

    let id: ID
    let title: String
    let scientificName: String
    let group: BirdGroup
    let primaryHex: UInt32
    let wingHex: UInt32
    let bellyHex: UInt32
    let accentHex: UInt32
    let marking: Marking

    var primaryColor: Color { Color(hex: primaryHex) }
    var wingColor: Color { Color(hex: wingHex) }
    var bellyColor: Color { Color(hex: bellyHex) }
    var accentColor: Color { Color(hex: accentHex) }
    var profile: BirdProfile { BirdProfiles.all[id] ?? BirdProfiles.fallback }
    var englishName: String { Self.englishNames[id] ?? "Bird" }

    // Checked against the IOC World Bird List v15.2.
    private static let englishNames: [ID: String] = [
        "sparrow": "Eurasian Tree Sparrow",
        "crow": "Large-billed Crow",
        "carrion_crow": "Carrion Crow",
        "rock_dove": "Rock Dove",
        "oriental_turtle_dove": "Oriental Turtle Dove",
        "brown_eared_bulbul": "Brown-eared Bulbul",
        "white_cheeked_starling": "White-cheeked Starling",
        "white_wagtail": "White Wagtail",
        "barn_swallow": "Barn Swallow",
        "japanese_tit": "Cinereous Tit",
        "warbling_white_eye": "Warbling White-eye",
        "azure_winged_magpie": "Azure-winged Magpie",
        "bull_headed_shrike": "Bull-headed Shrike",
        "chinese_hwamei": "Chinese Hwamei",
        "japanese_bush_warbler": "Japanese Bush Warbler",
        "common_cuckoo": "Common Cuckoo",
        "lesser_cuckoo": "Lesser Cuckoo",
        "daurian_redstart": "Daurian Redstart",
        "varied_tit": "Varied Tit",
        "long_tailed_tit": "Long-tailed Tit",
        "blue_rock_thrush": "Blue Rock Thrush",
        "blue_and_white_flycatcher": "Blue-and-white Flycatcher",
        "japanese_paradise_flycatcher": "Black Paradise Flycatcher",
        "black_tailed_gull": "Black-tailed Gull",
        "black_kite": "Black Kite",
        "eastern_crowned_warbler": "Eastern Crowned Warbler",
        "ijimas_leaf_warbler": "Ijima's Leaf Warbler",
        "narcissus_flycatcher": "Narcissus Flycatcher",
        "willow_tit": "Willow Tit",
        "oriental_reed_warbler": "Oriental Reed Warbler",
        "mosukes_wren": "Mosuke's Wren",
        "whites_thrush": "White's Thrush",
        "black_faced_bunting": "Black-faced Bunting",
        "eurasian_wren": "Eurasian Wren",
        "japanese_sparrowhawk": "Japanese Sparrowhawk",
        "green_pheasant": "Green Pheasant",
        "japanese_green_woodpecker": "Japanese Green Woodpecker",
        "brown_hawk_owl": "Northern Boobook",
        "eurasian_skylark": "Eurasian Skylark",
        "ruddy_kingfisher": "Ruddy Kingfisher",
        "golden_eagle": "Golden Eagle",
        "eastern_spot_billed_duck": "Eastern Spot-billed Duck",
        "indian_peafowl": "Indian Peafowl",
        "southern_screamer": "Southern Screamer",
        "java_sparrow": "Java Sparrow",
        "budgerigar": "Budgerigar",
        "domestic_canary": "Atlantic Canary",
        "chick": "Domestic Chicken",
        "chicken": "Domestic Chicken"
    ]

    static let all: [BirdSoundItem] = [
        .init(id: "sparrow", title: "スズメ", scientificName: "Passer montanus", group: .town, primaryHex: 0x9B6946, wingHex: 0x704832, bellyHex: 0xF2DEC1, accentHex: 0x4A342B, marking: .whiteCheek),
        .init(id: "crow", title: "ハシブトガラス", scientificName: "Corvus macrorhynchos", group: .town, primaryHex: 0x283345, wingHex: 0x111827, bellyHex: 0x303B4D, accentHex: 0x161D29, marking: .plain),
        .init(id: "carrion_crow", title: "ハシボソガラス", scientificName: "Corvus corone", group: .town, primaryHex: 0x252A31, wingHex: 0x15191F, bellyHex: 0xE8ECE5, accentHex: 0x24282C, marking: .plain),
        .init(id: "rock_dove", title: "ドバト", scientificName: "Columba livia", group: .town, primaryHex: 0x7F8B9D, wingHex: 0x5E697A, bellyHex: 0xBCC4CF, accentHex: 0x4F8A77, marking: .plain),
        .init(id: "oriental_turtle_dove", title: "キジバト", scientificName: "Streptopelia orientalis", group: .town, primaryHex: 0x9B735B, wingHex: 0x725647, bellyHex: 0xD8BFA9, accentHex: 0x4B3D3A, marking: .plain),
        .init(id: "brown_eared_bulbul", title: "ヒヨドリ", scientificName: "Hypsipetes amaurotis", group: .town, primaryHex: 0x72818A, wingHex: 0x56636B, bellyHex: 0xB9C2C4, accentHex: 0x8A6652, marking: .darkCap),
        .init(id: "white_cheeked_starling", title: "ムクドリ", scientificName: "Spodiopsar cineraceus", group: .town, primaryHex: 0x594A45, wingHex: 0x332F31, bellyHex: 0xA59184, accentHex: 0xF09B48, marking: .whiteCheek),
        .init(id: "white_wagtail", title: "ハクセキレイ", scientificName: "Motacilla alba", group: .town, primaryHex: 0x303A46, wingHex: 0x181E26, bellyHex: 0xF5F5F0, accentHex: 0x68727A, marking: .longTail),
        .init(id: "barn_swallow", title: "ツバメ", scientificName: "Hirundo rustica", group: .town, primaryHex: 0x254D67, wingHex: 0x16384D, bellyHex: 0xF5EEE1, accentHex: 0xB5573E, marking: .longTail),
        .init(id: "japanese_tit", title: "シジュウカラ", scientificName: "Parus minor", group: .town, primaryHex: 0x3B4652, wingHex: 0x526E80, bellyHex: 0xE7E2C5, accentHex: 0x222B31, marking: .whiteCheek),
        .init(id: "warbling_white_eye", title: "メジロ", scientificName: "Zosterops japonicus", group: .town, primaryHex: 0x88A83B, wingHex: 0x667F2D, bellyHex: 0xD6D99A, accentHex: 0xE7B64B, marking: .eyeRing),
        .init(id: "azure_winged_magpie", title: "オナガ", scientificName: "Cyanopica cyanus", group: .town, primaryHex: 0x8FA3B5, wingHex: 0x5D8FB7, bellyHex: 0xF0F1EC, accentHex: 0x252D38, marking: .longTail),
        .init(id: "bull_headed_shrike", title: "モズ", scientificName: "Lanius bucephalus", group: .town, primaryHex: 0xAD7147, wingHex: 0x3E3A3A, bellyHex: 0xE7C8A9, accentHex: 0x383235, marking: .darkCap),
        .init(id: "chinese_hwamei", title: "ガビチョウ", scientificName: "Garrulax canorus", group: .town, primaryHex: 0x9A704E, wingHex: 0x745239, bellyHex: 0xC7A37E, accentHex: 0xF5F0E5, marking: .eyeRing),

        .init(id: "japanese_bush_warbler", title: "ウグイス", scientificName: "Horornis diphone", group: .nature, primaryHex: 0x778758, wingHex: 0x596846, bellyHex: 0xC3C6A5, accentHex: 0x667746, marking: .plain),
        .init(id: "common_cuckoo", title: "カッコウ", scientificName: "Cuculus canorus", group: .nature, primaryHex: 0x77838E, wingHex: 0x58636E, bellyHex: 0xE1E4DF, accentHex: 0x4C5660, marking: .plain),
        .init(id: "lesser_cuckoo", title: "ホトトギス", scientificName: "Cuculus poliocephalus", group: .nature, primaryHex: 0x667887, wingHex: 0x485C69, bellyHex: 0xE5E6DE, accentHex: 0x53636E, marking: .plain),
        .init(id: "daurian_redstart", title: "ジョウビタキ", scientificName: "Phoenicurus auroreus", group: .nature, primaryHex: 0x535B65, wingHex: 0x30363D, bellyHex: 0xD77B44, accentHex: 0xE7A15B, marking: .whiteCheek),
        .init(id: "varied_tit", title: "ヤマガラ", scientificName: "Sittiparus varius", group: .nature, primaryHex: 0x4D5962, wingHex: 0x263746, bellyHex: 0xCF7545, accentHex: 0xE0A36C, marking: .whiteCheek),
        .init(id: "long_tailed_tit", title: "エナガ", scientificName: "Aegithalos caudatus", group: .nature, primaryHex: 0xE4E0DA, wingHex: 0x654E5B, bellyHex: 0xF7F4EE, accentHex: 0xD6A3B3, marking: .longTail),
        .init(id: "blue_rock_thrush", title: "イソヒヨドリ", scientificName: "Monticola solitarius", group: .nature, primaryHex: 0x356B8C, wingHex: 0x254B65, bellyHex: 0xA95B3E, accentHex: 0xD88755, marking: .plain),
        .init(id: "blue_and_white_flycatcher", title: "オオルリ", scientificName: "Cyanoptila cyanomelana", group: .nature, primaryHex: 0x286AA1, wingHex: 0x172E42, bellyHex: 0xF6F5EC, accentHex: 0x1C2731, marking: .plain),
        .init(id: "japanese_paradise_flycatcher", title: "サンコウチョウ", scientificName: "Terpsiphone atrocaudata", group: .nature, primaryHex: 0x2D3338, wingHex: 0x9C5940, bellyHex: 0xF5F3E8, accentHex: 0x4F9ABB, marking: .longTail),
        .init(id: "black_tailed_gull", title: "ウミネコ", scientificName: "Larus crassirostris", group: .nature, primaryHex: 0xF2F1E9, wingHex: 0x7B8490, bellyHex: 0xFCFAF1, accentHex: 0xD7A735, marking: .plain),
        .init(id: "black_kite", title: "トビ", scientificName: "Milvus migrans", group: .nature, primaryHex: 0x6A4A34, wingHex: 0x4C3528, bellyHex: 0x9A7354, accentHex: 0xD5B27B, marking: .plain),
        .init(id: "eastern_crowned_warbler", title: "センダイムシクイ", scientificName: "Phylloscopus coronatus", group: .nature, primaryHex: 0x7D8A4D, wingHex: 0x5C6938, bellyHex: 0xEEE9D2, accentHex: 0xD6C75E, marking: .eyeRing),
        .init(id: "ijimas_leaf_warbler", title: "イイジマムシクイ", scientificName: "Phylloscopus ijimae", group: .nature, primaryHex: 0x79864D, wingHex: 0x5D693C, bellyHex: 0xE8E4CF, accentHex: 0xA9B679, marking: .eyeRing),
        .init(id: "narcissus_flycatcher", title: "キビタキ", scientificName: "Ficedula narcissina", group: .nature, primaryHex: 0x2F3438, wingHex: 0x171B1E, bellyHex: 0xF0C43E, accentHex: 0xE98B35, marking: .whiteCheek),
        .init(id: "willow_tit", title: "コガラ", scientificName: "Poecile montanus", group: .nature, primaryHex: 0x3E4243, wingHex: 0x74746E, bellyHex: 0xE6DFD1, accentHex: 0xF5F1E8, marking: .darkCap),
        .init(id: "oriental_reed_warbler", title: "オオヨシキリ", scientificName: "Acrocephalus orientalis", group: .nature, primaryHex: 0x927353, wingHex: 0x6A503D, bellyHex: 0xDED0B7, accentHex: 0xC1A272, marking: .plain),
        .init(id: "mosukes_wren", title: "モスケミソサザイ", scientificName: "Troglodytes troglodytes mosukei", group: .nature, primaryHex: 0x674638, wingHex: 0x4C342C, bellyHex: 0x8C6652, accentHex: 0xB98D70, marking: .plain),
        .init(id: "whites_thrush", title: "トラツグミ", scientificName: "Zoothera aurea", group: .nature, primaryHex: 0x9A754E, wingHex: 0x72533B, bellyHex: 0xD8BA8E, accentHex: 0x332A24, marking: .plain),
        .init(id: "black_faced_bunting", title: "アオジ", scientificName: "Emberiza spodocephala", group: .nature, primaryHex: 0x677258, wingHex: 0x4F513B, bellyHex: 0xC4C978, accentHex: 0x3B3830, marking: .darkCap),
        .init(id: "eurasian_wren", title: "ミソサザイ", scientificName: "Troglodytes troglodytes", group: .nature, primaryHex: 0x7D553E, wingHex: 0x5A3E31, bellyHex: 0xA77B5D, accentHex: 0xD0AA82, marking: .plain),
        .init(id: "japanese_sparrowhawk", title: "ツミ", scientificName: "Tachyspiza gularis", group: .nature, primaryHex: 0x5A6674, wingHex: 0x3D4855, bellyHex: 0xE5D8CA, accentHex: 0xC46E52, marking: .plain),
        .init(id: "green_pheasant", title: "キジ", scientificName: "Phasianus versicolor", group: .nature, primaryHex: 0x1F5C4A, wingHex: 0x5C5847, bellyHex: 0x3E7962, accentHex: 0xC64239, marking: .longTail),
        .init(id: "japanese_green_woodpecker", title: "アオゲラ", scientificName: "Picus awokera", group: .nature, primaryHex: 0x668154, wingHex: 0x48633F, bellyHex: 0xC1C5A6, accentHex: 0xB8473F, marking: .darkCap),
        .init(id: "brown_hawk_owl", title: "アオバズク", scientificName: "Ninox japonica", group: .nature, primaryHex: 0x5A493C, wingHex: 0x3F352E, bellyHex: 0xE0D4BE, accentHex: 0xD8B443, marking: .plain),
        .init(id: "eurasian_skylark", title: "ヒバリ", scientificName: "Alauda arvensis", group: .nature, primaryHex: 0x84674E, wingHex: 0x654D3C, bellyHex: 0xD7C6A9, accentHex: 0xAD8A64, marking: .crest),
        .init(id: "ruddy_kingfisher", title: "アカショウビン", scientificName: "Halcyon coromanda", group: .nature, primaryHex: 0xA94E3C, wingHex: 0x7C3B38, bellyHex: 0xE58A63, accentHex: 0xD3564C, marking: .plain),
        .init(id: "golden_eagle", title: "イヌワシ", scientificName: "Aquila chrysaetos", group: .nature, primaryHex: 0x4A3528, wingHex: 0x30251F, bellyHex: 0x6F5038, accentHex: 0xC19A55, marking: .plain),
        .init(id: "eastern_spot_billed_duck", title: "カルガモ", scientificName: "Anas zonorhyncha", group: .nature, primaryHex: 0x786B58, wingHex: 0x4E4B45, bellyHex: 0xA99A81, accentHex: 0xE2B43D, marking: .eyeRing),

        .init(id: "indian_peafowl", title: "インドクジャク", scientificName: "Pavo cristatus", group: .world, primaryHex: 0x1F6792, wingHex: 0x4F7F52, bellyHex: 0x24507B, accentHex: 0xB8A94E, marking: .crest),
        .init(id: "southern_screamer", title: "カンムリサケビドリ", scientificName: "Chauna torquata", group: .world, primaryHex: 0x7A7B79, wingHex: 0x595C5D, bellyHex: 0xB5B3AA, accentHex: 0xB24F45, marking: .crest),

        .init(id: "java_sparrow", title: "文鳥", scientificName: "Padda oryzivora", group: .pet, primaryHex: 0xB8B3AD, wingHex: 0x777371, bellyHex: 0xF5F0E8, accentHex: 0xE26A70, marking: .darkCap),
        .init(id: "budgerigar", title: "セキセイインコ", scientificName: "Melopsittacus undulatus", group: .pet, primaryHex: 0x8FCB50, wingHex: 0x4F9C61, bellyHex: 0xD7E869, accentHex: 0xF0C44A, marking: .whiteCheek),
        .init(id: "domestic_canary", title: "カナリア", scientificName: "Serinus canaria", group: .pet, primaryHex: 0xE7C83B, wingHex: 0xB9A135, bellyHex: 0xF2DD62, accentHex: 0xD99A2B, marking: .plain),
        .init(id: "chick", title: "ヒヨコ", scientificName: "Gallus gallus domesticus", group: .pet, primaryHex: 0xF0C94E, wingHex: 0xDDB241, bellyHex: 0xF8E797, accentHex: 0xE38F41, marking: .plain),
        .init(id: "chicken", title: "ニワトリ", scientificName: "Gallus gallus domesticus", group: .pet, primaryHex: 0xF3F0E7, wingHex: 0xB88A55, bellyHex: 0xFCF9EF, accentHex: 0xC94B3F, marking: .crest)
    ]
}

extension Color {
    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}
