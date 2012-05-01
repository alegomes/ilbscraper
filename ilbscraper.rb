require 'rubygems'
require 'capybara'
require 'capybara/dsl'

include Capybara::DSL

Capybara.default_driver = :selenium

if ARGV.length < 2
	puts 
	puts "Modo de uso: $ ruby ilbscraper.rb <usuario> <senha>"
	puts
	puts "e.g.         $ ruby ilbscraper.rb lula.silva dilma2010"
	puts
	exit
end

username=ARGV[0]
password=ARGV[1]

visit "http://www17.senado.gov.br/user/login"
fill_in 'username', :with => username
fill_in 'password', :with => password
click_button 'ok'

visit 'http://www17.senado.gov.br/discipline/index/id/4/discipline_id/201/group_id/2287'
sleep 3

select = find_by_id('select_content_id_nav')
select.text.split("\n").each_with_index do |p,i|
	filename = p.gsub(/^.(.*)/, "#{i}.#{$1}")
	puts "#{filename}"
	
	select p, :from => 'select_content_id_nav'
	sleep 5
	content = find_by_id('content-main-content')

	File.open("#{filename}.html", 'w') {|f| f.write(content.html) }
end

