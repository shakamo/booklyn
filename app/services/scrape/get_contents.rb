require 'open-uri'
require 'nokogiri'

class Tasks::GetContents
  def self.execute(year, season)

    @pager = 0

    for i in 1..99 do
   		url = 'http://www.anikore.jp/chronicle/' + year + '/' + season +'/page:' + i.to_s
	    getContentsByPage(url)

	    if @pager == i.to_s then
	    	break
	    end
	end


p @pager
  end

  def self.getContentsByPage(url)
  	charset = nil
	html = open(url) do |f|
	  charset = f.charset # 文字種別を取得
	  f.read # htmlを読み込んで変数htmlに渡す
	end

	# htmlをパース(解析)してオブジェクトを生成
	doc = Nokogiri::HTML.parse(html, nil, charset)

	doc.css('#main > div.paginator > span').each do |node|
		if node.css('a.crpagebute').inner_text != "" then
			@pager = node.css('a.crpagebute').inner_text
		end
	end

    doc.xpath('//*[@id="main"]/div').each do |node|


    	if node.css('div[1]/span[2]/a').inner_text != "" then
    	  content_name = node.css('div[1]/span[2]/a').inner_text
          content_name.sub!("（テレビアニメ）","")
          content_name.sub!("（アニメ映画）","")
          content_name.sub!("（OVA）","")
          content_name.sub!("（Webアニメ）","")

          content_name.sub!("（その他）","")
          content_name.sub!("（その他）","")
          content_name.sub!("（その他）","")

    	  content_cd = node.css('div[1]/span[2]/a').attribute('href').value.split("/")[2]

    	  test = Content.new(:content_cd => content_cd, :content_name => content_name)
p test
        end
    end
  end
end

