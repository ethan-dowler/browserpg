class Monster < ApplicationRecord
  include Conditionable
  include Modifiable
  include HasHp

  belongs_to :monster_template
  has_many :drops, through: :monster_template

  has_many :inventory_items, as: :owner, dependent: :destroy

  belongs_to :current_room, class_name: "Room"
  has_one :dungeon, through: :current_room

  delegate_missing_to :monster_template

  after_create :add_inventory

  # STATS - TODO: DRY this up b/t mosnter & character
  def max_hp = total(:hp)
  def attack = total(:attack)
  def defense = total(:defense)
  def speed = total(:speed)
  def spirit = total(:spirit)
  def wisdom = total(:wisdom)

  private

  # for each possible drop, roll to see if that drop appears
  # then equip that item if possible
  def add_inventory
    drops.each do |drop|
      next unless Random.new.rand(100) < drop.percent_chance

      inventory_item = inventory_items.create!(item: drop.item, quantity: drop.quantity)
      EquipInventoryItem.new(inventory_item).execute if inventory_item.equippable?
    end
  end
end
