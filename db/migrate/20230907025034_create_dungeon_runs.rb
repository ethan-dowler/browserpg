class CreateDungeonRuns < ActiveRecord::Migration[7.0]
  def change
    create_table :dungeon_runs do |t|
      t.references :character, null: false
      t.references :dungeon, null: false
      t.references :current_room, foreign_key: { to_table: :rooms }, null: false

      t.datetime :completed_at
      t.string :completed_reason

      t.timestamps
    end
  end
end