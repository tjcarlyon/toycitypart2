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

def create_report # start report generation for report.txt
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
   $report_file.puts "Total purchases: #{toy["purchases"].length}"   # Calculate and print the total number of purchases
   $report_file.puts "Total sales: #{calc_total_sales(toy)}" # Calculate and print the total amount of sales
   $report_file.puts "Average price: #{calc_total_sales(toy)/toy["purchases"].length}" # Calculate and print the average price the toy sold for
   $report_file.puts "Average discount: #{toy["full-price"].to_f-(calc_total_sales(toy)/toy["purchases"].length)}" # Calculate and print the average discount (% or $) based off the average sales price
end

def calc_total_sales(toy)
   total_sales = 0
   toy["purchases"].each { |purchase| total_sales = total_sales + purchase["price"]}
   total_sales #When you leave out the return statement, the method is said to have an implicit return value.
   #When the line of code that you are returning is the last line of the method, you can leave out the return statement altogether!
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
   brands_items #When you leave out the return statement, the method is said to have an implicit return value.
   #When the line of code that you are returning is the last line of the method, you can leave out the return statement altogether!
end

def print_brands(brand)
   $report_file.puts "Brand: #{brand}" # Print the name of the brand


  total_stock_brand(brand)
  brand_average_price(brand)
  brand_sales(brand)
  section_divider
end

# Calculate and print the total sales volume of all the brand's toys combined
def brand_sales(brand)  
   brand_sales = 0                     
   brands_items(brand).each do |item|
   item["purchases"].each do |count|
   brand_sales += count["price"].to_f
      end
  end
  $report_file.puts "Total sales #{brand}: #{brand_sales.round(2)}"  # Calculate and print the total sales volume of all the brand's toys combined
end

 # Calculate and print the average price of the brand's toys
 def brand_average_price(brand) 
    full_price_brand = 0                                
    brands_items(brand).each do |toy|                                  
    full_price_brand += toy["full-price"].to_f                          
  end                                 
  $report_file.puts "Average price #{brand}: #{(full_price_brand/brands_items(brand).length).round(2)}" 
end

 # Count and print the number of the brand's toys we stock
 def total_stock_brand(brand) 
   total_stock_brand = 0             
   brands_items(brand).each do |toy|    
   total_stock_brand += toy["stock"].to_i
  end               
  $report_file.puts "#{brand} in stock: #{total_stock_brand}"  
  
end
start
