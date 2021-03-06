class HousesController < ApplicationController
  before_action :verified_phone, :except => [:index, :show]
  before_action :authenticate_user!, :except => [:index]

  def create
  	@house = House.new(house_params)
    @house.users << current_user

  	if @house.save
  		redirect_to house_path(@house)
  	else
  		render :new
  	end

  end

  def add_housemate #maybe change to update
  	@user = User.find_by(email: params[:email])
  	if @user
      if @user.house_id == nil
        @user.house_id = current_user.house_id
      	@user.save
      	redirect_to house_path(current_user.house)
      else
      	redirect_to house_path(current_user.house), notice: "User cannot be assigned to this house"
      end
    else
      redirect_to house_path(current_user.house), alert: "User does not exist, invite homy below"
    end
  end

  def invite_housemate
     HomysMailer.invite(params[:email], current_user).deliver_now
     redirect_to house_path(current_user.house), notice: "Sent invite email to your homy"
  end


  def show
  	@house = House.find(params[:id])
    @users = @house.users.order('total_points DESC')
    @events = @house.events.all
    @event = Event.new
  end

  def destroy
    if params[:id] == "user"
      current_user.house_id = nil
      redirect_to houses_path
    else
      @house = House.find(params[:id]) # do i need to remove users associations to the house before?
      @house.destroy
      redirect_to houses_path
    end
  end

  def index
    if current_user
      if current_user.house_id != nil
        redirect_to house_path(current_user.house)
      else
        @house = House.new
      end
    else
      redirect_to welcome_index_path
    end
  end


  private

  def house_params
  	params.require(:house).permit(:name)
	end

end