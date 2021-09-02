class ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else 
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    item = Item.find_by(id: params[:id])
    if item 
      render json: item
    else 
      render json: {errors: "Item not found"}, status: :not_found
    end 
  end

  def create
    # byebug
    item = Item.create!(name: params[:name], price: params[:price], description: params[:description], user_id: params[:user_id])
    render json: item, status: :created
    rescue ActiveRecord::RecordInvalid => invalid
    render json: {errors: invalid.record.errors}, status: :unprocessable_entity
    
  end

  private 

  def not_found
    render json: {errors: "User not found"}, status: :not_found
  end

  def item_params
    params.permit(:name, :description, :price)
  end
end
