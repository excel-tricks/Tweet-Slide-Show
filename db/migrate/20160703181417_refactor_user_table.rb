class RefactorUserTable < ActiveRecord::Migration
  def up
    drop_table :users
    create_table :users do |t|
      t.string :name 
      t.string :screen_name
      t.string :oldest_tweet
      t.string :newest_tweet
      t.string :profile_image_uri
    end
  end

  def down
    drop_table :users
  end
end
