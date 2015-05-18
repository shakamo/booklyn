# encoding: UTF-8

@content = Category.new
@content.category_code = '01'
@content.category_name = 'テレビアニメ'
@content.save

@content = Category.new
@content.category_code = '02'
@content.category_name = 'アニメ映画'
@content.save

@content = Category.new
@content.category_code = '03'
@content.category_name = 'OVA'
@content.save

@content = Category.new
@content.category_code = '04'
@content.category_name = 'Webアニメ'
@content.save

@content = Category.new
@content.category_code = '05'
@content.category_name = 'OAD'
@content.save

@content = Category.new
@content.category_code = '06'
@content.category_name = 'アニメ関連'
@content.save

@content = Category.new
@content.category_code = '10'
@content.category_name = '特撮'
@content.save

@content = Category.new
@content.category_code = '11'
@content.category_name = 'ドラマ'
@content.save

@content = Category.new
@content.category_code = '90'
@content.category_name = 'その他'
@content.save

@content = Category.new
@content.category_code = '99'
@content.category_name = '未分類'
@content.save

@schedule = Schedule.new
@schedule.schedule_code = '80'
@schedule.schedule_name = 'Every'
@schedule.save

@schedule = Schedule.new
@schedule.schedule_code = '81'
@schedule.schedule_name = 'Sun'
@schedule.week = 'Sun'
@schedule.save

@schedule = Schedule.new
@schedule.schedule_code = '82'
@schedule.schedule_name = 'Mon'
@schedule.week = 'Mon'
@schedule.save

@schedule = Schedule.new
@schedule.schedule_code = '83'
@schedule.schedule_name = 'Tue'
@schedule.week = 'Tue'
@schedule.save

@schedule = Schedule.new
@schedule.schedule_code = '84'
@schedule.schedule_name = 'Wed'
@schedule.week = 'Wed'
@schedule.save

@schedule = Schedule.new
@schedule.schedule_code = '85'
@schedule.schedule_name = 'Thu'
@schedule.week = 'Thu'
@schedule.save

@schedule = Schedule.new
@schedule.schedule_code = '86'
@schedule.schedule_name = 'Fri'
@schedule.week = 'Fri'
@schedule.save

@schedule = Schedule.new
@schedule.schedule_code = '87'
@schedule.schedule_name = 'Sat'
@schedule.week = 'Sat'
@schedule.save

@schedule = Schedule.new
@schedule.schedule_code = '90'
@schedule.schedule_name = 'Decided'
@schedule.save

@schedule = Schedule.new
@schedule.schedule_code = '99'
@schedule.schedule_name = 'Unknown'
@schedule.save

@schedule = ContentsHolder.new
@schedule.contents_holder_code = '01'
@schedule.contents_holder_name = 'ひまわり動画'
@schedule.save

@schedule = ContentsHolder.new
@schedule.contents_holder_code = '02'
@schedule.contents_holder_name = 'B9DM'
@schedule.save

@schedule = ContentsHolder.new
@schedule.contents_holder_code = '03'
@schedule.contents_holder_name = 'Nosub'
@schedule.save

@schedule = ContentsHolder.new
@schedule.contents_holder_code = '04'
@schedule.contents_holder_name = 'Veoh'
@schedule.save

@schedule = ContentsHolder.new
@schedule.contents_holder_code = '05'
@schedule.contents_holder_name = 'SayMove'
@schedule.save

@schedule = ContentsHolder.new
@schedule.contents_holder_code = '06'
@schedule.contents_holder_name = 'Dailymotion'
@schedule.save

@schedule = Platform.new
@schedule.platform_code = '01'
@schedule.platform_name = 'All'
@schedule.save

@schedule = Platform.new
@schedule.platform_code = '10'
@schedule.platform_name = 'PC'
@schedule.save
