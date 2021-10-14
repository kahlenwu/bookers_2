class BooksController < ApplicationController
  def index
  @books = Book.all
  @book = Book.new
  end

  def show
    @book = Book.find(params[:id])
  end

  def edit
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book)
    else
      @books = Book.all
      render :index
    end
  end

  def update
  end

  def destroy
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

end
