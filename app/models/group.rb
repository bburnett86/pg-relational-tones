class Group < ActiveRecord::Base

  belongs_to :playlist

  belongs_to :grouping
  
end
