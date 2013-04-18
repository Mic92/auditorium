class Video < ActiveRecord::Base
  
  attr_accessible :description, :title, :uri

  belongs_to :course
  has_many :comments, through: :posts

  validates :title, presence: true
  validates :description, presence: true
  validates :uri, presence: true

  before_save :extract_video_code

  def extract_video_code
  	self.code = Rack::Utils.parse_query(URI(self.uri).query)['v']
  end
end
