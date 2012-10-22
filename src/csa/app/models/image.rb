class Image < ActiveRecord::Base
  belongs_to :user
  attr_accessible :photo
  has_attached_file :photo, styles: {large: "96x96#",
                                     medium: "64x64#",
                                     small: "48x48#",
                                     tiny: "30x30#"}
end
