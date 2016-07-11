require 'sinatra'
require 'sinatra/activerecord'
require 'twitter'
require './config/environments' #database configuration
require './models/tweet'
require './models/user'
require 'date'

# set :database_file, "config/database.yml"

get '/' do
  erb :index
end

get '/newTweet' do 
  # returnHash = {source: 'Bubba', message: 'Howdy y\'all!'}
  # returnHash.to_json
  tweet = Tweet.getRandomTweet
  user = User.where(screen_name: tweet.author_screen_name.downcase).first

  date = DateTime.parse(tweet.date)
  puts "Tweet ID: #{tweet.id}"

  tweetHash = {author_screen_name: tweet.author_screen_name,
               text: tweet.text,
               date: date.strftime('%I:%M %p - %d %b %Y'),
               favorite_count: tweet.favorite_count.to_s,
               retweet_count: tweet.retweet_count.to_s,
               tweet_id: tweet.id,
               author_name: user.name,
               profile_image_uri: user.profile_image_uri.to_s}
  tweetHash.to_json
end

post '/deleteTweet' do 
  Tweet.delete(params[:tweet_id])
  return "Tweet deleted!"
end