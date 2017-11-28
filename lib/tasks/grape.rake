namespace :grape do
  desc 'Print compiled API routes'
  task routes: :environment do
    API::Base.routes.each do |r|
      puts "#{r.request_method}\t#{r.path}"
    end
  end
end
