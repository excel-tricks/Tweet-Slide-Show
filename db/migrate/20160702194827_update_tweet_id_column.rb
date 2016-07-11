class UpdateTweetIdColumn < ActiveRecord::Migration
  def up
    drop_table :tweets
    create_table :tweets do |t|
      t.string :author 
      t.string :tweet_id
    end
  end

  def down
  end
end
