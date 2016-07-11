class UpdateUsersTable < ActiveRecord::Migration
  def up
    drop_table :users
    create_table :users do |t|
      t.string :name
      t.string :screen_name
      t.string :url
      t.string :oldest_tweet
      t.string :newest_tweet
    end
  end

  def down
  end
end
