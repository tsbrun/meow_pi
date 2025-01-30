require "test_helper"

class PhotosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @photo = photos(:one)
    @file = fixture_file_upload("tmp/sample_images/orange_cat.jpg", "image/jpg")

    unless @photo.file.attached?
      @photo.file.attach(io: File.open(@file), filename: "orange_cat.jpg", content_type: "image/jpg")
    end
  end

  test "should upload a cat pic" do
    assert_difference("Photo.count", 1) do
      post photos_url, params: { desc: @photo.desc, title: @photo.title, file: @file }, as: :json
    end

    assert_response :created
  end

  test "should delete a cat pic" do
    assert_difference("Photo.count", -1) do
      delete photo_url(@photo), as: :json
    end

    assert_response :no_content
  end

  test "should update a previously uploaded cat pic (image only)" do 
    patch photo_url(@photo), params: { file: @file }
    assert_response :success
  end

  test "should update a previously uploaded cat pic (metadata only)" do 
    patch photo_url(@photo), params: { title: "Updated Title" }
    assert_response :success
  end

  test "should return 400 bad request when no updates are made" do 
    patch photo_url(@photo), params: {} # No file, no metadata
    assert_response :bad_request
    assert_match "No updates were made.", response.body
  end

  test "should return 422 unprocessable entity when file upload fails" do 
    patch photo_url(@photo), params: { file: "invalid_file" } # Not a real file
    assert_response :unprocessable_entity
    assert_match "Failed to attach file", response.body
  end

  test "should return 404 not found when updating a nonexistent photo" do
    patch photo_url("nonexistent-id"), params: { title: "This won't work" }
    assert_response :not_found
    assert_match "Photo not found", response.body
  end

  test "should fetch a cat pic by its id" do 
    get photo_url(@photo), as: :json
    assert_response :success
  end

  test "fetch a list of uploaded cat pics" do
    get photos_url, as: :json
    assert_response :success
  end
end
