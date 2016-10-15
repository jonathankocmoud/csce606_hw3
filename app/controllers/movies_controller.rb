class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.get_ratings
    ratings = params[:ratings]
    if ratings == nil
      @ratingKeys = @all_ratings
    else
      @ratingKeys = ratings.keys
    end
    @sort_title = false
    @sort_release_date = false
    sort = params[:sort] # retrieve movie ID from URI route
    if sort == "title"
      @sort_title = true
      @movies = Movie.where(rating: @ratingKeys).order(:title)
    elsif sort == "release_date"
      @sort_release_date = true
      @movies = Movie.where(rating: @ratingKeys).order(:release_date)
    else
      @movies = Movie.where(rating: @ratingKeys)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
