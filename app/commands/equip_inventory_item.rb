class EquipInventoryItem
  attr_reader :new_inventory_item, :owner

  def initialize(new_inventory_item)
    @new_inventory_item = new_inventory_item
    @owner = new_inventory_item.owner
  end

  def execute
    return if new_inventory_item.equipped?

    InventoryItem.transaction do
      unequip_current_items
      unequip_secondary if new_inventory_item.two_handed?
      unequip_two_handed_primary if new_inventory_item.secondary?
      new_inventory_item.update!(equipped: true)
      check_max_hp
    end
  end

  private

  def unequip_current_items
    # may have multiple primaries equipped if dual-wielding
    current_items_in_slot = owner.inventory_items.with_same_slot(new_inventory_item).equipped
    return if current_items_in_slot.none?

    if current_items_in_slot.first.dual_wield? && new_inventory_item.dual_wield?
      # when equipping a second dual-wield weapon, remove the secondary item to "make room"
      unequip_secondary
    else
      current_items_in_slot.each { UnequipInventoryItem.new(_1).execute }
    end
  end

  def unequip_secondary
    # should never have more than one secondary equipped
    secondary_item =
      owner.inventory_items.secondary.equipped.first
    UnequipInventoryItem.new(secondary_item).execute if secondary_item.present?
  end

  def unequip_two_handed_primary
    two_handed_primary = owner.inventory_items.two_handed.equipped.first
    UnequipInventoryItem.new(two_handed_primary).execute if two_handed_primary.present?
  end

  def check_max_hp
    max_hp = owner.max_hp
    return if owner.current_hp <= max_hp

    owner.update!(current_hp: max_hp)
  end
end
