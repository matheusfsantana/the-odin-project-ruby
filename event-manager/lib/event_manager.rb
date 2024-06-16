require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'
require 'time'

puts "Event Manager Initialized!", "\n"

small_sample = 'event_attendees.csv'

def calculate_most_frequent_weekday(datetime_array)
  hash_days = Hash.new(0)
  datetime_array.each do |date_hour|
    time_obj = Time.strptime(date_hour, '%m/%d/%y %H:%M')
    weekday = time_obj.strftime('%A')
    hash_days[weekday] += 1
  end
  max_value = hash_days.values.max
  hash_days.select { |_key, value| value == max_value }.keys
end

def print_most_frequent_weekday(weekdays)
  if weekdays.length == 1
    puts "The most frequent weekday is #{weekdays.first}"
  else
    puts "The most frequent weekdays is #{weekdays.join(' and ')}"
  end
end

def calculate_most_frequent_hour(datetime_array)
  hash_hours = Hash.new(0)
  datetime_array.each do |date_hour|
    hour = Time.strptime(date_hour, '%m/%d/%y %H:%M').hour
    hash_hours[hour] += 1
  end
  max_value = hash_hours.values.max
  hash_hours.select { |_key, value| value == max_value }.keys
end

def print_most_frequent_hour(hours)
  if hours.length == 1
    puts "The most frequent registration hour is #{hours.first}"
  else
    puts "The most frequent registration hours is #{hours.join('h and ')}h"
  end
end

def clean_phone_number(phone_number)
  phone_number.gsub!(/\D/, '')
  if phone_number.length == 10
    phone_number
  elsif phone_number.length == 11 && phone_number.start_with?('1')
    phone_number[1..10]
  else
    'Bad phone number'
  end
end

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    civic_info.representative_info_by_address(address: zip, levels: 'country',
                                              roles: %w[legislatorUpperBody legislatorLowerBody]).officials
  rescue StandardError
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id, form_letter)
  FileUtils.mkdir_p('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

if File.exist? small_sample
  contents = CSV.open(
    small_sample,
    headers: true,
    header_converters: :symbol
  )

  # template_letter = File.read('form_letter.erb')
  # erb_template = ERB.new template_letter
  datetime_array = []

  contents.each do |row|
    # id = row[0]
    name = row[:first_name]

    zipcode = clean_zipcode(row[:zipcode])

    homephone = clean_phone_number(row[:homephone])

    # legislators = legislators_by_zipcode(zipcode)

    datetime_array << row[:regdate]

    # form_letter = erb_template.result(binding)

    # save_thank_you_letter(id,form_letter)

    puts "#{name} - Zipcode: #{zipcode} - Homephone: #{homephone}"
  end

  print_most_frequent_hour(calculate_most_frequent_hour(datetime_array))
  print_most_frequent_weekday(calculate_most_frequent_weekday(datetime_array))
else
  puts "#{small_sample} file not found!"
end
