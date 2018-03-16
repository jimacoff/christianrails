class Crm::BooksController < Crm::CrmController

  before_action :set_crm_book_secure, only: [:edit, :update, :destroy, :start_reading, :finish ]

  ## LOGGED-IN ASSISTANTS ONLY

  def index
    @reading_books = Crm::Book.where(assistant_id: current_assistant.id)
                      .where(status_id: Crm::Book::STATUS_READING)
                      .order("desire_to_read desc")
    @unread_books = Crm::Book.where(assistant_id: current_assistant.id)
                      .where(status_id: Crm::Book::STATUS_UNREAD)
                      .order("desire_to_read desc")
    @reading_books ||= []
    @unread_books ||= []
  end

  def new
    @book = Crm::Book.new
    @book.status_id = Crm::Book::STATUS_READING
  end

  def edit
  end

  def create
    @book = Crm::Book.new(crm_book_params)
    @book.assistant = current_assistant

    if @book.save
      redirect_to crm_books_path, notice: 'Book was successfully created.'
      set_book_finished_time_if_read
    else
      render action: 'new'
    end
  end

  def update
    if @book.update(crm_book_params)
      set_book_finished_time_if_read
      redirect_to crm_books_path, notice: 'Book was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @book.destroy
    redirect_to crm_books_path, notice: 'Book was successfully destroyed.'
  end

  def have_read
    @books = Crm::Book.where( assistant_id: current_assistant.id )
                      .where( status_id: [Crm::Book::STATUS_READ] )
                      .order("finished_at desc")
    @books ||= []
  end

  def start_reading
    @book.status_id = Crm::Book::STATUS_READING
    @book.finished_at = Time.current

    if @book.save
      redirect_to crm_books_path, notice: "Now reading #{@book.title}!"
    else
      flash[:alert] = "Could not start this book. Please file a bug report and start reading anyway."
      redirect_to crm_books_path
    end
  end

  def finish
    @book.status_id = Crm::Book::STATUS_READ
    @book.finished_at = Time.current

    if @book.save
      redirect_to crm_books_path, notice: 'Book finished! Congratulations. Time to start another.'
    else
      flash[:alert] = "Could not mark as finished! Please file a bug report."
      redirect_to crm_books_path
    end
  end

  private

    def set_crm_book_secure
      @book = Crm::Book.find(params[:id])
      redirect_to(root_path) unless owns_assistant?( @book.assistant )
    end

    def crm_book_params
      params.require(:crm_book).permit(:title, :author, :status_id, :desire_to_read)
    end

    def set_book_finished_time_if_read
      if @book.status_id == Crm::Book::STATUS_READ
        @book.finished_at = Time.current
        @book.save
      end
    end

end
