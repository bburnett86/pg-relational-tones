require 'set'

class Playlist < ActiveRecord::Base

  validates :obj_hash, presence: true

  has_many :selections

  belongs_to :grouping

  has_many :tracks, through: :selections

  def obj
    RSpotify::Playlist.new(JSON.parse(self.obj_hash))
  end

  # def self.seed
  #   (Track.all.length - 1).times do |index|
  #     Playlist.all.each do |playlist|
  #       tracks_var = playlist.tracks
  #       if (tracks_var.include?(tracks_var[index]) && tracks_var.include?(tracks_var[index + 1]))
  #         grouping = Grouping.create!(track_one_id: tracks_var[index].id, track_two_id: tracks_var[index + 1].id)
  #         Group.create!(grouping_id: grouping.id, playlist_id: playlist.id)
  #       end
  #     end
  #   end
  # end

  def average_tempo
    sum = 0
    counter = 0
    tracks.each do |track|
      if track.tempo != 0.00
        counter += 1
        sum += track.tempo
      end
    end
    counter = 1 if counter == 0
    sum / counter
  end

  def average_energy
    sum = 0
    counter = 0
    tracks.each do |track|
      if track.energy != 0.00
        counter += 1
        sum += track.energy
      end
    end
    counter = 1 if counter == 0
    sum / counter
  end

  def average_danceability
    sum = 0
    counter = 0
    tracks.each do |track|
      if track.danceability != 0.00
        counter += 1
        sum += track.danceability
      end
    end
    counter = 1 if counter == 0
    sum / counter
  end

  def average_acousticness
    sum = 0
    counter = 0
    tracks.each do |track|
      if track.acousticness != 0.00
        counter += 1
        sum += track.acousticness
      end
    end
    counter = 1 if counter == 0
    sum / counter
  end

  def average_speechiness
    sum = 0
    counter = 0
    tracks.each do |track|
      if track.speechiness != 0.00
        counter += 1
        sum += track.speechiness
      end
    end
    counter = 1 if counter == 0
    sum / counter
  end

  def average_liveness
    sum = 0
    counter = 0
    tracks.each do |track|
      if track.liveness != 0.00
        counter += 1
        sum += track.liveness
      end
    end
    counter = 1 if counter == 0
    sum / counter
  end

  def average_loudness
    sum = 0
    counter = 0
    tracks.each do |track|
      if track.loudness != 0.00
        counter += 1
        sum += track.loudness
      end
    end
    counter = 1 if counter == 0
    sum / counter
  end

  def average_valence
    sum = 0
    counter = 0
    tracks.each do |track|
      if track.valence != 0.00
        counter += 1
        sum += track.valence
      end
    end
    counter = 1 if counter == 0
    sum / counter
  end

  def get_tracks_from_danceability(tracks)
    avg_dance = average_danceability
    allow = get_allowance(0.068)
    tracks.select {|track| track.danceability <= avg_dance + allow && track.danceability >= avg_dance - allow }
  end

  def get_tracks_from_energy(tracks)
    avg_energy = average_energy
    allow = get_allowance(0.308988)
    tracks.select {|track| track.energy <= avg_energy + allow && track.energy >= avg_energy - allow}
  end

  def get_tracks_from_tempo(tracks)
    avg_tempo = average_tempo
    allow = get_allowance(21.5678)
    tracks.select {|track| track.tempo <= avg_tempo + allow && track.tempo >= avg_tempo - allow }
  end

  def get_tracks_from_acousticness(tracks)
    avg_acousticness = average_acousticness
    allow = get_allowance(0.176995)
    tracks.select {|track| track.acousticness <= avg_acousticness + allow && track.acousticness >= avg_acousticness - allow }
  end

  def get_tracks_from_loudness(tracks)
    avg_loudness = average_loudness
    allow = get_allowance(5.6765976)
    tracks.select {|track| track.loudness <= avg_loudness + allow && track.loudness >= avg_loudness - allow }
  end

  def get_tracks_from_liveness(tracks)
    avg_liveness = average_liveness
    allow = get_allowance(0.149098)
    tracks.select {|track| track.liveness <= avg_liveness + allow && track.liveness >= avg_liveness - allow }
  end

  def get_tracks_from_valence(tracks)
    avg_valence = average_valence
    allow = get_allowance(0.27985)
    tracks.select {|track| track.valence <= avg_valence + allow && track.valence >= avg_valence - allow }
  end

  def get_tracks_from_speechiness(tracks)
    avg_speechiness = average_speechiness
    allow = get_allowance(0.01865)
    tracks.select {|track| track.speechiness <= avg_speechiness + allow && track.speechiness >= avg_speechiness - allow }
  end

  def have_tracks(collection_of_songs)
    collection_of_songs.all? { |song| self.tracks.include?(song) }
  end

  def random_tracks(num = 1)
    self.tracks.sample(num)
  end

  def recommend_tracks
    playlists = []
    self.tracks.each_cons(2).each do |track_pair|
      playlists += track_pair[0].shared_playlists(track_pair[1])
    end
    recommended_tracks = playlists.uniq.map { |p| p.random_tracks(2) }.flatten.uniq
    recommended_tracks -= tracks.to_a
    tracks_val_avg = get_tracks_from_danceability(Track.all)
    tracks_val_avg = get_tracks_from_tempo(tracks_val_avg)
    tracks_val_avg = get_tracks_from_energy(tracks_val_avg)
    tracks_val_avg = get_tracks_from_speechiness(tracks_val_avg)
    tracks_val_avg = get_tracks_from_loudness(tracks_val_avg)
    tracks_val_avg = get_tracks_from_liveness(tracks_val_avg)
    tracks_val_avg = get_tracks_from_valence(tracks_val_avg)
    tracks_val_avg = get_tracks_from_acousticness(tracks_val_avg)
    tracks_val_avg -= tracks.to_a
    recommended_tracks += tracks_val_avg.sample(6)
    recommended_tracks
  end

  def get_allowance(margin)
    returned_value = margin
    num = Track.all.count
    (num / 1250).floor.times do
      returned_value /= 1.05
    end
    returned_value
  end

end
