class Woods::PalettesController < Woods::WoodsController

  before_action :set_woods_palette, only: [:update, :destroy]
  before_action :set_woods_story

  def index
    @palettes = Woods::Palette.all
  end

  def create
    @palette = Woods::Palette.new(woods_palette_params)

    respond_to do |format|
      if @palette.save
        format.html { redirect_to @palette, notice: 'Palette was successfully created.' }
        format.json { render action: 'show', status: :created, location: @palette }
      else
        format.html { render action: 'new' }
        format.json { render json: @palette.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @palette.update(woods_palette_params)
        format.html { redirect_to woods_story_palettes_path, notice: 'Palette was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to woods_story_palettes_path }
        format.json { render json: @palette.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @palette.destroy
    respond_to do |format|
      format.html { redirect_to woods_palettes_url }
      format.json { head :no_content }
    end
  end

  private
    def set_woods_palette
      @palette = Woods::Palette.find(params[:id])
    end

    def set_woods_story
      @story = Woods::Story.find(params[:story_id])
    end

    def woods_palette_params
      params.permit(:name, :fore_colour, :back_colour, :alt_colour, :story_id)
    end
end
