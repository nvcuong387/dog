# frozen_string_literal: true

require 'rubygems'
require 'httparty'
require 'csv'

# This class defines the functions for using
class Dog
  def update_history_file(breed)
    history = { 'Breed' => breed, 'Modified Time' => Time.now.strftime('%d/%m/%Y %H:%M:%S') }
    json = File.read('updated_at.json')
    File.open('updated_at.json', 'w') do |f|
      f.puts JSON.pretty_generate(JSON.parse(json) << history)
    end
  end

  def get_image_from_api(breed)
    response = HTTParty.get("https://dog.ceo/api/breed/#{breed}/images/random")
    JSON.parse(response.body)
  end

  def write_log(breed, image)
    print breed
    print '  '
    puts image
  end
end

# Get breeds from input_breed.txt file
input = File.open('input_breed.txt').read
# Get image from API and write to csv file for each breed
CSV.open('breed_name.csv', 'wb') do |breed|
  breed << %w[Breed Image]
  input.each_line do |line|
    breed_name = line.gsub!("\n", '')
    dog = Dog.new
    image = dog.get_image_from_api(breed_name)['message']
    # Write breed name and image to csv breed_name.csv file
    breed << [breed_name, image]
    # Update history to updated_at.json file
    dog.update_history_file(breed_name)
    # Write log to the print
    dog.write_log(breed_name, image)
  end
end
