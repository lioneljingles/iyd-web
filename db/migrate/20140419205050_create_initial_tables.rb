class CreateInitialTables < ActiveRecord::Migration
  
  def change
    create_table :organizations do |t|
      t.integer :state, default: 1, null: false
      t.string :slug, null: false
      t.string :email, null: false
      t.string :password
      t.string :reset_token
      t.string :name, null: false
      t.text :summary, null: false
      t.text :description
      t.string :website
      t.string :contact
      t.string :phone
      t.string :address_1
      t.string :address_2
      t.string :district, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip
      t.string :settings, null: false
      t.timestamps
    end
    
    add_index :organizations, :slug,  unique: true
    add_index :organizations, :name, unique: true
    
    create_table :tags do |t|
      t.string :name, null: false
    end
    
    add_index :tags, :name
    
    create_table :organizations_tags do |t|
      t.belongs_to :organization
      t.belongs_to :tag
    end
    
    add_index :organizations_tags, [:organization_id, :tag_id], :unique => true
    add_index :organizations_tags, :tag_id
    
    create_table :images do |t|
      t.belongs_to :organization
      t.timestamps
    end
    
    add_attachment :images, :image
  end
  
end