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
    
    add_column :organizations, :user_id, :integer
    add_column :organizations, :visibility, :integer
    
    Organization.all.each do |org|
      org.user = User.create!({
        email: org.email,
        name: org.contact,
        password: SecureRandom.base64(12)
      })
      org.visibility = Organization::Visibility::PUBLIC
      org.save!
    end
    
    remove_column :organizations, :email, :string
    remove_column :organizations, :password, :string
    remove_column :organizations, :reset_token, :string 
    remove_column :organizations, :contact, :string
    remove_column :organizations, :settings, :string
    
  end
end
