require 'tensorflow'
require 'nmatrix'

class ConvertImageToVector
  DIMENSION = 1

  def initialize(image_path)
    @image_path = image_path
  end

  def convert_to_vector
    image_matrix = Tf::Image.decode_jpeg(read_jpeg).value
    float32_matrix= [image_matrix].to_nm(nil, :float32)
    vector_size = convert_to_numo_matrix(float32_matrix).shape.reduce(:*)
    convert_to_numo_matrix(float32_matrix).reshape(DIMENSION, vector_size).to_a
  end

  private

  attr_reader :image_path

  def convert_to_numo_matrix(matrix)
    matrix.to_a.flatten(1).to_nm
  end

  def read_jpeg
    Tf::IO.read_file(image_path)
  end
end

print ConvertImageToVector.new('images/face.jpg').convert_to_vector
