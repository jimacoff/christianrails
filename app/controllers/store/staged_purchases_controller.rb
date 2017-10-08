class Store::StagedPurchasesController < Store::StoreController
  before_action :set_staged_purchase, only: [:destroy]
  skip_before_action :verify_is_admin, only: [:create, :destroy]

  ## PUBLIC

  def create
    if current_user
      fresh_add = false
      begin
        product = Store::Product.find( staged_purchase_params[:product_id] )
        type_id = staged_purchase_params[:type_id].to_i
        unless @staged_purchase = Store::StagedPurchase.where( user: current_user,
                                                               product_id: product.id,
                                                               type_id: type_id ).first
          @staged_purchase = Store::StagedPurchase.new(user: current_user, product_id: product.id, type_id: type_id)
          fresh_add = true
        end

        respond_to do |format|
          if @staged_purchase.save
            record_positive_event(Log::STORE, "Item added to cart: #{product.title}") if fresh_add
            format.json { render json: @staged_purchase, status: :created }
          else
            format.json { render json: {}, status: :unprocessable_entity }
          end
        end
      rescue
        record_bad_data(Log::STORE, "Attempted to create StagedPurchase for invalid productID #{staged_purchase_params['product_id']}")
        render json: {}, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if current_user
      if @staged_purchase.user.id == current_user.id
        @staged_purchase.destroy
        record_event(Log::STORE, "Item removed from cart: #{@staged_purchase.product.title}")
      end

      respond_to do |format|
        format.json { render json: @staged_purchase }
      end
    end
  end

  # ADMIN ONLY

  def index
    @staged_purchases = Store::StagedPurchase.all
  end

  private

    def set_staged_purchase
      @staged_purchase = Store::StagedPurchase.find(params[:id])
    end

    def staged_purchase_params
      params.require(:staged_purchase).permit(:product_id, :type_id)
    end
end
