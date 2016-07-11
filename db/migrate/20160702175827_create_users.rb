class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :name
      t.string :screen_name
      t.integer :id
      t.string :url
      t.integer :oldest_tweet
      t.integer :newest_tweet
    end
  end

  def down
    drop_table :users
  end
end
