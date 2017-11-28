# Files in spec/api should test the api files located in app/api. The described class must be the API class constant
# in order to be recognized by Rack::Test.
#
# Example:
#
#  describe API::Foos do
#    context 'POST /foo' do
#      it 'should respond with bar' do
#        post '/api/foo'
#        expect(last_response.status).to eql 200
#        expect(json[:foo]).to eql 'bar'
#      end
#    end
#  end

describe API::Example do
  context 'GET /' do
    before do
      get '/example'
    end

    it 'should respond with 200' do
      expect_status 200
      expect(last_response.body).to eql 'hello world'
    end
  end
end
