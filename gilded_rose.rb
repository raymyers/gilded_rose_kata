
def is_backstage_pass?(item)
  item.name == 'Backstage passes to a TAFKAL80ETC concert'
end

def is_brie?(item)
  item.name == 'Aged Brie'
end

def item_legendary?(item)
  item.name == 'Sulfuras, Hand of Ragnaros'
end

def item_degrades?(item)
  !item_legendary?(item) && !is_brie?(item) && !is_backstage_pass?(item)
end

def item_appreciates?(item)
  !item_degrades?(item) && !item_legendary?(item)
end

def degrade_item(item)
  amount = 1
  if item.name.start_with?('Conjured')
    amount *= 2
  end
  if item.sell_in < 0
    amount *= 2
  end
  item.quality -= amount
  item.quality = 0 if item.quality < 0
end

def appreciate_backstage_pass(item)
  if item.sell_in < 0
    item.quality = 0
  elsif item.sell_in < 5
    item.quality += 3
  elsif item.sell_in < 10
    item.quality += 2
  else
    item.quality += 1
  end
end

def appreciate_item(item)
  if is_backstage_pass?(item)
   appreciate_backstage_pass(item)
  elsif is_brie?(item) && item.sell_in < 0
    item.quality += 2
  else
    item.quality += 1
  end
  item.quality = 50 if item.quality > 50
end

def update_quality(items)
  items.each do |item|
    item.sell_in -= 1 unless item_legendary?(item)
    degrade_item(item) if item_degrades?(item)
    appreciate_item(item) if item_appreciates?(item)
  end
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

