require 'json'
require 'date'


#methods

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

def create_report # start report generation
  sales_report_header #we didnt cover the gems section yet
  print_date
  products_header #we didnt cover the gems section yet
  parse_products #pulls out names/ites in string and re-assigns
  #brands_report_header  #pulls out names/ites in string and re-assigns
  #parse_brands
end

def sales_report_header # Print "Sales Report" in ascii art
  $report_file.puts "  #####                                 ######                            "
  $report_file.puts " #     #   ##   #      ######  ####     #     # ###### #####   ####  #####  #####"
  $report_file.puts " #        #  #  #      #      #         #     # #      #    # #    # #    #   # "
  $report_file.puts "  #####  #    # #      #####   ####     ######  #####  #    # #    # #    #   # "
  $report_file.puts "       # ###### #      #           #    #   #   #      #####  #    # #####    #"
  $report_file.puts " #     # #    # #      #      #    #    #    #  #      #      #    # #   #    #  "
  $report_file.puts "  #####  #    # ###### ######  ####     #     # ###### #       ####  #    #   # "
  star_string_divider
end

def star_string_divider
  $report_file.puts "********************************************************************************"
end

# def print_date # Print today's date
  #time = Time.new
  #$report_file.puts time.strftime("Current date: %m/%d/%Y")
#end

def products_header # Print "Products" in ascii art
  $report_file.puts "                     _            _       "
  $report_file.puts "                    | |          | |      "
  $report_file.puts " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
  $report_file.puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
  $report_file.puts "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
  $report_file.puts "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
  $report_file.puts "| |                                       "
  $report_file.puts "|_|                                       "
  star_string_divider
end

def parse_products
  $products_hash["items"].each do |toy| # For each product in the data set:
    print_item_data(toy)
    star_string_divider
  end
end

def print_item_data(toy)
  $report_file.puts "Toy title: #{toy["title"]}" # Print the name of the toy
  $report_file.puts "Retail price: #{toy["full-price"]}" # Print the retail price of the toy
  $report_file.puts "Total number of purchases: #{toy["purchases"].length}"   # Calculate and print the total number of purchases
  $report_file.puts "Total sales: #{total_sales_products(toy)}" # Calculate and print the total amount of sales
  $report_file.puts "Average price: #{total_sales_products(toy)/toy["purchases"].length}" # Calculate and print the average price the toy sold for
  $report_file.puts "Average discount: #{toy["full-price"].to_f-(total_sales_products(toy)/toy["purchases"].length)}" # Calculate and print the average discount (% or $) based off the average sales price
end

def total_sales_products(toy)
  total_sales = 0
  toy["purchases"].each { |purchase| total_sales = total_sales + purchase["price"]}
  return total_sales
end

# Print "Brands" in ascii art
# For each brand in the data set:
# Print the name of the brand
# Calculate and print the total sales volume of all the brand's toys combined
# Calculate and print the total sales volume of all the brand's toys 
# Calculate and print the average price of the brand's toys
# Count and print the number of the brand's toys we stock
  

#start



