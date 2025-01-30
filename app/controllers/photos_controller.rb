class PhotosController < ApplicationController
  before_action :set_photo, only: %i[ show update destroy ]

  # GET /photos
  def index
    @photos = Photo.all
    render json: { photos: @photos.map { |photo| format_photo_response(photo) } }
  end

  # GET /photos/1
  def show
    render json: format_photo_response(@photo)
  end

  # POST /photos
  def create
    @photo = Photo.new(photo_params)
  
    if @photo.save
      attach_file(@photo, file_params[:file]) if file_params.present?
      render json: format_photo_response(@photo), status: :created
    else
      render json: { errors: @photo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /photos/1
  def update
    updated = false

    if photo_params.present?
      updated = @photo.update(photo_params)
    end
  
    if file_params.present?
      attach_file(@photo, file_params[:file])
      updated = true
    end
  
    if updated
      render json: format_photo_response(@photo)
    else
      render json: { errors: @photo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /photos/1
  def destroy
    @photo.destroy!
    head :no_content
  end

  private
    def set_photo
      @photo = Photo.find(params[:id])
    end

    def photo_params
      params.permit(:title, :desc)
    end

    def file_params
      params.permit(:file)
    end

    def attach_file(photo, file)
      return unless file.respond_to?(:path) && file.respond_to?(:content_type)
    
      photo.file.purge if photo.file.attached? # Remove old file if updating
      photo.file.attach(file)
    end

    # Format JSON response
    def format_photo_response(photo)
      {
        id: photo.id,
        title: photo.title,
        desc: photo.desc,
        file: photo.file.attached? ? url_for(photo.file) : nil
      }
    end
end
