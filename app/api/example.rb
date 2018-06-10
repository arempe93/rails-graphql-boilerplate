# frozen_string_literal: true

module API
  class Example < Grape::API
    params do
      requires :who, type: String
    end
    get :example do
      sdas
      { hello: params[:who] }
    end
  end
end
