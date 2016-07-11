require './app'
require 'sinatra/activerecord/rake'
require 'twitter'
require 'yaml'
require 'rake'
require './models/user.rb'
require './models/tweet.rb'

load 'config/twitter_config.rb'

Rake::Task.define_task(:environment)

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
  config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
  config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
end

def collect_with_max_id(collection=[], max_id=nil, &block)
  response = yield(max_id)
  collection += response
  response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
end

def client.get_all_tweets(user)
  collect_with_max_id do |max_id|
    options = {count: 200, include_rts: true}
    options[:max_id] = max_id unless max_id.nil?
    user_timeline(user, options)
  end
end

namespace :db do
  task :load_config do
    require "./app"
  end
end

namespace :users do 
  task refresh: :environment do 
    # client = createClient

    puts "Fetching users from config.yaml..."
    config = YAML.load_file("config.yaml")
    users = config['users']
    latestTweetId = 0
    earliestTweetId = nil

    users.each do |user|
      user.downcase!
      user.sub!("@", "")
      puts "\nUSER: #{user} \n"
      if !User.exists?(screen_name: user)
        tempUser = client.user(user)
        tempUser = User.new(name: tempUser.name,
                 screen_name: tempUser.screen_name.downcase,
                 oldest_tweet: nil,
                 newest_tweet: nil,
                 profile_image_uri: tempUser.profile_image_uri.to_s.sub("_normal", ""))
        if tempUser.save
          puts "New user #{user} created!"
          # get all tweets from user
          puts "Getting tweets from @" + user + "..."
          tweets = client.get_all_tweets("@" + user)

          begin 
            tweetArray = tweets.to_a
          rescue Twitter::Error::TooManyRequests => error
            sleep error.rate_limit.reset_in + 1
            retry
          end

          tweetArray.each do |tweet|
            next if tweet.retweet_count < 10
            Tweet.new(author_screen_name: tweet.user.screen_name,
                      text: tweet.text,
                      date: tweet.created_at.to_s,
                      favorite_count: tweet.favorite_count,
                      retweet_count: tweet.retweet_count).save
            latestTweetId = tweet.id if tweet.id > latestTweetId
            earliestTweetId = tweet.id if earliestTweetId.nil? || tweet.id < earliestTweetId
          end

          puts "#{tweetArray.length} tweets written"
          tempUser.oldest_tweet = earliestTweetId
          tempUser.newest_tweet = latestTweetId
          tempUser.save
        else
          puts "Error in creating {user}."
        end
      else 
        puts "User #{user} already exists."
      end
    end
  end

  task view_all: :environment do
    User.find_each do |u|
      puts u.inspect
    end
  end

  task remove_duplicates: :environment do 
    User.dedupe
  end

end

namespace :tweets do
  task test: :environment do 
    tweet = Tweet.getRandomTweet
    puts "Tweet screen name: #{tweet.author_screen_name}"
    user = User.where(screen_name: tweet.author_screen_name.downcase).first
    puts user.screen_name
    tweetHash = {author_screen_name: tweet.author_screen_name,
                 text: tweet.text,
                 date: tweet.date,
                 favorite_count: tweet.favorite_count,
                 retweet_count: tweet.retweet_count,
                 author_name: user.name,
                 profile_image_uri: user.profile_image_uri.to_s}
    puts tweetHash.to_json
  end

  task getLatest: :environment do 

    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end

    puts "Getting most recent tweets..."

    users = User.all
    lastTweet = nil
    timelineOptions = {
      since_id: nil,
      count: 200,
      exclude_replies: true,
      include_rts: true
    }
    oembedOptions = {
      omit_script: true
    }
    newTweetCounter = 0

    users.each do |user|
      timelineOptions[:since_id] = user.newest_tweet
      client.user_timeline("@" + user.screen_name, timelineOptions).each do |tweet|
        Tweet.new(author_screen_name: user.screen_name,
                  text: tweet.text,
                  date: tweet.created_at,
                  favorite_count: tweet.favorite_count,
                  retweet_count: tweet.retweet_count).save
        user.newest_tweet = tweet.id if tweet.id > user.newest_tweet.to_i
        newTweetCounter += 1
      end
      user.save if newTweetCounter
      puts "#{newTweetCounter} tweets fetched for #{user.name}"
    end

    # puts client.oembed(lastTweet, oembedOptions).html

  end

  task remove_duplicates: :environment do 
    Tweet.dedupe
  end

  task get_random: :environment do 
    puts Tweet.order("RANDOM()").first
  end

end

# <%= ENV['PG_USER'] %>