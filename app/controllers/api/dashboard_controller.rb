module Api
  class DashboardController < ApplicationController
    include Api::Docs::DashboardApipie
    # Before Actions
    authorize_resource class: self

    def index
      begin
        data = BolFile.data_hash(params)
      rescue FilterColumnAndValuesNotSame, FilterColumnOrValuesNotArray, ColumnNotValid => e
        errors = []
        errors << e.class.to_s
      end
      errors.present? ? render(json: { errors: errors }) : render(json: data)
    end
  end
end
