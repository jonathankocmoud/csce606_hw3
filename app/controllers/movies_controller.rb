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
    
    changed_params = false
    if params[:ratings] == nil
      params[:ratings] = session[:ratings]
      changed_params = true
    end
    if params[:ratings] == nil
      @all_ratings.each do |key|
        params[:ratings][key] = 1
      end
      changed_params = false
      @ratingKeys = @all_ratings
    else
      @ratingKeys = params[:ratings].keys
    end
    
    new_params = request.session.to_hash.deep_dup
    params.each do |key, array|
      if new_params[key] != array
        new_params[key] = array
        session[key] = array
        changed_params = true
      end
    end
    if changed_params
      new_params.delete("_csrf_token") 
      new_params.delete("session_id")
      new_params.delete("flash")
      new_params.delete("flashes")
      redirect_to movies_path(new_params)
    end
    
    @sort_title = false
    @sort_release_date = false
    
    sort = new_params["sort"] # retrieve movie ID from URI route
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
