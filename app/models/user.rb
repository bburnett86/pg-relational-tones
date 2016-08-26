require 'bcrypt'
require 'csv'
class User < ActiveRecord::Base
  include BCrypt

  validates :email, :obj_hash, :password, :password_confirmation, presence: true

  validates :email, uniqueness: true

  validate :validate_password

  has_many :playlists

  belongs_to :ownership, foreign_key: :owner_id

  has_many :ownerships, foreign_key: :owner_id

  has_many :tracks, through: :ownerships

  def self.write
    CSV.open("userdata.csv", 'w') do |csv|
      csv << User.column_names
      User.all.each do |m|
        csv << m.attributes.values
      end
    end
  end

  def seed3
    obj.saved_albums.each do |album|
      if !Playlist.find_by(name: album.name, user_id: self.id)
        playlist_var = Playlist.create!(user_id: self.id, name: album.name, obj_hash: album.to_json)
        seed_list(album.tracks, playlist_var.id)
      end
    end
  end

  def self.seed
    self.all.each do |user|
      user.seed_playlists
    end
  end

  def self.seed2
    self.all.each do |user|
      user.seed_data
    end
  end

  def seed_playlists
    obj.playlists(limit: 50).each do |pl|
      if !Playlist.find_by(name: pl.name, user_id: self.id)
        Playlist.create!(user_id: self.id, name: pl.name, obj_hash: pl.to_json)
      end
    end
  end

  def seed_data
    playlists.each do |playlist|
      begin
        seed_list(playlist.obj.tracks, playlist.id)
      rescue

      end
    end
  end

  def seed_list(list, playlist_id)
    list.each_with_index do |track, index|
      begin
        track_name = track.name
      rescue
        track_name = "untitled"
      end
      begin
        track_artist_name = track.artists.first.name
      rescue
        track_artist_name = "unknown"
      end
      begin
        track_album_name = track.album.name
      rescue
        track_album_name = "untitled"
      end
      if (!track_var = Track.find_by(name: track_name, artist_name: track_artist_name))
        begin
          audio = track.audio_features
          begin
            track_danceability = audio.danceability
          rescue
            track_danceability = 0.00
          end
          begin
            track_tempo = audio.tempo
          rescue
            track_tempo = 0.00
          end
          begin
            track_energy = audio.energy
          rescue
            track_energy = 0.00
          end
          begin
            track_acousticness = audio.acousticness
          rescue
            track_acousticness = 0.00
          end
          begin
            track_liveness = audio.liveness
          rescue
            track_liveness = 0.00
          end
          begin
            track_loudness = audio.loudness
          rescue
            track_loudness = 0.00
          end
          begin
            track_speechiness = audio.speechiness
          rescue
            track_speechiness = 0.00
          end
          begin
            track_valence = audio.valence
          rescue
            track_valence = 0.00
          end
        rescue

        end
        begin
          if !audio.nil?
            track_var = Track.create!(name: track.name, obj_hash: track.to_json, artist_name: track.artists.first.name, album_name: track.album.name, danceability: track_danceability, energy: track_energy, tempo: track_tempo, liveness: track_liveness, loudness: track_loudness, acousticness: track_acousticness, speechiness: track_speechiness, valence: track_valence)
          end
        rescue

        end
      end
      if !track_var.nil?
        if !Ownership.find_by(owner_id: self.id, track_id: track_var.id)
          Ownership.create!(owner_id: self.id, track_id: track_var.id)
        end
        if !Selection.find_by(playlist_id: playlist_id, track_id: track_var.id)
          Selection.create!(playlist_id: playlist_id, track_id: track_var.id)
        end
      end
    end
  end

  def password_confirmation=(pc)
    @pc = pc
  end

  def password_confirmation
    @pc
  end

  def obj
    RSpotify::User.new(JSON.parse(self.obj_hash))
  end

  def password=(pt_p)
    @pt_p = pt_p
    @password = Password.create(pt_p)
    self.hashed_password = @password
  end

  def password
    @password ||= Password.new(self.hashed_password)
  end

  def self.authenticate(email, password)
    if user = User.find_by(email: email)
      if (user.password == password)
        return user
      end
    end
    nil
  end

  private
  def contains_uppercase_characters
    @pt_p != @pt_p.downcase
  end

  def contains_lowercase_characters
    @pt_p != @pt_p.upcase
  end

  def contains_numerical_characters
    /\d/.match( @pt_p )
  end

  def validate_password
    if @pt_p.length.nil?
      @errors.add(:password, "must not be empty")
    elsif @pt_p.length < 6
      @errors.add(:password, "must be at least 6 characters long")
    elsif !contains_uppercase_characters
      @errors.add(:password, "must contain at least one uppercase letter")
    elsif !contains_lowercase_characters
      @errors.add(:password, "must contain at least one lowercase letter")
    elsif !contains_numerical_characters
      @errors.add(:password, "must contain at least one number")
    elsif @pt_p != @pc
      @errors.add("Passwords do not match.")
    end
  end
end
