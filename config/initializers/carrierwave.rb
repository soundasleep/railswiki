require_dependency "carrierwave"

CarrierWave.configure do |config|
  config.root = Rails.root
  CarrierWave.tmp_path = Rails.root.join 'tmp/uploads'
end
