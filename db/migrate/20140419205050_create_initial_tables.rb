class CreateInitialTables < ActiveRecord::Migration
  
  def change
    create_table :organizations do |t|
      t.string :slug, null: false
      t.string :email, null: false
      t.string :password
      t.string :reset_token
      t.string :name, null: false
      t.string :contact_name
      t.string :phone
      t.text :summary, null: false
      t.text :description
      t.string :website
      t.string :district, null: false
      t.string :city, null: false
      t.string :images, null: false
      t.string :settings, null: false
      t.timestamps
    end
    
    add_index :organizations, :slug, :unique => true
    add_index :organizations, :name, :unique => true
    
    create_table :labels do |t|
      t.string :name, null: false
    end
    
    add_index :labels, :name
    
    create_table :labels_organizations do |t|
      t.belongs_to :organization
      t.belongs_to :label
    end
    
    add_index :labels_organizations, [:label_id, :organization_id], :unique => true
    add_index :labels_organizations, :organization_id
    
  end
end