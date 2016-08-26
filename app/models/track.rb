require 'set'

class Track < ActiveRecord::Base

  validates :obj_hash, presence: true

  has_many :selections

  has_many :playlists, through: :selections

  # has_many :groupings, foreign_key: :track_one_id
  #
  # has_many :pairs, through: :groupings, source: :track_two

  belongs_to :ownership

  has_many :ownerships

  has_many :owners, through: :ownerships

  def obj
    RSpotify::Track.new(JSON.parse(self.obj_hash))
  end

  def shared_playlists(other_track)
    playlists & other_track.playlists
  end

end
