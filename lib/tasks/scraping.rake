=begin
Contentsを更新したら、contents.errorを確認する。

以下のエラーは放送日が設定されていない。
select * from contents where error like '%set_schedule_id%'

※ただし、何かしら放送日が設定されている場合（手で設定した場合）はスキップする。
=end
task :scrape_contents => :environment do
# Scrape::ScrapeForContents.execute("2013", "summer")
# Scrape::ScrapeForContents.execute("2013", "autumn")
# Scrape::ScrapeForContents.execute("2014", "winter")
# Scrape::ScrapeForContents.execute("2014", "spring")
  Scrape::ScrapeForContents.execute("2014", "summer")
  Scrape::ScrapeForContents.execute("2014", "autumn")
end

=begin
Youtube
Dailymotion
Nosub
1-1
Veoh
Anitan
FC2
Anime44
Saymove
ひまわり
1
ももいろ
Letv
56.com
RuTube
Anitube
B9

=end
task :scrape_episodes => :environment do
# url = 'http://tvanimedouga.blog93.fc2.com/archives.html'
 
  p '26'
  url = 'http://tvanimedouga.blog93.fc2.com/?all&p=26'
  Scrape::ScrapeForEpisodes.executeTvanimedouga(url)
  p '25'
  url = 'http://tvanimedouga.blog93.fc2.com/?all&p=25'
  Scrape::ScrapeForEpisodes.executeTvanimedouga(url)
  p '24'
  url = 'http://tvanimedouga.blog93.fc2.com/?all&p=24'
  Scrape::ScrapeForEpisodes.executeTvanimedouga(url)
  p '23'
  url = 'http://tvanimedouga.blog93.fc2.com/?all&p=23'
  Scrape::ScrapeForEpisodes.executeTvanimedouga(url)
  p '22'
  url = 'http://tvanimedouga.blog93.fc2.com/?all&p=22'
  Scrape::ScrapeForEpisodes.executeTvanimedouga(url)
  p '21'
  url = 'http://tvanimedouga.blog93.fc2.com/?all&p=21'
  Scrape::ScrapeForEpisodes.executeTvanimedouga(url)
  p '20'
  url = 'http://tvanimedouga.blog93.fc2.com/?all&p=20'
  Scrape::ScrapeForEpisodes.executeTvanimedouga(url)
end

task :scrape_new_episodes => :environment do
  url = 'http://tvanimedouga.blog93.fc2.com/?all&p=1'
  Scrape::ScrapeForEpisodes.executeTvanimedouga(url)
end

task :scrape_dailymotion => :environment do

  dailymotion =Scrape::Holders::Dailymotion.new
  dailymotion.execute_by_user('x1cbwok')

end
