class PicsController < ApplicationController
  def index
    @pics = Pic.order(created_at: 'DESC')
  end

  def new
    @pic = Pic.new
  end

  def create
    @pic = Pic.new(pic_params)

    return render :new if !@pic.valid?

    timestamp = Time.current.strftime('%Y%m%d%H%M%S%L')
    @pic.file_name = "#{ timestamp }_#{ @pic.file.original_filename }"

    output_path = Rails.root.join('public', 'pics', @pic.file_name)

    File.open(output_path, 'w+b') do |fp|
      fp.write @pic.file.read
    end

    @pic.save

    redirect_to action: 'index'
  end

  private

  def pic_params
    params.require(:pic).permit(:title, :file)
  end
end
