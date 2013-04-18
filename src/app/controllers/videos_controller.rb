class VideosController < ApplicationController
	load_and_authorize_resource :course
  load_and_authorize_resource :video, :through => :course

	def index
		@videos = @course.videos.order('created_at DESC')
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @videos }
    end
	end

	def show
		@video = @course.videos.find(params[:id])

		respond_to do |format|
			format.html
			format.json {render json: @video }
		end
	end

	def new
		@video = @course.videos.build

	end

	def create
		@video = @course.videos.new(params[:video])

		respond_to do |format|
			if @video.save!
				format.html { redirect_to [@course, @video], notice: t('video.action.created') }
				format.json { render json: [@course, @video], status: :created, location: [@course, @video] }
			else
				format.html { render action: 'new' }
				format.json { render json: @video.errors, status: :unprecessable_entity }
			end
		end
	end

	def edit 
		@video = @course.videos.find(params[:id])
	end

	def update
		@video = @course.videos.find(params[:id])

		respond_to do |format|
			if @video.update_attributes(params[:video])
				format.html { redirect_to [@course, @video], notice: t('video.action.updated') }
				format.json { render json: [@course, @video], status: :created, location: [@course, @video] }
			else
				format.html { render action: 'edit' }
				format.json { render json: @video.errors, status: :unprecessable_entity }
			end
		end
	end

	def destroy
		@video = @course.videos.find(params[:id])
		@video.destroy

		respond_to do |format|
			format.html { redirect_to course_videos_path, notice: t('video.action.destroyed')}
			format.json { head :no_content }
		end
	end


end
