module Api
  class DashboardController < ApplicationController
    include Api::Docs::DashboardApipie
    # Before Actions
    authorize_resource class: self

    def index
      render json: { data: BolFile.search(params), counts: BolFile.counts(params) }
    end
  end
end
