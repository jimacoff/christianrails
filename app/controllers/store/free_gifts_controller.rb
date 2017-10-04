class Store::FreeGiftsController < Store::StoreController

  before_action :set_free_gift_secure, only: [:give]

  ## ADMIN ONLY

  def index
    @free_gifts = Store::FreeGift.order('created_at desc')
  end

  def new
    @free_gift = Store::FreeGift.new
    @products  = Store::Product.all
    @users     = User.all
  end

  def create
    @free_gift = Store::FreeGift.new(free_gift_params)

    if @free_gift.save
      redirect_to store_free_gifts_url, notice: 'Free gift was successfully created.'
    else
      flash[:alert] = "Origin is required."
      redirect_to new_store_free_gift_path
    end
  end

  def give
    if params[:email] && params[:first_name] && params[:last_name]
      if !@free_gift.given?
        # give the gift, unless the user exists & already owns the book
        if existing_user = User.where(email: params[:email]).take
          if existing_user.has_product?( @free_gift.product_id )
            # don't send the gift; return error to user
            flash[:alert] = "The recipient already owns this product! Try someone else."
          else
            # give the product. send email notifications
            StoreMailer.you_got_a_gift(@free_gift.product, current_user, existing_user).deliver_now

            @free_gift.recipient = existing_user
            @free_gift.save

            flash[:notice] = "Gift information sent!"
          end
        else
          new_user = User.invite!( { email: params[:email],
                                     first_name: params[:first_name],
                                     last_name: params[:last_name],
                                     invited_for_product_id: @free_gift.product_id
                                    }, current_user) # invited_by

          @free_gift.recipient = new_user  # give the gift
          @free_gift.save

          flash[:notice] = "Gift information sent!"
        end
      else
        flash[:alert] = "This gift has already been given to someone."
      end
    else
      flash[:alert] = "Bad params. Need first_name, last_name & email."
    end
    redirect_to library_path
  end

  private

    def free_gift_params
      params.require(:store_free_gift).permit(:user_id, :product_id, :origin)
    end

    def set_free_gift_secure
      @free_gift = Store::FreeGift.find( params[:id] )
      redirect_to root_path unless current_user && current_user == @free_gift.giver
    end

end
