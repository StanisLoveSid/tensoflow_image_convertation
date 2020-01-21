require 'aws-sdk-rekognition'
require 'mini_magick'

class CaptureFace
  ENVFILE_PATH = File.join('./.env')
  CAPTURED_FACES_PATH = './captured_faces'
  DATA_SAMPLES_PATH = './data_samples'

  def initialize(image_path)
    read_env_file
    @image_path = image_path
    @client = connect_to_aws_rekognition
    @coordinates = {}
  end

  def read_env_file
    File.foreach(ENVFILE_PATH) do |line|
      key, value = line.split "="
      ENV[key] = value.strip
    end
  end

  def add_credentials
    Aws::Credentials.new(ENV['AWS_KEY'], ENV['AWS_SECRET'])
  end

  def connect_to_aws_rekognition
    Aws::Rekognition::Client.new(region: ENV['AWS_REGION'],
                                 credentials: add_credentials)
  end

  def aws_response
    @client.detect_faces(image: { bytes: File.read(@image_path) })
  end

  def set_coordinates
    @coordinates[:ulx] = open_image.width * aws_response.face_details.first.bounding_box.left
    @coordinates[:uly] = open_image.height * aws_response.face_details.first.bounding_box.top
    @coordinates[:w] = open_image.width * aws_response.face_details.first.bounding_box.width
    @coordinates[:h] = open_image.height * aws_response.face_details.first.bounding_box.height
  end

  def open_image
    MiniMagick::Image.open(@image_path)
  end

  def crop_image
    set_coordinates
    cropped_image = open_image.crop("#{@coordinates[:w]}x#{@coordinates[:h]}+#{@coordinates[:ulx]}+#{@coordinates[:uly]}")
    cropped_image.write("#{CAPTURED_FACES_PATH}/#{open_image.path.split('/').last}")
    cropped_image.write("#{DATA_SAMPLES_PATH}/#{open_image.path.split('/').last}")
  end
end

