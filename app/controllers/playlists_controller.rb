require 'set'
require 'nokogiri'

class PlaylistsController < ApplicationController
  def index
    if current_user.playlists.all.count == 0
      redirect_to "/import"
    end
    @playlists = current_user.playlists
    @tracks = @playlists.first.recommend_tracks
  end

  def partial
    @playlists = current_user.playlists
    render partial: 'partials/all', locals: { playlists: @playlists}, layout: false
  end

  def player
    @track = Track.find(params[:id])
    render partial: 'partials/player', locals: { track: @track}, layout: false
  end

  def carousel
    @tracks = Playlist.find(params[:id]).recommend_tracks
    render partial: 'partials/carousel', locals: { tracks: @tracks}, layout: false
  end

  def temp
    ids = params[:track_ids].split(",").map! { |id| id.to_i }
    playlist = Playlist.new
    ids.each do |id|
      playlist.tracks << Track.find(id)
    end
    tracks = playlist.recommend_tracks
    render partial: 'partials/carousel', locals: { tracks: tracks}, layout: false
  end

  def tracks
    @tracks = Playlist.find(params[:id]).tracks
    render partial: 'partials/tracks', locals: { tracks: @tracks}, layout: false
  end

  def track
    @track = Track.find(params[:id])
    render partial: 'partials/track', locals: {track: @track}, layout: false
  end

  def create
    @playlist = Playlist.create(playlist_params)
    if @playlist.save
      redirect_to "/playlists"
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to '/playlists'
    end
  end

  def show
    @playlist = Playlist.find(params[:id])
    @tracks = @playlist.recommend_tracks
  end
end
