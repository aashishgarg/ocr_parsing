class Api::ShippersController < ApplicationController
  include Api::Concerns::ShippersApipie
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

  def set_shipper
    @shipper = Shipper.find(params[:id])
  end

  def shipper_params
    params.require(:shipper).permit(:name, :address1, :address2, :city, :state, :zip,
                                    :contact_name, :contact_phone, :contact_fax, :contact_email)
  end
end