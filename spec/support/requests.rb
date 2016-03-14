module Support
  module Requests
    
    def app
      described_class
    end

    def json
      JSON.parse(last_response.body).deep_symobolize_keys
    end

  end
end