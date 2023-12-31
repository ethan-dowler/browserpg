# must implement base_hp and current_hp
# may implement max_hp
module HasHp
  extend ActiveSupport::Concern

  included do
    before_validation :set_current_hp, on: :create
    before_validation :enforce_hp_boundaries

    scope :alive, -> { where(current_hp: 1..) }
    scope :defeated, -> { where(current_hp: 0) }
  end

  def max_hp = base_hp

  def alive? = current_hp.positive?
  def defeated? = current_hp.zero?

  private

  def set_current_hp
    self.current_hp = base_hp
  end

  def enforce_hp_boundaries
    self.current_hp = 0 if current_hp.negative?
    self.current_hp = max_hp if current_hp > max_hp
  end
end
