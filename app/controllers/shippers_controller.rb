# TODO: Need to improve for better implementation

class ShippersController < ApplicationController
  before_action :set_user, unless: [:index, :show]
  before_action :random_password, only: [:create, :update]

  def index
    @shippers = Shipper.all # ToDo: Apple pagination
  end

  def show
    @shipper = Shipper.find(params[:id])
  end

  def create
    @user.shippers.new(shipper_params)

    if user.save
      @shipper = @user.shippers.find_by(name: shipper_params[:name])
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  # It will create new user record if passed non-existing email
  def update
    @shipper = Shipper.find(params[:id])

    updated = if @shipper.user.email == @user.email
                @shipper.update(shipper_params)
              else
                Shipper.transaction do
                  user = User.where(email: user_params[:email]).first_or_create do |u|
                    u.first_name = user_params[:first_name]
                    u.last_name = user_params[:last_name]
                    u.phone = user_params[:phone]
                    u.fax = user_params[:fax]
                    u.password = user_params[:password]
                  end

                  params[:shipper].delete(:user_attributes)
                  @shipper.update(shipper_params.merge(user_id: user.id))
                end
              end

    if updated
      render 'create'
    else
      render json: { errors: @shipper.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    shipper = Shipper.find(params[:id])
    shipper.destroy
  end

  private

  def set_user
    @user = User.find_or_initialize_by(email: shipper_params[:user_attributes][:email])
    params[:shipper][:user_attributes][:id] = @user.id
  end

  def current_shipper
    @user.shippers.find_by(name: shipper_params[:name])
  end

  def shipper_params
    params.require(:shipper).permit(:name, :address1, :address2, :city, :state, :zip, user_attributes: [:id, :first_name, :last_name, :phone, :fax, :email, :password])
  end

  def user_params
    params[:shipper][:user_attributes]
  end

  def random_password
    user_params[:password] = (@user.password || ('a'..'z').to_a.shuffle[0,8].join)
  end
end