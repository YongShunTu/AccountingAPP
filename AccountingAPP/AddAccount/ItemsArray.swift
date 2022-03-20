//
//  ItemsArray.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/2/13.
//

let incomeCategoryItems: [String] = [
    "收入",
    "投資收入",
    "其他收入"
]

let incomeSubTypeItems: [String: [String]] = [
    "收入" : ["當天營收"],
    "投資收入" : ["股利股息收入", "基金", "房地產", "銀行利息收入"],
    "其他收入" : ["禮金", "其他"]
]

let expenditureCategoryItems: [String] = [
    "食材",
    "人力",
    "房租水電",
    "廣告",
    "雜費",
    "餐具",
    "稅金"
]

let expenditureSubTypeItems: [String: [String]] = [
    "食材" : ["蔬菜", "雞肉", "鮭魚", "鮪魚", "旗魚", "紅甘", "蝦子", "黑豆", "海菜", "蝦卵", "蟹肉", "冷凍蔬菜", "南北貨", "蛋", "醬料", "米", "泡菜"],
    "人力" : ["員工薪水", "勞健保"],
    "房租水電" : ["房租", "水電"],
    "廣告" : ["FaceBook", "DM", "貼紙"],
    "雜費" : ["網路費", "電話費", "瓦斯費", "轉帳手續費", "提款手續費", "垃圾袋", "耐熱袋", "手套", "感熱紙", "衛生紙", "瓦斯", "其它"],
    "餐具" : ["紙碗", "紙碗蓋", "湯碗", "湯碗蓋", "叉子", "背心袋"],
    "稅金" : ["營業稅"]
]

let incomeProjectItems: [String] = [
    "無",
    "FoodPanda-30%",
    "Uber-34%"
]

let incomeProjectBankItems: [String: String] = [
    "無" : "店現金",
    "FoodPanda-30%" : "中國信託",
    "Uber-34%" : "國泰世華"
]

let bankItems: [String] = [
"店現金",
"中國信託",
"國泰世華"
]


