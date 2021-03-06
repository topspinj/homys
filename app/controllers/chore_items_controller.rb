class ChoreItemsController < ApplicationController

	before_action :authenticate_user!, :ensure_house_exists, :get_house, :verified_phone


	def create
		@chore_item = ChoreItem.new(chore_item_params)
		@chore_item.owner = current_user
		@chore_item.house = @house
		@chore_item.user = @house.users.sample

		respond_to do |format|
			if @chore_item.save
				format.html { redirect_to house_chore_items_path(current_user.house), notice: 'Chore added.' }
	      format.js {}

			else
				format.html { render :index, alert: 'There was an error.'  }
	      format.js { render status: '422'}
			end
		end
	end

	def index
		@chore_items = @house.chore_items.all.page(params[:page])
		@chore_item = ChoreItem.new

		if @chore_items.count == nil
  	     flash[:alert] = "You have no chore items. Create one now."
		end

		respond_to do |format|
      format.html
      format.js
    end
	end

	def chore_assigner
		current_user.house.assign_chores

		redirect_to house_chore_items_path(current_user.house)
	end

	def destroy
		@chore_item = ChoreItem.find(params[:id])
		@chore_item.destroy
		redirect_to house_chore_items_path(current_user.house_id)
	end

	def update
		@chore_item = ChoreItem.find(params[:id])
		@chore_item.done = 1
		current_user.total_points += @chore_item.points_rewarded
		@chore_item.save
		current_user.save

		redirect_to house_chore_items_path(current_user.house), notice: "+ #{@chore_item.points_rewarded} points!"
	end

	def show
		@chore_items = ChoreItem.where(user_id: current_user.id)

	end

private

	def chore_item_params
		params.require(:chore_item).permit(:name, :description, :user_id, :owner_id)
	end

end
