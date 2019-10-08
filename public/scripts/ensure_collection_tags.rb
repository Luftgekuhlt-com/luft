products = {}
ShopifyAPI::CustomCollection.find(:all, limit: 250).each do |collection|
next if ["coming soon", "cross-sell application","new arrivals", "what's new & cool"].include?(collection.title.downcase)
products[collection.title] = collection.products
end

bad_products = []
products.each do |c, cps|
cps.each do |p|
bad_products << {collection: c, product: p} unless p.tags.downcase.include?(c.downcase)
end
end

bad_products.each do |bp|
c = bp[:collection]
p = bp[:product]
tags = p.tags.split(",").map(&:strip)
unless tags.map(&:downcase).include?(c.downcase)
tags << c
p.tags = tags.join(", ")
p.save
end
end