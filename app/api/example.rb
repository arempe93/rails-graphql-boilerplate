# frozen_string_literal: true

module API
  class Example < API::Core
    get :example do
      { hello: 'world' }
    end
  end
end
