require 'nokogiri'
require 'httparty'
require 'byebug'

def scrapper 

	page =1
	url = "https://blockwork.cc/listings?page=#{page}"
	unparsed_page = HTTParty.get(url)
	parsed_page = Nokogiri::HTML(unparsed_page)
	job_listings = parsed_page.css('div.listingCard')
	per_page = job_listings.count
	jobs = Array.new
	total = parsed_page.css('div.job-count').text.split(' ')[1].gsub(',','').to_i
	total_page = ((total/per_page)+0.5).round
	


	while page<=total_page
				
			url = "https://blockwork.cc/listings?page=#{page}"
			unparsed_page = HTTParty.get(url)
			parsed_page = Nokogiri::HTML(unparsed_page)
			job_listings = parsed_page.css('div.listingCard')
			job_listings.each do |joblisting|


			job ={
				 title: joblisting.css('span.job-title').text,
				company: joblisting.css('span.company').text,
				location: joblisting.css('span.location').text,
				url: "https://blockwork.cc"+joblisting.css('a')[0].attributes["href"].value

			}
			
			jobs<<job
			puts("added job #{job[:title]} location: #{job[:location]} url: #{job[:url]}")
			puts("\n")

		end
		puts("page #{page}")
		page += 1
	end	
byebug
	

end


scrapper