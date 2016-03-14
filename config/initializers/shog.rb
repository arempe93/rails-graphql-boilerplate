Shog.configure do

  if ::Rails.env.production?
    reset_config!
    timestamp
  end

  match /REQUEST|QUERY|POST\sPARAMS/ do |msg, _|

    msg.green.bold
  end

  match /API\sERROR/ do |msg, _|

    msg.red.bold
  end
end