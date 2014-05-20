class CreateUsersTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :role, default: 0, null: false
      t.string :email, null: false
      t.string :password
      t.string :reset_token
      t.string :name, null: false
      t.string :settings, null: false
      t.timestamps
    end
    
    
    Organization.all.each{|org| org.destroy}
    
    add_column :organizations, :user_id, :integer
    add_column :organizations, :visibility, :integer
    remove_column :organizations, :email, :string
    remove_column :organizations, :password, :string
    remove_column :organizations, :reset_token, :string 
    remove_column :organizations, :contact, :string
    remove_column :organizations, :settings, :string
    
  end
end
