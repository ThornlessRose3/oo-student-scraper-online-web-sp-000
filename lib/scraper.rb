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
    twitter = ""
    linkedin = ""
    github = ""
    blog = ""
    profile_quote = ""
    bio = ""
    doc.each do |data|
      # the social ones are mixed - grab all URLs
      social_urls = data.css(".vitals-container").css(".social-icon-container").search('a').map{ |tag|
        case tag.name.downcase
        when 'a'
            tag['href']
        end
      }
      
      while social_urls.length > 0
          find_url = social_urls.shift
          if find_url.include?("twitter")
            twitter = find_url
          elsif find_url.include?("linkedin")
            linkedin = find_url
          elsif find_url.include?("github")
            github = find_url
          else
            blog = find_url
          end
        end
      profile_quote = data.css(".vitals-container").css(".vitals-text-container").css(".profile-quote").text
      bio = data.css(".details-container").css(".bio-block details-block").css(".bio-content content-holder").css(".description-holder").css('p').text
    end
    student_hash = {:twitter=>twitter, :linkedin=>linkedin, :github=>github, :blog=>blog, :profile_quote=>profile_quote, :bio=>bio}
    student_hash
    
   end
end
