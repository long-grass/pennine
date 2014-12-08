class TrailsController < ApplicationController
  # GET /trails
  # GET /trails.json
  def index
    @trails = Trail.all
# binding.pry
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trails }
    end
  end

  # GET /trails/1
  # GET /trails/1.json
  def show
    @trail = Trail.find(params[:id])
   
    @uploader = User.find_by_id(@trail.user_id)
    if current_user
      @bookmark = current_user.bookmarks.find_by_trail_id(@trail.id)
      @favourites = @trail.bookmarks.where(favourited:true)
      @completeds = @trail.bookmarks.where(completed:true)
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @trail, root: false  }
    end
  end

  # GET /trails/new
  # GET /trails/new.json
  def new
    @trail = Trail.new
 
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trail }
    end
  end

  # GET /trails/1/edit
  def edit
    @trail = Trail.find(params[:id])
  end

  # POST /trails
  # POST /trails.json
  def create
    @trail = Trail.new(params[:trail])

    respond_to do |format|
      if @trail.save
         params[:file].each do |photo|
           @trail.photos << Photo.create(image: photo)   
         end
        format.html { redirect_to @trail, notice: 'Trail was successfully created.' }
        format.json { render json: @trail, status: :created, location: @trail }
      else
        format.html { render action: "new" }
        format.json { render json: @trail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /trails/1
  # PUT /trails/1.json
  def update
    @trail = Trail.find(params[:id])

    respond_to do |format|
      if @trail.update_attributes(params[:trail])
        format.html { redirect_to @trail, notice: 'Trail was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @trail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trails/1
  # DELETE /trails/1.json
  def destroy
    @trail = Trail.find(params[:id])
    @trail.destroy

    respond_to do |format|
      format.html { redirect_to trails_url }
      format.json { head :no_content }
    end
  end
end
