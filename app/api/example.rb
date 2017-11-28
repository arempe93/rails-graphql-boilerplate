module API
  class Example < Grape::API
    get :example do
      { hello: 'world' }
    end
  end
end
