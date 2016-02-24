class Woods::StoriesController < ApplicationController
  before_action :set_woods_story, only: [:show, :edit, :update, :destroy]

  # GET /woods/stories
  # GET /woods/stories.json
  def index
    @woods_stories = Woods::Story.all
  end

  # GET /woods/stories/1
  # GET /woods/stories/1.json
  def show
  end

  # GET /woods/stories/new
  def new
    @woods_story = Woods::Story.new
  end

  # GET /woods/stories/1/edit
  def edit
  end

  # POST /woods/stories
  # POST /woods/stories.json
  def create
    @woods_story = Woods::Story.new(woods_story_params)

    respond_to do |format|
      if @woods_story.save
        format.html { redirect_to @woods_story, notice: 'Story was successfully created.' }
        format.json { render action: 'show', status: :created, location: @woods_story }
      else
        format.html { render action: 'new' }
        format.json { render json: @woods_story.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /woods/stories/1
  # PATCH/PUT /woods/stories/1.json
  def update
    respond_to do |format|
      if @woods_story.update(woods_story_params)
        format.html { redirect_to @woods_story, notice: 'Story was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @woods_story.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /woods/stories/1
  # DELETE /woods/stories/1.json
  def destroy
    @woods_story.destroy
    respond_to do |format|
      format.html { redirect_to woods_stories_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_woods_story
      @woods_story = Woods::Story.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def woods_story_params
      params[:woods_story]
    end
end
