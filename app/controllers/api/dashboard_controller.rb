module Api
  class DashboardController < ApplicationController
    # Before Actions
    authorize_resource class: self

    def index
      render json: { data: BolFile.search(params), counts: BolFile.counts }
    end
  end
end
