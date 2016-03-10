require 'json'
require 'date'
require 'artii'
# methods go here

def start
  setup_files # load, read, parse, and create the files
  create_report # create the report!
end

def setup_files #method to open the JSON file and parse the data
    path = File.join(File.dirname(__FILE__), '../data/products.json')
    file = File.read(path)
    $products_hash = JSON.parse(file)
    $report_file = File.new("report.txt", "w+")
end

def create_report # start report generation, this is also the order they appear in report.txt
  artii_report
  artii_products
  parse_products
  artii_brands
  parse_brands
end

def artii_report 
    a = Artii::Base.new :font => 'slant'
    $report_file.puts a.asciify("Sales Report")
    $report_file.puts "*" * 11 + Date.today.strftime('%a %d %b %Y') + "*" * 11
end


def section_divider
  $report_file.puts "*" * 40
end


def artii_products
    a = Artii::Base.new :font => 'slant'
    $report_file.puts a.asciify("Products")
end


def parse_products
  $products_hash["items"].each do |toy| # For each product in the data set:
    print_item_data(toy)
    section_divider
  end
end

def print_item_data(toy)
  $report_file.puts "Toy title: #{toy["title"]}" # Print the name of the toy
  $report_file.puts "Retail price: #{toy["full-price"]}" # Print the retail price of the toy
  $report_file.puts "Total number of purchases: #{toy["purchases"].length}"   # Calculate and print the total number of purchases
  $report_file.puts "Total sales: #{calc_total_sales_products(toy)}" # Calculate and print the total amount of sales
  $report_file.puts "Average price: #{calc_total_sales_products(toy)/toy["purchases"].length}" # Calculate and print the average price the toy sold for
  $report_file.puts "Average discount: #{toy["full-price"].to_f-(calc_total_sales_products(toy)/toy["purchases"].length)}" # Calculate and print the average discount (% or $) based off the average sales price
end

def calc_total_sales_products(toy)
  total_sales = 0
  toy["purchases"].each { |purchase| total_sales = total_sales + purchase["price"]}
  return total_sales
end

def artii_brands
    a = Artii::Base.new :font => 'slant'
    $report_file.puts a.asciify("Brands")
end


def parse_brands # For each brand in the data set:
  unique_brands = $products_hash["items"].map { |item| item["brand"] }.uniq
  unique_brands.each_with_index do | brand, index |
    print_brands(brand)
  end
end

def brands_items(brand)
  brands_items = $products_hash["items"].select { |item| item["brand"] == brand }
  return brands_items
end

def print_brands(brand)
  $report_file.puts "Brand: #{brand}" # Print the name of the brand
end
  
 # Calculate and print the total sales volume of all the brand's toys combined
 
 # Calculate and print the average price of the brand's toys

 # Count and print the number of the brand's toys we stock



start
