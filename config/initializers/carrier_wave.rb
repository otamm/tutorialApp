if Rails.env.production? # to be used only on production with Amazon web server.
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Configuration for Amazon S3
      :provider              => 'AWS',
      :aws_access_key_id     => ENV['S3_ACCESS_KEY'],
      :aws_secret_access_key => ENV['S3_SECRET_KEY']
    }
    config.fog_directory     =  ENV['S3_BUCKET']
  end
end

# run this on terminal to set it up:
#$ heroku config:set S3_ACCESS_KEY=<access key>
#$ heroku config:set S3_SECRET_KEY=<secret key>
#$ heroku config:set S3_BUCKET=<bucket name>
