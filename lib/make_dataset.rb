require_relative 'capture_face'
require_relative 'convert_image_to_vector'
require 'aws-sdk-s3'

Dir.glob('./images/*').each do |file|
  capture_face = CaptureFace.new(file)
  capture_face.read_env_file
  capture_face.crop_image
end

Dir.glob('./captured_faces/*').each do |file|
  vector = ConvertImageToVector.new(file).convert_to_vector
  file_name = file.split('/').last.split('.').first
  File.open("./data_samples/#{file_name}", 'w') { |f| f.write(vector) }
end

s3 = Aws::S3::Resource.new(region:'eu-west-2', 
                           access_key_id: ENV['AWS_KEY'],
                           secret_access_key: ENV['AWS_SECRET'])


Dir.glob('./data_samples/*').each do |file|
  file_name = file.split('/').last
  obj = s3.bucket('datasamplesrekogntion1').object(file_name)
  obj.upload_file(file)
end
