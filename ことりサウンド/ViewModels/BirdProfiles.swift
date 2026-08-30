import Foundation

struct BirdProfile: Hashable {
    let appearance: String
    let habitat: String
    let voice: String
}

enum BirdProfiles {
    static let fallback = BirdProfile(
        appearance: "体の色や模様をよく見ると、その鳥らしい特徴が見つかります。",
        habitat: "季節や場所によって、見られる環境や行動が変わります。",
        voice: "鳴き方には個体差や地域差があり、さまざまな声を使い分けます。"
    )

    static let all: [String: BirdProfile] = [
        "sparrow": BirdProfile(
            appearance: "茶色い頭と白い頬、頬にある黒い斑が目印。雌雄はほぼ同じ色です。",
            habitat: "人家や農耕地の近くで暮らし、地上で草の種や小さな虫を探します。",
            voice: "「チュン、チュン」と短く鳴き、群れではにぎやかに声を交わします。"
        ),
        "crow": BirdProfile(
            appearance: "太く湾曲したくちばしと盛り上がった額が特徴。尾は丸みを帯びます。",
            habitat: "森林から市街地まで幅広く暮らし、木の実や昆虫など何でも食べます。",
            voice: "澄んだ声で「カア、カア」。首を前へ伸ばすようにして鳴きます。"
        ),
        "rock_dove": BirdProfile(
            appearance: "灰色の体と翼の2本の黒帯、光によって緑や紫に輝く首が特徴です。",
            habitat: "駅前や公園などで群れをつくり、地面を歩いて穀物や種を拾います。",
            voice: "低く柔らかな声で「クルックー、クルックー」と繰り返します。"
        ),
        "oriental_turtle_dove": BirdProfile(
            appearance: "翼のうろこ模様と、首の横に並ぶ青黒いしま模様が目印です。",
            habitat: "林の縁や農耕地、住宅地で見られ、地上で種や木の実を食べます。",
            voice: "「デデッポッポー」と聞こえる、ゆったりした声で鳴きます。"
        ),
        "barn_swallow": BirdProfile(
            appearance: "光沢のある青黒い背、赤褐色の額とのど、深く二又に分かれた尾が特徴です。",
            habitat: "春に渡来し、軒下へ泥の巣を作り、飛びながら小さな虫を捕らえます。",
            voice: "「チュピッ、チュピッ」とさえずり、最後に濁った声を添えます。"
        ),
        "brown_eared_bulbul": BirdProfile(
            appearance: "灰褐色の体に茶色い頬、やや長い尾。頭の羽を少し立てることがあります。",
            habitat: "林や公園、庭で果実や花の蜜、昆虫を食べ、冬には群れで移動します。",
            voice: "「ピーヨ、ピーヨ」など、よく通る大きな声でさまざまに鳴きます。"
        ),
        "white_cheeked_starling": BirdProfile(
            appearance: "黒っぽい頭と白い頬、橙色のくちばしと脚が目立つ、むっちりした鳥です。",
            habitat: "芝生や畑で虫を探し、繁殖後や冬には大きな群れとねぐらを作ります。",
            voice: "「キュルキュル」「ギャー」など、少し濁った声を使い分けます。"
        ),
        "white_wagtail": BirdProfile(
            appearance: "白黒の体と細長い尾が特徴。歩きながら尾を上下に振り続けます。",
            habitat: "水辺や河原、駐車場など開けた場所を歩き、小さな虫を捕らえます。",
            voice: "飛びながら「チチン、チチン」と、鋭く澄んだ声で鳴きます。"
        ),
        "warbling_white_eye": BirdProfile(
            appearance: "黄緑色の体と、目のまわりを囲む白く太い輪が名前どおりの目印です。",
            habitat: "林や庭を小群で動き、花の蜜や熟した果実、小さな虫を食べます。",
            voice: "細い地鳴きに加え、春は明るく複雑な節回しで長くさえずります。"
        ),
        "japanese_tit": BirdProfile(
            appearance: "黒い頭と白い頬、胸から腹へ伸びる黒い帯が特徴。雄は帯が太めです。",
            habitat: "林から住宅地まで暮らし、枝先で昆虫や種を探し、樹洞に巣を作ります。",
            voice: "「ツツピー」のほか多彩な声を持ち、声の組み合わせも使い分けます。"
        ),
        "bull_headed_shrike": BirdProfile(
            appearance: "鉤形のくちばしと目を横切る黒い線が特徴。雄は橙褐色が鮮やかです。",
            habitat: "枝先から地上を見張って虫や小動物を捕らえ、枝へ獲物を刺すことがあります。",
            voice: "秋は「キィーキィー」と高鳴きし、ほかの鳥の声をまねることもあります。"
        ),
        "carrion_crow": BirdProfile(
            appearance: "くちばしは細めで額からなだらかに続き、ハシブトガラスよりスマートです。",
            habitat: "田畑や河川敷など開けた環境を好み、地面を歩いて幅広い餌を探します。",
            voice: "濁った声で「ガー、ガー」。頭を上下させながら鳴く姿が見られます。"
        ),
        "azure_winged_magpie": BirdProfile(
            appearance: "黒い帽子のような頭、淡い灰色の体、青い翼と長い尾がよく目立ちます。",
            habitat: "林のある住宅地や公園で家族群を作り、昆虫や木の実を食べます。",
            voice: "「ゲーイ」「ギュイ」と、姿の美しさとは対照的なしわがれ声で鳴きます。"
        ),
        "chinese_hwamei": BirdProfile(
            appearance: "全身は茶褐色で、白いアイリングが目の後ろへ眉のように長く伸びます。",
            habitat: "藪の濃い林床を歩いて餌を探す外来鳥で、日本では特定外来生物です。",
            voice: "音量のある複雑な口笛を長く続け、ほかの鳥の声をまねることもあります。"
        ),
        "japanese_bush_warbler": BirdProfile(
            appearance: "目立たないオリーブ褐色で、目の上に淡い眉斑があります。",
            habitat: "笹藪や低木の茂みを好み、姿を隠したまま枝や葉の間で虫を探します。",
            voice: "春の「ホーホケキョ」が有名。地鳴きは「チャッ、チャッ」です。"
        ),
        "common_cuckoo": BirdProfile(
            appearance: "細身の灰色で腹に細い横斑があり、飛ぶ姿は小型のタカにも似ています。",
            habitat: "明るい林や高原に夏鳥として渡来し、ほかの鳥の巣へ卵を産みます。",
            voice: "雄は名前どおり「カッコウ」。遠くまで届く二音を繰り返します。"
        ),
        "lesser_cuckoo": BirdProfile(
            appearance: "カッコウより小さく、灰色の背と細かな横斑のある白い腹をしています。",
            habitat: "山地の林へ夏鳥として渡来し、主にウグイスの巣へ托卵します。",
            voice: "「キョッキョッキョキョキョ」と、速く畳みかけるように鳴きます。"
        ),
        "daurian_redstart": BirdProfile(
            appearance: "雄は銀色の頭と黒い顔、橙色の腹、翼の白斑が特徴。雌は淡い褐色です。",
            habitat: "冬に開けた林や住宅地へ現れ、尾を震わせながら虫や木の実を探します。",
            voice: "澄んだ「ヒッ、ヒッ」に、火打石のような「カッカッ」を続けます。"
        ),
        "varied_tit": BirdProfile(
            appearance: "黒い頭と淡い顔、栗色の背と腹を持つ、温かみのある配色の鳥です。",
            habitat: "森林で虫や木の実を食べ、秋に拾った種を樹皮の隙間へ貯える習性があります。",
            voice: "「ツツピー」のさえずりに加え、「ニーニー」と鼻にかかった声も出します。"
        ),
        "long_tailed_tit": BirdProfile(
            appearance: "小さく丸い体に、体より長く見える尾。白を基調に黒と淡紅色が入ります。",
            habitat: "林を家族群で巡り、細い枝先にぶら下がりながら小さな虫を探します。",
            voice: "細い「チーチー」と、少し濁った「ジュリリ」を続けて鳴きます。"
        ),
        "blue_rock_thrush": BirdProfile(
            appearance: "雄は青い頭と背に赤褐色の腹、雌は全身にうろこ状の模様があります。",
            habitat: "海岸の岩場に加え、近年は街のビルやマンションでも繁殖します。",
            voice: "澄んだ口笛のような音をつなぎ、変化に富んだ美しい歌を聞かせます。"
        ),
        "blue_and_white_flycatcher": BirdProfile(
            appearance: "雄は深い瑠璃色の背と黒い顔、白い腹が鮮やか。雌は褐色です。",
            habitat: "夏の山地や渓谷沿いの林で、枝から飛び立って空中の虫を捕らえます。",
            voice: "「ピールリ、ポィヒー」と、ゆったりしたよく響く声でさえずります。"
        ),
        "japanese_paradise_flycatcher": BirdProfile(
            appearance: "青いアイリングと黒い頭、赤褐色の翼が特徴。雄の尾は非常に長く伸びます。",
            habitat: "夏鳥として暗い広葉樹林へ渡来し、枝から飛んで空中の虫を捕らえます。",
            voice: "「ツキヒホシ、ホイホイホイ」と聞きなされる独特の声で鳴きます。"
        ),
        "black_tailed_gull": BirdProfile(
            appearance: "白い体と濃い灰色の背、成鳥の尾にある黒い帯が大きな目印です。",
            habitat: "日本の海岸や港で一年中見られ、魚や海辺の小動物などを食べます。",
            voice: "「ミャーオ」と猫のような声で鳴くことから、ウミネコと呼ばれます。"
        ),
        "black_kite": BirdProfile(
            appearance: "全身が褐色の大型猛禽で、飛ぶと浅く二又に分かれた尾が見えます。",
            habitat: "海岸や川、市街地の上を輪を描いて飛び、魚や動物の死骸も利用します。",
            voice: "空高くから「ピーヒョロロロ」と、細くよく通る声で鳴きます。"
        ),
        "eastern_crowned_warbler": BirdProfile(
            appearance: "緑色の背と白い腹、頭頂中央の淡い線、黄色い下尾筒が識別点です。",
            habitat: "夏鳥として落葉広葉樹林へ渡来し、樹冠部を動き回って小さな虫を探します。",
            voice: "「チヨチヨビー」と聞こえる、短く歯切れのよい節でさえずります。"
        ),
        "ijimas_leaf_warbler": BirdProfile(
            appearance: "淡い眉斑と2本の翼帯を持つ小鳥で、頭頂中央の淡色線はありません。",
            habitat: "主に伊豆諸島で繁殖する日本固有種で、冬は南西諸島方面へ移動します。",
            voice: "「チュイ、チュイ、チュイ」と、明るい声をテンポよく繰り返します。"
        ),
        "narcissus_flycatcher": BirdProfile(
            appearance: "雄は黒と鮮黄色、橙色を組み合わせ、翼に白斑があります。雌は褐色です。",
            habitat: "夏の森林で枝に止まって虫を見張り、飛び立って空中で捕らえます。",
            voice: "「ピッコロロ、ツクツクオーシ」など、明るく変化の多い歌を奏でます。"
        ),
        "willow_tit": BirdProfile(
            appearance: "黒い帽子と小さなのど斑、白い頬、灰褐色の背を持つシジュウカラ類です。",
            habitat: "涼しい山地の林に暮らし、柔らかな朽ち木へ自分で巣穴を掘ります。",
            voice: "「ツィーツィー」のほか、「ディーディー」と鼻にかかった声を出します。"
        ),
        "oriental_reed_warbler": BirdProfile(
            appearance: "褐色で細長い体と、長く太めのくちばし、淡い眉斑を持つ大型のヨシキリです。",
            habitat: "夏のヨシ原で茎を渡り歩き、昆虫を食べ、ヨシの間へ巣を掛けます。",
            voice: "「ギョギョシ、ギョギョシ」と、濁った大声で休まずさえずります。"
        ),
        "mosukes_wren": BirdProfile(
            appearance: "短い尾を立てたごく小さな鳥で、本土のミソサザイより体色が濃い亜種です。",
            habitat: "伊豆諸島の林床や岩場、沢沿いの藪で、地面近くの小さな虫を探します。",
            voice: "小さな体から、細かな音を連ねた力強く長いさえずりを響かせます。"
        ),
        "whites_thrush": BirdProfile(
            appearance: "黄褐色の体を黒い三日月形の斑が覆う、大型でずんぐりしたツグミです。",
            habitat: "夏は山地の林で落ち葉を返して虫を探し、冬は暖地や低地の林へ移動します。",
            voice: "夜や早朝の森で「ヒィー、ヒョー」と、長く澄んだ物悲しい声を響かせます。"
        ),
        "black_faced_bunting": BirdProfile(
            appearance: "雄は灰緑色の頭と黒っぽい顔、黄緑色の腹。雌は褐色で淡い眉斑があります。",
            habitat: "林縁や藪、河川敷で暮らし、地上に落ちた種や小さな虫を探します。",
            voice: "地鳴きは細い「チッ」。繁殖期には明るく短い節を繰り返しさえずります。"
        ),
        "eurasian_wren": BirdProfile(
            appearance: "丸い褐色の体に細かな横斑があり、ごく短い尾をぴんと立てる小鳥です。",
            habitat: "沢沿いの倒木や岩、藪の隙間を素早く動き、地表近くで小さな虫を探します。",
            voice: "小さな体から、細かな音と震える節を連ねた力強い歌を長く響かせます。"
        ),
        "japanese_sparrowhawk": BirdProfile(
            appearance: "雄は青灰色の背と赤褐色の横斑、雌は褐色。長い尾と黄色い脚が特徴です。",
            habitat: "平地から低山の林や都市の緑地で繁殖し、木々の間を俊敏に飛んで小鳥を捕らえます。",
            voice: "繁殖期に「キョキョキョキョ」と、細く鋭い声を続けて鳴きます。"
        ),
        "green_pheasant": BirdProfile(
            appearance: "雄は光沢のある緑色の体と赤い顔、長い尾が特徴。雌は黄褐色の斑模様です。",
            habitat: "草地や農耕地、林縁を地上で歩き、種や芽、昆虫などを食べます。",
            voice: "雄は「ケーン、ケーン」と鳴き、直後に翼を激しく打つ母衣打ちを行います。"
        ),
        "japanese_green_woodpecker": BirdProfile(
            appearance: "緑色の背と赤い頭頂、灰色の顔が特徴。雄は顎線にも赤色が入ります。",
            habitat: "本州などの林に暮らす日本固有種で、幹を登りながらアリや昆虫を探します。",
            voice: "「ピョー、ピョー」とよく通る声で鳴き、木を打つドラミングも行います。"
        ),
        "brown_hawk_owl": BirdProfile(
            appearance: "耳羽のない丸い頭、黄色い目、褐色の背と白い腹の太い縦斑が特徴です。",
            habitat: "夏鳥として大木のある林や社寺林へ渡来し、夕方から昆虫や小動物を狙います。",
            voice: "夜に「ホッホー、ホッホー」と、二声ずつ規則正しく繰り返します。"
        ),
        "eurasian_skylark": BirdProfile(
            appearance: "全身が褐色のまだら模様で、興奮すると頭の短い冠羽を立てます。",
            habitat: "草地や畑、河川敷の地上で暮らし、草むらのくぼみに巣を作ります。",
            voice: "春は空高く停空飛翔しながら、細かな節を切れ目なく長くさえずります。"
        ),
        "ruddy_kingfisher": BirdProfile(
            appearance: "赤褐色の体と大きな赤いくちばし、青紫色を帯びる腰が鮮やかです。",
            habitat: "夏鳥として薄暗い森林や沢沿いへ渡来し、カエルやカニ、昆虫を捕らえます。",
            voice: "「キョロロロロ」と、音程を下げながら遠くまで響く声で鳴きます。"
        ),
        "golden_eagle": BirdProfile(
            appearance: "暗褐色の大きなワシで、後頭部から首にかけて金色の羽が光ります。",
            habitat: "山岳の崖に巣を作り、広い行動圏を飛んでノウサギやヘビなどを捕らえます。",
            voice: "普段は静かですが、「ピュイー」と細く高い笛のような声を出します。"
        ),
        "eastern_spot_billed_duck": BirdProfile(
            appearance: "全身は褐色のまだらで、黒いくちばしの先の黄色と橙色の脚が目印です。",
            habitat: "池や川、水田で一年中見られ、水面で植物や小さな水生動物を食べます。",
            voice: "雌は「グェッ、グェッ」と大きく鳴き、雄はより低く控えめな声を出します。"
        ),
        "java_sparrow": BirdProfile(
            appearance: "灰色の体と黒い頭、白い頬、太く赤いくちばしが特徴です。",
            habitat: "原産地では草地や水田に群れ、飼育下でも仲間との結びつきが強い鳥です。",
            voice: "「チチッ」と短く呼び合い、雄は小さく転がすような歌を続けます。"
        ),
        "budgerigar": BirdProfile(
            appearance: "野生型は黄緑色で頭から翼に黒い波模様。飼育品種は色彩が豊富です。",
            habitat: "原産地オーストラリアでは乾燥地を大群で移動し、草の種を食べます。",
            voice: "「ピュルピュル」と絶えずおしゃべりし、人の言葉をまねる個体もいます。"
        ),
        "domestic_canary": BirdProfile(
            appearance: "野生型は黄緑がかった褐色。飼育品種には黄色や白、橙色などがあります。",
            habitat: "祖先はカナリア諸島などの低木地に暮らし、長い飼育の歴史を持ちます。",
            voice: "細かな音を連ねた澄んだ歌が特徴で、とくに雄が長く複雑にさえずります。"
        ),
        "chick": BirdProfile(
            appearance: "生まれて間もない体は柔らかな綿羽に覆われ、翼や尾はまだ短い姿です。",
            habitat: "母鶏の後を追い、地面をつついて食べ物を覚えながら急速に成長します。",
            voice: "「ピヨピヨ」と呼び合い、不安や寒さを感じると声が大きく速くなります。"
        ),
        "chicken": BirdProfile(
            appearance: "赤いとさかと肉垂が目立ち、品種によって体格や羽色が大きく異なります。",
            habitat: "地面を足でかいて種や虫を探し、群れの中に順位を作って暮らします。",
            voice: "雄の「コケコッコー」のほか、雌の警戒声や産卵後の声など多彩です。"
        ),
        "indian_peafowl": BirdProfile(
            appearance: "雄は青く輝く首と、目玉模様のある長い飾り羽を扇状に広げます。",
            habitat: "インド周辺の林縁や農地を歩いて餌を探し、夜は木の上で休みます。",
            voice: "雨季には「ミャーオ」と聞こえる、非常に大きく遠くまで届く声で鳴きます。"
        ),
        "southern_screamer": BirdProfile(
            appearance: "灰色の大きな体と赤い顔・脚、細い冠羽、首の黒白の輪が特徴です。",
            habitat: "南米の沼や湖、湿地に暮らし、草や葉を食べ、翼の爪で身を守ります。",
            voice: "警笛のような大声が遠くまで響き、つがいで息を合わせて鳴くことがあります。"
        )
    ]
}
