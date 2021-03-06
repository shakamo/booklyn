namespace :old do
  # Contentsを更新したら、contents.errorを確認する。
  #
  # 以下のエラーは放送日が設定されていない。
  # select * from contents where error like '%set_schedule_id%'
  #
  # ※ただし、何かしら放送日が設定されている場合（手で設定した場合）はスキップする。
  task scrape_contents: :environment do
    # Scrape::ScrapeForContents.execute("2014", "spring")
    # Scrape::ContentManager.createAll("Anikore", "2014", "summer")
    ImportContents.createAll('Anikore', '2014', 'autumn')
    # Scrape::ContentManager.createAll("Anikore", "2015", "winter")

    # Scrape::ContentManager.createAll('Rakuten', '', 'autumn')
    # Scrape::ContentManager.createAll('Rakuten', '', 'winter')
  end
  task scrape_contents_rakuten: :environment do
    ImportContents.createAll('Rakuten', '', 'autumn')
    ImportContents.createAll('Rakuten', '', 'winter')
  end

  # Youtube
  # Dailymotion
  # Nosub
  # 1-1
  # Veoh
  # Anitan
  # FC2
  # Anime44
  # Saymove
  # ひまわり
  # 1
  # ももいろ
  # Letv
  # 56.com
  # RuTube
  # Anitube
  # B9
  #
  task scrape_episodes: :environment do
    Scrape::EpisodeManager.update('tvanimedouga', 30)
  end

  task scrape_episodes_drama: :environment do
    Scrape::EpisodeManager.update('tvdramadouga', 10)
  end

  task scrape_episodes_all: :environment do
    Scrape::ScrapeForEpisodes.createAll('tvanimedouga')
  end

  task scrape_dailymotion: :environment do
    dailymotion = Scrape::Holders::Dailymotion.new
    dailymotion.execute_by_user('', 'x1cbwok')
  end

  task tfidf: :environment do
    Scrape::ContentManager.insert_tfidf
  end

  task get_idf: :environment do
    # puts Scrape::ContentManager.get_tfidf("劇場版 銀魂 完結篇 万事屋よ永遠なれ")
    puts Scrape::ContentManager.get_tfidf('第15話')
  end
end
