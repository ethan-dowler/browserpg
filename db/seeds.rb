raise "Cannot run seeds more than once. Use db:seed:replant to start over." if DungeonTemplate.exists?

DungeonTemplate.create!(
  name: "Dungeon One",
  description: "The very first dungeon"
)

Dir[Rails.root.join("db", "seeds", "**", "*.rb")].each { load _1 }

# TODO: allow player to "buy" starting equipment
# start each character with one of each equipment item
Character.find_each do |character|
  Item.equipment.find_each do |item|
    AddInventoryItem.new(owner: character, item:).execute
  end
end
