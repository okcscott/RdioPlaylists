require "#{Rails.root}/lib/rdio-simple/om"
require "#{Rails.root}/lib/rdio-simple/rdio"
require 'open-uri'
require 'RMagick'
include Magick

class HomeController < ApplicationController

  RDIO_IDS = %w[s1640129, s1530579] #brit & scott

  def index
    rdio = Rdio.new([ENV['RDIO_KEY'], ENV['RDIO_SECRET']])
    scott_playlists = rdio.call("getPlaylists", {"user" => "s1530579", "extras" => "iframeUrl"})
    brit_playlists = rdio.call("getPlaylists", {"user" => "s1640129", "extras" => "iframeUrl"})

    @playlists = []

    scott_playlists["result"]["owned"].each do |playlist|
      if playlist["name"].downcase.include? "and to hold"
        @playlists << playlist
      end
    end

    brit_playlists["result"]["owned"].each do |playlist|
      if playlist["name"].downcase.include? "and to hold"
        @playlists << playlist
      end
    end

    @playlists.each do |playlist|
      if !File.exist?("#{Rails.root}/tmp/#{playlist["key"]}.png")
        url = playlist["icon"].gsub("=200","=1200")
        img = Magick::Image.read(url).first
        img = img.blur_image(0,4)
        img.write("#{Rails.root}/tmp/#{playlist["key"]}.png")
      end
    end    
  end

  def blur_image
    playlist_id = params[:id]

    data = File.open("#{Rails.root}/tmp/#{playlist_id}.png","rb").read
    send_data(data , :filename => "test.png", :type=>"image/png", :disposition => 'inline') and return

    # rdio = Rdio.new(["zsy63hyueh3rnqe2b94navet","dancgKCWcK"])
    # scott_playlists = rdio.call("getPlaylists", {"user" => "s1530579", "extras" => "iframeUrl"})
    # brit_playlists = rdio.call("getPlaylists", {"user" => "s1640129", "extras" => "iframeUrl"})

    # @playlists = []

    # scott_playlists["result"]["owned"].each do |playlist|
    #   if playlist["name"].downcase.include? "and to hold"
    #     @playlists << playlist
    #   end
    # end

    # brit_playlists["result"]["owned"].each do |playlist|
    #   if playlist["name"].downcase.include? "and to hold"
    #     @playlists << playlist
    #   end
    # end
    # url = ""

    # @playlists.each do |playlist|
    #   if playlist["key"] == playlist_id
    #     url = playlist["icon"].gsub("=200","=1200")
    #   end
    # end

    # img = Magick::Image.read(url).first

    # img = img.blur_image(0,4)

    # img.write("#{Rails.root}/tmp/#{playlist_id}.png")

    # send_data(img.blur_image(0,4).to_blob, :disposition => 'inline', :type => 'image/png')
  end

end