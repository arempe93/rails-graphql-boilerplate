# frozen_string_literal: true

module API
  class Example < API::Core
    params do
      requires :who, type: String
    end
    get :example do
      { hello: params[:who] }
    end
  end
end
