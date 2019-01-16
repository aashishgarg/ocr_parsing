class Api::DashboardController < ApplicationController
  # Before Actions
  authorize_resource :class => self

  def index
    @bol = BolFile.get_filtered_data(params)
    render json: @bol
  end
end