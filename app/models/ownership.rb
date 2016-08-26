class Ownership < ActiveRecord::Base

  validates :owner_id, :track_id, presence: true

  belongs_to :track

  belongs_to :owner, class_name: "User"
  
end
