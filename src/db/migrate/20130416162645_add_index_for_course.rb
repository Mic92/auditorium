class AddIndexForCourse < ActiveRecord::Migration
  def change
  	add_index :videos, :course_id
  end
end
