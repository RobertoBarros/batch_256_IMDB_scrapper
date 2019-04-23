require 'open-uri'
require 'nokogiri'

def fetch_top_movie_urls
  top_movies_url = 'https://www.imdb.com/chart/top'
  html_file = open(top_movies_url).read
  html_doc = Nokogiri::HTML(html_file)
  links = []
  html_doc.search('.titleColumn a').each do |link|
    links << "https://www.imdb.com#{link.attribute('href').value}"
  end
  return links.first(5)
end

def scrape_movie(url)
  html_file = open(url, "Accept-Language" => "en").read
  html_doc = Nokogiri::HTML(html_file)

  title_year = html_doc.search('h1').text.strip.match /(?<title>.+).\((?<year>\d{4})\)$/

  director = html_doc.search('.credit_summary_item').first.text.gsub(/Director:/,'').strip

  cast = html_doc.search('.credit_summary_item')[2].search('a').map(&:text).first(3)

  {
    title: title_year[:title],
    year: title_year[:year].to_i,
    storyline: html_doc.search('.summary_text').text.strip,
    director: director,
    cast: cast
  }
end

