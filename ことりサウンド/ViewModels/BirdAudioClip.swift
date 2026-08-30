import Foundation

struct BirdAudioClip: Identifiable, Hashable {
    let birdID: BirdSoundItem.ID
    let fileName: String

    var id: String { fileName }

    var displayName: String {
        URL(fileURLWithPath: fileName).deletingPathExtension().lastPathComponent
    }

    var bird: BirdSoundItem {
        BirdSoundItem.all.first(where: { $0.id == birdID }) ?? BirdSoundItem.all[0]
    }

    static let all: [BirdAudioClip] = localAudioClips

    private static let localAudioClips: [BirdAudioClip] = [
        ("sparrow", ["スズメ.mp3"]),
        ("crow", ["ハシブトガラス.mp3"]),
        ("rock_dove", ["ドバト.mp3"]),
        ("oriental_turtle_dove", ["キジバト.mp3"]),
        ("barn_swallow", ["ツバメ.mp3"]),
        ("brown_eared_bulbul", ["ヒヨドリ.mp3", "ヒヨドリ2.mp3", "ヒヨドリ3.mp3"]),
        ("white_cheeked_starling", ["ムクドリ.mp3"]),
        ("white_wagtail", ["セキレイ.mp3"]),
        ("warbling_white_eye", ["メジロ.mp3"]),
        ("japanese_tit", ["シジュウカラ.mp3"]),
        ("bull_headed_shrike", ["モズ.mp3"]),
        ("carrion_crow", ["ハシボソガラス.mp3"]),
        ("azure_winged_magpie", ["オナガ.mp3", "オナガ2.mp3"]),
        ("chinese_hwamei", ["ガビチョウ.mp3"]),
        ("japanese_bush_warbler", ["ウグイス.mp3", "ウグイス2.mp3", "ウグイス3.mp3", "ウグイス4.mp3"]),
        ("common_cuckoo", ["カッコウ.mp3"]),
        ("lesser_cuckoo", ["ホトトギス.mp3"]),
        ("daurian_redstart", ["ジョウビタキ.mp3"]),
        ("varied_tit", ["ヤマガラ.mp3"]),
        ("long_tailed_tit", ["エナガ.mp3"]),
        ("blue_rock_thrush", ["イソヒヨドリ.mp3"]),
        ("blue_and_white_flycatcher", ["オオルリ.mp3"]),
        ("japanese_paradise_flycatcher", ["サンコウチョウ.mp3"]),
        ("black_tailed_gull", ["ウミネコ.mp3"]),
        ("black_kite", ["トンビ.mp3"]),
        ("eastern_crowned_warbler", ["センダイムシクイ.mp3"]),
        ("ijimas_leaf_warbler", ["イイジマムシクイ.mp3"]),
        ("narcissus_flycatcher", ["キビタキ.mp3", "キビタキ2.mp3"]),
        ("willow_tit", ["コガラ.mp3"]),
        ("oriental_reed_warbler", ["オオヨシキリ.mp3"]),
        ("mosukes_wren", ["モスケミソサザイ.mp3"]),
        ("whites_thrush", ["トラツグミ.mp3"]),
        ("black_faced_bunting", ["アオジ.mp3", "アオジ2.mp3"]),
        ("eurasian_wren", ["ミソサザイ.mp3"]),
        ("japanese_sparrowhawk", ["ツミ.mp3"]),
        ("green_pheasant", ["キジ.mp3"]),
        ("japanese_green_woodpecker", ["アオゲラ.mp3"]),
        ("brown_hawk_owl", ["アオバズク.mp3"]),
        ("eurasian_skylark", ["ヒバリ.mp3"]),
        ("ruddy_kingfisher", ["アカショウビン.mp3"]),
        ("golden_eagle", ["ワシ.mp3"]),
        ("eastern_spot_billed_duck", ["カモ.mp3"]),
        ("indian_peafowl", ["インドクジャク.mp3"]),
        ("southern_screamer", ["カンムリサケビドリ.mp3"]),
        ("java_sparrow", ["文鳥.mp4"]),
        ("budgerigar", ["セキセイインコ.mp3"]),
        ("domestic_canary", ["カナリア.mp3"]),
        ("chick", ["ヒヨコ.mp3"]),
        ("chicken", ["ニワトリ.mp3", "ニワトリ2.mp3", "ニワトリ3.mp3"])
    ].flatMap { birdID, fileNames in
        fileNames.map { localClip(birdID, $0) }
    }

    private static func localClip(
        _ birdID: BirdSoundItem.ID,
        _ fileName: String
    ) -> BirdAudioClip {
        BirdAudioClip(birdID: birdID, fileName: fileName)
    }
}

extension BirdSoundItem {
    /// 鳴き声を無料で再生できる鳥。購入すると、この一覧以外も解放されます。
    static let freeAudioIDs: Set<ID> = [
        "sparrow",
        "crow",
        "carrion_crow",
        "rock_dove",
        "oriental_turtle_dove",
        "brown_eared_bulbul"
    ]

    var isPremiumAudio: Bool {
        !Self.freeAudioIDs.contains(id)
    }

    static var freeAudioItems: [BirdSoundItem] {
        all.filter { !$0.isPremiumAudio }
    }

    var audioClips: [BirdAudioClip] {
        BirdAudioClip.all.filter { $0.birdID == id }
    }
}
