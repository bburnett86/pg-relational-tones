class Grouping < ActiveRecord::Base

  belongs_to :track_one, class_name: "Track"

  belongs_to :track_two, class_name: "Track"

  has_many :groups

  has_many :playlists, through: :groups

end
