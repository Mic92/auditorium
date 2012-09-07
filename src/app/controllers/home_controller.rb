class HomeController < ApplicationController
  before_filter :signed_in?
	
  def index
    if signed_in?
      @courses = Course.order("name ASC").find(:all, :offset => 0, :limit => 100)
      @courses_by_faculty = @courses.group_by{ |course| course.lecture.chair.institute.faculty.name }
      
      @post = Post.new()
      @post.post_type = 'question'
      @posts = Post.order('created_at DESC').where('post_type = ? or post_type = ?', 'question', 'info').page(params[:page]).per(20)
      
    else
      redirect_to root_path
    end
  end
end
