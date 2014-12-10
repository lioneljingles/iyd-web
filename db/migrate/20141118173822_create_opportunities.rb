class CreateOpportunities < ActiveRecord::Migration
  def change
    create_table :opportunities do |t|
      t.integer :visibility, default: 0, null: false
      t.integer :position, default: 0, null: false
      t.integer :organization_id
      t.string :title
      t.string :description
      t.datetime :start_date
      t.datetime :end_date
      t.timestamps
    end
  end
end
