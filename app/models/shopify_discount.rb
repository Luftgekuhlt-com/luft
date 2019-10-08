class ShopifyDiscount
  
  
  def self.default_promos
    @@default_promos ||= begin
      promos = []
      promos << {code: "bronze_rider", name: "Bronze Rider Discount", type: "rider_discount", options: {discount: 10, type: "percent", user_tag: "bronze_rider"}}
      promos << {code: "silver_rider", name: "Silver Rider Discount", type: "rider_discount", options: {discount: 20, type: "percent", user_tag: "silver_rider"}}
      promos << {code: "btgt_jersey_hat", name: "Free Hat With Purchase of Moto Jersey", type: "btgt", options: {buy_this: {tag: "jerseys", qty: 1}, get_that: {tag: "hat", qty: 1, discount: 100, type: "percent"}, max_qty: 1}}
      promos
    end
  end
  
  def self.generate_script_content
    promos = self.default_promos
    promo_vars = []
    check_the_cart = []
    apply_discounts = []
    promos.each do |p|
      if p[:type] == "rider_discount"
        discount_amt = p[:options][:type] == "percent" ?  "(line_item.line_price * (#{p[:options][:discount]} / 100))" : "{p[:options][:discount]}"
        apply_discounts << "# #{p[:name]}\nif Input.cart.customer && Input.cart.customer.tags.map(&:downcase).include?('#{p[:options][:user_tag]}')\nline_item.change_line_price((line_item.line_price - #{discount_amt}), message: '#{p[:name]}') unless line_item.line_price_changed?\nend\n"
      elsif p[:type] == "btgt"
        promo_vars << "#{p[:code]}_buy_this = 0"
        promo_vars << "#{p[:code]}_get_that_line = nil"
        check_the_cart << "#{p[:code]}_buy_this += line_item.quantity if product.tags.map(&:downcase).include?('#{p[:options][:buy_this][:tag]}')"
        check_the_cart << "#{p[:code]}_get_that_line = line_item.variant.id product.product_type.downcase == '#{p[:options][:get_that][:tag]}' && #{p[:code]}_get_that_line.nil?"
        discount_amt = p[:options][:get_that][:type] == "percent" ?  "(line_item.line_price * (#{p[:options][:get_that][:discount]} / 100))" : "{p[:options][:get_that][:discount]}"
        btgt_discount = ["# #{p[:name]}"]
        btgt_discount << "if line_item.variant.id == #{p[:code]}_get_that_line && #{p[:code]}_buy_this >= #{p[:options][:buy_this][:qty]}"
        btgt_discount << "new_line_item = line_item"
        btgt_discount << "if line_item.quantity > #{p[:options][:max_qty]}\nnew_line_item = line_item.split(take: #{p[:options][:max_qty]})\nInput.cart.line_items << new_line_item\nend"
        btgt_discount << "new_line_item.change_line_price(new_line_item.line_price - #{discount_amt}, message: '#{p[:name]}')\n" 
        btgt_discount << "end"
        apply_discounts << btgt_discount.join("\n")
      end
    end
    script_lines = ["# Script generated #{Time.now.in_time_zone("Pacific Time (US & Canada)").to_s}\n"]
    script_lines += promo_vars
    script_lines << "\n#Check the cart\nInput.cart.line_items.each do |line_item|"
    script_lines << "product = line_item.variant.product"
    script_lines += check_the_cart
    script_lines << "end"
    script_lines << "\n#Apply Discounts\nInput.cart.line_items.each do |line_item|"
    script_lines << "product = line_item.variant.product\n"
    script_lines += apply_discounts
    script_lines << "end"
    script_lines << "\n########################\nOutput.cart = Input.cart"
    script_lines.join("\n")
  end
end