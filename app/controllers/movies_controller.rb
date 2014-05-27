class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @ratings = params[:ratings] ? params[:ratings].map {|rating| rating[0]} : session[:ratings]
    @ratings = Movie.all_ratings unless @ratings
    @sort_by = (params[:sort_by] ? params[:sort_by] : session[:sort_by] ? session[:sort_by] : nil)
    if @sort_by
      @movies = Movie.order(@sort_by).where(rating: @ratings)
    else
      @movies = Movie.where(rating: @ratings)
    end
    @all_ratings = Movie.all_ratings
    session[:ratings] = @ratings
    session[:sort_by] = @sort_by
    params_ratings = params[:ratings] ? params[:ratings].map {|rating| rating[0]} : nil
    if (@ratings != params_ratings ) || (@sort_by != params[:sort_by])
      new_params_ratings = Hash[ @ratings.map {|rating| [rating, "1"]}]
      new_params = {ratings: new_params_ratings, sort_by: @sort_by}
      flash.keep
      redirect_to movies_path(params: new_params)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
