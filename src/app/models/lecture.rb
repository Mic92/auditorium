class Lecture < ActiveRecord::Base

  has_many :courses, :dependent => :destroy
  has_many :lecture_memberships, :dependent => :destroy
  has_many :maintainers, through: :lecture_memberships, source: :user # maintainer
  belongs_to :chair

  attr_accessible :name, :chair_id, :url, :sws, :creditpoints, :description
  
  validates :name,  presence: true
  validates :chair,   presence: true

  define_index do
    indexes :name
    indexes description
    indexes url

    indexes courses.name
    indexes courses.description
    indexes courses.semester
    indexes courses.url
    
    set_property :enable_star => true
    set_property :min_infix_len => 2
  end

  def parent
    self.chair
  end

  def children
    self.courses
  end

  def has_current_course?
    !self.courses.nil? and self.current_courses.length > 0
  end
    
  def current_courses
    self.courses.keep_if { |c| c.is_now? } unless self.courses.nil?  
  end

  def current_course
    self.current_courses.last unless self.current_courses.nil?
  end

  def to_s 
    self.name
  end

  def maintainers
    maintainers = LectureMembership.find_all_by_lecture_id_and_membership_type(self.id, 'maintainer')
  end

  def editors
    editors = LectureMembership.find_all_by_lecture_id_and_membership_type(self.id, 'editor')
  end

end
