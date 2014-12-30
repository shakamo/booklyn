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

@content = Category.find_or_initialize_by(id: 11)
@content.category_code = "11" 
@content.category_name = "ドラマ"
@content.save

@content = Category.find_or_initialize_by(id: 90)
@content.category_code = "90" 
@content.category_name = "その他"
@content.save

@content = Category.find_or_initialize_by(id: 99)
@content.category_code = "99" 
@content.category_name = "未分類"
@content.save

@schedule = Schedule.find_or_initialize_by(schedule_code: "80")
@schedule.schedule_name = "Every"
@schedule.save

@schedule = Schedule.find_or_initialize_by(schedule_code: "81")
@schedule.schedule_name = "Sun"
@schedule.save

@schedule = Schedule.find_or_initialize_by(schedule_code: "82")
@schedule.schedule_name = "Mon"
@schedule.save

@schedule = Schedule.find_or_initialize_by(schedule_code: "83")
@schedule.schedule_name = "Tue"
@schedule.save

@schedule = Schedule.find_or_initialize_by(schedule_code: "84")
@schedule.schedule_name = "Wed"
@schedule.save

@schedule = Schedule.find_or_initialize_by(schedule_code: "85")
@schedule.schedule_name = "Thu"
@schedule.save

@schedule = Schedule.find_or_initialize_by(schedule_code: "86")
@schedule.schedule_name = "Fri"
@schedule.save

@schedule = Schedule.find_or_initialize_by(schedule_code: "87")
@schedule.schedule_name = "Sat"
@schedule.save

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

