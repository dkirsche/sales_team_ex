class SalesTeamOption < ActiveRecord::Base
    belongs_to :company
  
    validates :bio, :presence=> true
  
  
end
