class AuditoriumMailer < ActionMailer::Base
  default from: "auditorium <notification+#{('a'..'z').to_a.shuffle[0..7].join}@auditorium.inftex.net>"

  def welcome_email(user)
  	@user = user
    @url = "http://auditorium.inftex.net"
    mail(to: @user.email, subject: 'Welcome to auditorium. Your account has been confirmed.')
  end 

  def membership_changed(course, user, membership_type)
  	@user = user
  	@url = course_url(course)
  	@course = course 

  	mail(to: @user.email, 
  		subject: "You are now a #{membership_type} of #{course.name_with_term}.", 
  		template_path: "auditorium_mailer",
  		template_name: "#{membership_type}_membership")
  end

  def private_question(user, post)
  	@user = user
  	@course = post.course
  	@url = course_url(post.course)
  	@post = post
  	membership = CourseMembership.find_by_course_id_and_user_id(@course.id, @user.id)
    @membership_type = membership.membership_type if !membership.nil?

    if @user.is_admin? and not (@membership_type.eql? 'maintainer' or @membership_type.eql? 'editor')
      @template = 'private_question_admin'
    else
      @template = 'private_question'
    end

  	mail(to: @user.email,
  		subject: "[private question] #{@post.subject[0..100]}... - #{@post.course.name_with_term}",
  		template_path: 'auditorium_mailer',
  		template_name: @template)
  end

  def update_in_course(user, post) 
    @user = user
    @course = post.course
    @url = course_url(post.course)
    @post = post

    case post.post_type
        
    when 'info'
      subject = "[announcement] #{@post.subject[0..100]}... - #{@post.course.name_with_term}"
    when 'question'
      subject = "[question] #{@post.subject[0..100]}... - #{@post.course.name_with_term}" 
    when 'comment'
      subject = "[comment] #{@post.body[0..100]}... - #{@post.course.name_with_term}"
    when 'answer'
      subject = "[answer] #{@post.body[0..100]}... - #{@post.course.name_with_term}"
    else
      subject = "#{@post.author.full_name} posted something - #{@course.name_with_term}."
    end

    mail(to: @user.email,
      subject: subject,
      template_path: 'auditorium_mailer',
      template_name: 'update_in_course')
  end

  def new_course_to_approve(course, admin)
    @user = admin
    @course_url = course_url(course)
    @course = course 

    mail(to: @user.email, 
      subject: "The course '#{course.name_with_term}' needs to be approved.")
  end

  def course_approved(course, user)
    @user = user
    @course_url = course_url(course)
    @course = course 

    mail(to: @user.email, 
      subject: "Your course '#{course.name_with_term}' has been approved.")
  end
end
