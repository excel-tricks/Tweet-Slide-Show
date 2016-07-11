class RefactorTweetTable < ActiveRecord::Migration
  def up
    drop_table :tweets
    create_table :tweets do |t|
      t.string :author_screen_name
      t.string :text
      t.string :date 
      t.integer :favorite_count
      t.integer :retweet_count
    end
  end

  def down
  end
end
