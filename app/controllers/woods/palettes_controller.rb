class Woods::PalettesController < Woods::WoodsController

  before_action :set_woods_palette, only: [:update, :destroy]
  before_action :set_woods_story

  ## ADMIN ONLY

  def index
    @palettes = Woods::Palette.all
  end

  def create
    @palette = Woods::Palette.new(woods_palette_params)

    if @palette.save
      redirect_to @palette, notice: 'Palette was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @palette.update(woods_palette_params)
      redirect_to woods_story_palettes_path, notice: 'Palette was successfully updated.'
    else
      redirect_to woods_story_palettes_path
    end
  end

  def destroy
    @palette.destroy
    redirect_to woods_palettes_url
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
