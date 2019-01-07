# TODO: Need to improve for better implementation

class Api::ShippersController < ApplicationController
  before_action :set_shipper, except: [:create, :index]

  def index
    @shippers = Shipper.all # ToDo: Apply pagination
  end

  def show; end

  def create
    @shipper = Shipper.new(shipper_params)

    unless @shipper.save
      render json: { errors: @shipper.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @shipper.update(shipper_params)
      render 'create'
    else
      render json: { errors: @shipper.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @shipper.destroy
  end

  private

  # def set_user
  #   @user = User.where(email: user_params[:email]).first_or_create
  #   @user.first_name = user_params[:first_name]
  #   @user.last_name = user_params[:last_name]
  #   @user.phone = user_params[:phone]
  #   @user.fax = user_params[:fax]
  #   @user.password = (user_params[:password] || ('a'..'z').to_a.shuffle[0,8].join)
  #
  #   # params[:shipper][:user_attributes][:id] = @user.iddb/migrate/20190107062308_add_contact_details_to.rb
  # end

  def set_shipper
    @shipper = Shipper.find(params[:id])
  end

  def shipper_params
    params.require(:shipper).permit(:name, :address1, :address2, :city, :state, :zip,
                                    :contact_name, :contact_phone, :contact_fax, :contact_email)
  end
  #
  # def user_params
  #   params[:shipper][:user_attributes]
  # end
end