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

@content = Category.find_or_initialize_by(id: 90)
@content.category_code = "90" 
@content.category_name = "その他"
@content.save

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

