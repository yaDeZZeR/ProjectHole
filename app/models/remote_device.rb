class RemoteDevice < ActiveRecord::Base
	belongs_to :user
	enum video_qualite: { SD: 0, HD: 1, FHD: 2}
end
