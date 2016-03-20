class Woods::StorytreesController < ApplicationController
  layout "binarywoods"

  before_action :set_woods_storytree, only: [:show, :destroy]
  before_action :set_woods_story
  before_action :verify_is_admin

  def show
  end

  def create
    @storytree = Woods::Storytree.new(woods_storytree_params)

    respond_to do |format|
      if @storytree.save
        format.html { redirect_to @storytree, notice: 'Storytree was successfully created.' }
        format.json { render action: 'show', status: :created, location: @storytree }
      else
        format.html { render action: 'new' }
        format.json { render json: @storytree.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @storytree.destroy
    respond_to do |format|
      format.html { redirect_to woods_storytrees_url }
      format.json { head :no_content }
    end
  end

  private
    def set_woods_storytree
      @storytree = Woods::Storytree.find(params[:id])
    end

    def set_woods_story
      @story = Woods::Story.find(params[:story_id])
    end

    def woods_storytree_params
      params[:woods_storytree]
    end
end
