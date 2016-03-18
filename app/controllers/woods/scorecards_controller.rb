class Woods::ScorecardsController < ApplicationController
  layout "binarywoods"

  before_action :set_woods_scorecard, only: [:show, :edit, :update, :destroy]
  before_action :verify_is_admin

  # GET /woods/scorecards
  # GET /woods/scorecards.json
  def index
    @scorecards = Woods::Scorecard.all
  end

  # GET /woods/scorecards/1
  # GET /woods/scorecards/1.json
  def show
  end

  # GET /woods/scorecards/new
  def new
    @scorecard = Woods::Scorecard.new
  end

  # GET /woods/scorecards/1/edit
  def edit
  end

  # POST /woods/scorecards
  # POST /woods/scorecards.json
  def create
    @scorecard = Woods::Scorecard.new(woods_scorecard_params)

    respond_to do |format|
      if @scorecard.save
        format.html { redirect_to @scorecard, notice: 'Scorecard was successfully created.' }
        format.json { render action: 'show', status: :created, location: @scorecard }
      else
        format.html { render action: 'new' }
        format.json { render json: @scorecard.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /woods/scorecards/1
  # PATCH/PUT /woods/scorecards/1.json
  def update
    respond_to do |format|
      if @scorecard.update(woods_scorecard_params)
        format.html { redirect_to @scorecard, notice: 'Scorecard was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @scorecard.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /woods/scorecards/1
  # DELETE /woods/scorecards/1.json
  def destroy
    @scorecard.destroy
    respond_to do |format|
      format.html { redirect_to woods_scorecards_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_woods_scorecard
      @scorecard = Woods::Scorecard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def woods_scorecard_params
      params[:woods_scorecard]
    end
end
