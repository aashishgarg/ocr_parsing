module Api
  class DashboardController < ApplicationController
    include Api::Docs::DashboardApipie
    # Before Actions
    authorize_resource class: self

    def index
      errors = []
      begin
        data = BolFile.dashboard_hash(params)
      rescue FilterColumnAndValuesNotSame, FilterColumnOrValuesNotArray, ColumnNotValid => e
        errors << e.class.to_s
      end

      if errors.present?
        render json: { errors: errors }
      else
        render json: data
      end
    end
  end
end
