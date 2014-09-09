# encoding: UTF-8

@content = Category.find_or_initialize_by(id: 1)
@content.category_code = "01" 
@content.category_name = "テレビアニメ"
@content.save

@content = Category.find_or_initialize_by(id: 2)
@content.category_code = "02" 
@content.category_name = "アニメ映画"
@content.save

@content = Category.find_or_initialize_by(id: 3)
@content.category_code = "03" 
@content.category_name = "OVA"
@content.save

@content = Category.find_or_initialize_by(id: 4)
@content.category_code = "04" 
@content.category_name = "Webアニメ"
@content.save

@content = Category.find_or_initialize_by(id: 5)
@content.category_code = "05" 
@content.category_name = "OAD"
@content.save

@content = Category.find_or_initialize_by(id: 90)
@content.category_code = "90" 
@content.category_name = "その他"
@content.save

@content = Category.find_or_initialize_by(id: 99)
@content.category_code = "99" 
@content.category_name = "未分類"
@content.save

@schedule = Schedule.find_or_initialize_by(schedule_code: "90")
@schedule.schedule_name = "Decided"
@schedule.save

@schedule = Schedule.find_or_initialize_by(schedule_code: "99")
@schedule.schedule_name = "Unknown"
@schedule.save

@schedule = ContentsHolder.find_or_initialize_by(contents_holder_code: "01")
@schedule.contents_holder_name = "ひまわり動画"
@schedule.save

@schedule = ContentsHolder.find_or_initialize_by(contents_holder_code: "02")
@schedule.contents_holder_name = "B9DM"
@schedule.save

@schedule = ContentsHolder.find_or_initialize_by(contents_holder_code: "03")
@schedule.contents_holder_name = "Nosub"
@schedule.save

@schedule = ContentsHolder.find_or_initialize_by(contents_holder_code: "04")
@schedule.contents_holder_name = "Veoh"
@schedule.save

@schedule = ContentsHolder.find_or_initialize_by(contents_holder_code: "05")
@schedule.contents_holder_name = "SayMove"
@schedule.save

@schedule = ContentsHolder.find_or_initialize_by(contents_holder_code: "06")
@schedule.contents_holder_name = "Dailymotion"
@schedule.save

@schedule = Platform.find_or_initialize_by(platform_code: "1")
@schedule.platform_name = "All"
@schedule.save

@schedule = Platform.find_or_initialize_by(platform_code: "10")
@schedule.platform_name = "PC"
@schedule.save


# Category.destroy_all
# 
# Category.create(
# :category_code => "01",
# :category_name => "テレビアニメ"
# )
# Category.create(
# :category_code => "02",
# :category_name => "アニメ映画"
# )

