require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    scraped_students = []
    doc.css(".student-card").each do |data|
      name = data.css(".card-text-container").css(".student-name").text
      location = data.css(".card-text-container").css(".student-location").text
      profile_url = data.css('a').attribute('href').value
      s = {:name=>name, :location=>location, :profile_url=>profile_url}
      scraped_students << s
    end
    scraped_students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    doc.css(".vitals-container").each do |data|
      # the social ones are mixed (i know...shoot me now)
      twitter = data.css(".social-icon-container").css('a').attribute('href').value
      linkedin = data.ss(".social-icon-container").css('a')..attribute('href').value
      github = data.
      # blog = data. ???
      profile_quote = data.css(".vitals-text-container").css(".profile-quote").text
      bio = data.css(".details-container").css(".bio-block details-block").css(".bio-content content-holder").css(".title-holder").css(".description-holder").css('p').text
      s = {:twitter=>twitter, :linkedin=>linkedin, :github=>github, :blog=>blog, :profile_quote=>profile_quote, :bio=>bio}
    end
    s
  end
end
