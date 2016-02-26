class Woods::StoriesController < ApplicationController
  layout "binarywoods"

  before_action :set_woods_story, only: [:show, :edit, :update, :destroy, :play, :move_to]
  before_action :verify_is_published
  before_action :verify_is_admin

  def index
    @stories = Woods::Story.all
  end

  def play
    begin
      @storytree = Woods::Storytree.find(@story.entry_tree)
    rescue
      raise "Invalid entry tree?!?"
    end

    @node = @storytree.get_first_node
    @node = @node.add_accoutrements
  end

  # JSON endpoint
  def move_to
    begin
      @node = Woods::Node.find( params[:target_node] )
      # TODO check if node in published story

    rescue
      Rails.logger.warn("Unexpected node requested.")
    end

    @node = @node.add_accoutrements

    # TODO track lefts and rights


    # TODO update user footprints


    respond_to do |format|
      if @node
        format.json { render json: @node, status: :ok }
      else
        format.json { render json: @node, status: :unprocessable_entity }
      end
    end

  end

  def show
  end

  def new
    @story = Woods::Story.new
  end

  def edit
  end

  def create
    @story = Woods::Story.new(woods_story_params)

    respond_to do |format|
      if @story.save
        format.html { redirect_to @story, notice: 'Story was successfully created.' }
        format.json { render action: 'show', status: :created, location: @story }
      else
        format.html { render action: 'new' }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @story.update(woods_story_params)
        format.html { redirect_to @story, notice: 'Story was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @story.destroy
    respond_to do |format|
      format.html { redirect_to woods_stories_url }
      format.json { head :no_content }
    end
  end

  private
    def set_woods_story
      @story = Woods::Story.find(params[:id])
    end

    def woods_story_params
      params[:woods_story]
    end
end
