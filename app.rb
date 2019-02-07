require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'omniauth-github'
require_relative 'config/application'

set :bind, '0.0.0.0'  # bind to all interfaces

helpers do
  def current_user
    if @current_user.nil? && session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
      session[:user_id] = nil unless @current_user
    end
    @current_user
  end

  def signed_in?
    current_user.present?
  end

  def correct_user?(user)
    user == current_user ? true : false
  end

  def allowed_to_join?(user_id, meetup, meetup_registrations)
    if meetup.user_id == user_id
      return false
    elsif signed_in?
      meetup_registrations.each do |registration|
        if registration.user_id == user_id
          return false
        end
      end
    else
      return true
    end
  end
end


def set_current_user(user)
  session[:user_id] = user.id
end

def authenticate!
  unless signed_in?
    flash[:notice] = "You must sign in first!"
  end
end

get '/' do
  redirect '/meetups'
end

get '/auth/github/callback' do
  auth = env['omniauth.auth']
  user = User.find_or_create_from_omniauth(auth)
  set_current_user(user)
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/meetups' do
  @meetups = Meetup.all.order(:title)
  erb :'meetups/index'
end


get "/meetups/new" do
  @meetup = Meetup.new
  erb :'meetups/new'
end

post "/meetups" do
  @meetup = Meetup.new(params[:meetup])
  @meetup.user_id = session[:user_id]
  if params[:meetup]["date"] != "" && params[:meetup]["begin_time"] != "" && params[:meetup]["end_time"] != ""
      date_string = params[:meetup]["date"] + " " + params[:meetup]["begin_time"] + ":00 UTC"
      @meetup[:date] = date_string.to_time
      begin_time_string = params[:meetup]["date"] + " " + params[:meetup]["begin_time"] + ":00 UTC"
      @meetup[:begin_time] = begin_time_string.to_time
      end_time_string = params[:meetup]["date"] + " " + params[:meetup]["end_time"] + ":00 UTC"
      @meetup[:end_time] = end_time_string.to_time
  end
  if @meetup.save
    flash[:notice] = "You have sucessfully created a meetup!"
    redirect "/meetups"
  elsif !signed_in?
    authenticate!
    erb :'meetups/new'
  else
    @errors = @meetup.errors.full_messages
    erb :'meetups/new'
  end
end

get "/meetups/:id" do
  @id = params[:id].to_i
  @registrations = Registration.where(meetup_id: @id)
  @user_id = session[:user_id]
  @meetup = Meetup.find_by(id: @id)
  @date = (@meetup.date.to_s).split(" ")[0]
  @begin_time = ((@meetup.begin_time.to_s).split(" ")[1]).chomp(":00")
  @end_time = ((@meetup.end_time.to_s).split(" ")[1]).chomp(":00")
  if signed_in?
    @user = User.find(@meetup.user_id)
    binding.pry
  end
  erb :'meetups/meetup'
end


post "/meetups/:id" do
  @id = params[:id].to_i
  @user_id = session[:user_id].to_i
  @meetup = Meetup.find_by(id: @id)
  @user = User.find_by(id: @user_id)
  @registrations = Registration.where(meetup: @id)
  @registration = Registration.new
  @registration.meetup_id = @id
  @registration.user_id = params[:user_id]

  if @registration.save
    session[:errors] = nil
    erb :'meetups/meetup'
    flash[:notice] = "You have sucessfully joined the meetup!"
    redirect "/meetups/#{@id}"
  else
    session[:errors] = @registration.errors.full_messages
    params[:id] = @id
    authenticate!
    erb :'meetups/meetup'
    redirect "/meetups/#{@id}"
  end
end


get "/meetups/edit/:id" do
  @id = params[:id].to_i
  @meetup = Meetup.find(@id)
  @user_id = session[:user_id]
  @errors = session[:errors]
  if signed_in?
    @user = User.find(@meetup.user_id)
  end
  erb :'meetups/edit'
end

post "/meetups/edit/:id" do
  @id = params[:id].to_i
  @meetup = Meetup.find(@id)
  @edited_meetup = Meetup.new(params[:meetup])
  @meetup.title = @edited_meetup.title
  @meetup.theme = @edited_meetup.theme
  @meetup.date = @edited_meetup.date
  @meetup.begin_time = @edited_meetup.begin_time
  @meetup.end_time = @edited_meetup.end_time
  @meetup.location = @edited_meetup.location
  @meetup.description = @edited_meetup.description
  if @meetup.save
    erb :'meetups/meetup'
    session[:errors] = nil
    redirect "/meetups/#{@id}"
  else
    session[:errors] = @meetup.errors.full_messages
    params[:id] = @id
    erb :'meetups/edit'
    redirect "/meetups/edit/#{@id}"
  end
end
