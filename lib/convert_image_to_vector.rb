require 'tensorflow'
require 'nmatrix'

class ConvertImageToVector
  DIMENSION = 1

  def initialize(image_path)
    @image_path = image_path
  end

  def convert_to_vector
    Tf::Image.decode_jpeg(read_jpeg).to_ptr.get_array_of_float32(1, 128)
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

