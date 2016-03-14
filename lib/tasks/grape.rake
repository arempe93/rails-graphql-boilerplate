namespace :grape do
  desc 'Print compiled API routes'
  task routes: :environment do
    API::Base.routes.each do |r|
      puts "#{r.route_method}\t#{r.route_path}"
    end
  end
end