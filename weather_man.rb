# frozen_string_literal: true

require 'csv'

# Weather man class
class WeatherMan
	# months array
	@@months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']

	# constructor
	def initialize(option, date, location)
		@option = option
		@date = date
		@location = location
	end

	#start from here
	def start
		if @option == '-e'
			t_HLM
		elsif @option == '-a'
			average_HLM
		elsif @option == '-c'
			l2_HL
		elsif @option == '-c1'
			b_l1_HL
		else
			puts 'Wrong tag given'
			exit(true)
		end
	end

	# find Highest, lowest temperature and most humidity
	# example cmd input   ruby weather_man.rb -e 2006 Dubai_weather
  def t_HLM
		year, month = @date.split('/')
    if !month.nil?
			puts 'You cannot give month value with this option'
		else
			highest_t, lowest_t, most_h,date_of_highest_t,date_of_lowest_t,date_of_most_h,count = 0,999,0,'0','0','0',0
			begin
			files_arr = Dir.children(@location)
			files_arr.each do |file_name|
				if file_name.include? year
					count += 1
					file = @location + '/' + file_name

						contents = CSV.open file, headers: true, header_converters: :symbol
						contents.each do |row|
							if highest_t < (row[:max_temperaturec] == nil ? 0 : row[:max_temperaturec].to_i)
								highest_t = row[:max_temperaturec].to_i
								date_of_highest_t = row[0]
							end
							if lowest_t > (row[:min_temperaturec] == nil ? 0 : row[:min_temperaturec].to_i)
								lowest_t = row[:min_temperaturec].to_i
								date_of_lowest_t = row[0]

							end
							if most_h < (row[:mean_humidity] == nil ? 0 : row[:mean_humidity].to_i)
								most_h = row[:mean_humidity].to_i
								date_of_most_h = row[0]
							end
						end

				# 	puts "No record found for #{@year} "
				end
			end
			rescue
						puts 'Error occurred while opening the file. Please try again!'
			end
				if count > 0
			puts "Highest: #{highest_t}C on #{@@months[date_of_highest_t.split('-')[1].to_i-1]} #{date_of_highest_t.split('-')[2]}"
			puts "Lowest: #{lowest_t}C on #{@@months[date_of_lowest_t.split('-')[1].to_i-1]} #{date_of_lowest_t.split('-')[2]}"
			puts "Humid: #{most_h}% on #{@@months[date_of_most_h.split('-')[1].to_i-1]} #{date_of_most_h.split('-')[2]}"
		else
			puts "No file found for  Year #{@date}"
		end
		end
	end

	# average
	def average_HLM
		year, month = @date.split('/')
		if !month.nil?
			if @@months.include?@@months[month.to_i-1]
				file = @location + '/' + @location + '_' + year + '_' + @@months[month.to_i - 1] + '.txt'
				if !File.exist?(file)
					puts 'No file exists for_ this year or month'
					exit(true)
				else
					total_highest_t, total_lowest_t, total_most_h, avg_h_t, avg_l_t, avg_most_h,count = 0,0,0,0,0,0,0
					begin
						contents = CSV.open file, headers: true, header_converters: :symbol
						contents.each do |row|
							count += 1
							total_highest_t += row[:max_temperaturec]==nil ? 0 : row[:max_temperaturec].to_i
							total_lowest_t += row[:min_temperaturec].to_i
							total_most_h += row[:max_humidity].to_i
						end
						puts "Highest Average: #{total_highest_t/count}C"
						puts "Lowest Average: #{total_lowest_t/count}C"
						puts "Average Humidity: #{total_most_h/count}%"
					rescue
						puts 'Error occurred wile opening the file,Please try again!'
					end
				end
			else
				puts 'Month value not given right'
			end
		else
			puts 'Add month for this option'
		end
	end


	def l2_HL
		year, month = @date.split('/')
		if !month.nil?
			if @@months.include? @@months[month.to_i - 1]
				file = @location + '/' + @location + '_' + year + '_' + @@months[month.to_i - 1] + '.txt'
				if !File.exist?(file)
					puts 'No file exists for_ this year or month'
					exit(true)
				else
					puts "#{@@months[@month.to_i - 1]} #{year}"
					begin
						contents = CSV.open file, headers: true, header_converters: :symbol
						contents.each do |row|
							max_t = row[:max_temperaturec] == nil ? 0 : row[:max_temperaturec].to_i
							min_t = row[:min_temperaturec] == nil ? 0 : row[:min_temperaturec].to_i

							puts "#{row[0].split('-')[2]} #{'+' * max_t}	#{max_t}C"
							puts "#{row[0].split('-')[2]} #{'-' * min_t} #{min_t}C"
						end
					rescue
						puts 'Error occurred wile opening the file,Please try again!'
					end
				end
			else
				puts 'Month value not given right'
			end
		else
			puts 'Add month for this option'
		end
	end

	def b_l1_HL
		year, month = @date.split('/')
		if !month.nil?
			if @@months.include? @@months[month.to_i - 1]
				file = @location + '/' + @location + '_' + year + '_' + @@months[month.to_i - 1] + '.txt'
				if !File.exist?(file)
					puts 'No file exists for_ this year or month'
					exit(true)
				else
					puts "#{@@months[@month.to_i - 1]} #{year}"
					begin
						contents = CSV.open file, headers: true, header_converters: :symbol
						contents.each do |row|
							max_t = row[:max_temperaturec] == nil ? 0 : row[:max_temperaturec].to_i
							min_t = row[:min_temperaturec] == nil ? 0 : row[:min_temperaturec].to_i
							puts "#{row[0].split('-')[2]} #{'+' * max_t}#{'-' * min_t}	#{max_t}C-#{min_t}C"
						end
					rescue
						puts 'Error occurred wile opening the file,Please try again!'
					end
				end
			else
				puts 'Month value not given right'
			end
		else
			puts 'Add month for this option'
		end
	end
end

if ARGV.length != 3
	puts 'there should be 3 arguments'
	exit(true)
end

option = ARGV[0]
date = ARGV[1]
location = ARGV[2]

obj = WeatherMan.new(option, date, location)
obj.start
