class CreateTweetslideshow < ActiveRecord::Migration
  def up
    create_table :tweets do |t|
      t.string :author 
      t.string :tweet_id
    end
  end

  def down
    drop_table :tweets
  end
end


# {
#   "cache_age": "3153600000",
#   "url": "https://twitter.com/Interior/status/507185938620219395",
#   "provider_url": "https://twitter.com",
#   "provider_name": "Twitter",
#   "author_name": "US Dept of Interior",
#   "version": "1.0",
#   "author_url": "https://twitter.com/Interior",
#   "type": "rich",
#   "html": "<blockquote class=\"twitter-tweet\"><p>Happy 50th anniversary to the Wilderness Act! Here's a great wilderness photo from <a href=\"https://twitter.com/YosemiteNPS\">@YosemiteNPS</a>. <a href=\"https://twitter.com/hashtag/Wilderness50?src=hash\">#Wilderness50</a> <a href=\"http://t.co/HMhbyTg18X\">pic.twitter.com/HMhbyTg18X</a></p>— US Dept of Interior (@Interior) <a href=\"https://twitter.com/Interior/status/507185938620219395\">September 3, 2014</a></blockquote>\n<script async src=\"//platform.twitter.com/widgets.js\" charset=\"utf-8\"></script>",
#   "height": null,
#   "width": 550
# }