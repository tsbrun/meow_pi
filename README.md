# MeowPI
### Cat Pic API 🐱

MeowPI is a RESTful API for uploading and managing cat pictures.

---

## 🏁 Getting Started
This project is Dockerized, so you don't need to install Rails, Postgres, or any dependencies manually. Just **fork** the repository, **build** the container, and everything else is **handled for you**.

### Step 1: Fork & Clone the Repository
```
git clone <SSH-key>
cd meow_pi
```

### Step 2: Build & Start the Container
```
docker-compose up --build
```
This will:
- Build the Docker image
- Run  `bundle install`
- Set up the database
- Start the Rails server inside the container

### Running Tests
```
rails test
```

### Stopping the Containers
```
docker-compose down
```

## 📌 POST /photos
### Upload a Cat Pic
**Request:**
- Content-Type: `multipart/form-data`
- Parameters:
```
title, type: string, The title of the photo.
desc, type: text, A short description of the photo.
file, type: file, The image file to be uploaded.
```
**Example Request (cURL):**
```
curl -X POST http://0.0.0.0:3000/photos \
  -F "title=Orange Cat" \
  -F "desc=No explanation needed..." \
  -F "file=@tmp/sample_images/orange_cat.jpg"
```
**Response (`201 Created`):**
```
{
  "id": "<id>",
  "title": "Orange Cat",
  "desc": "No explanation needed...",
  "file": "http://0.0.0.0:3000/rails/active_storage/blobs/redirect/.../orange_cat.jpg"
}
```

## 📌 PATCH /photos/:id
### Update a Previously Uploaded Cat Pic
**Request:**
- Content-Type: `multipart/form-data`
- Parameters: (Any combination of these can be updated)
```
title, type: string, required: No
desc, type: text, required: No
file, type: file, required: No
```
**Example Request (update only the image):**
```
curl -X PATCH http://0.0.0.0:3000/photos/<id> \
  -F "file=@tmp/sample_images/new_cat.jpg"
```
**Response (`200 OK`):**
```
{
  "id": "<id>",
  "title": "Orange Cat",
  "desc": "No explanation needed...",
  "file": "http://0.0.0.0:3000/rails/active_storage/blobs/redirect/.../new_cat.jpg"
}
```
**Errors:**

* `400 Bad Request` → No updates were made.
* `404 Not Found` → Photo ID does not exist.

## 📌 DELETE /photos/:id
### Delete a Cat Pic
**Example Request:**
```
curl -X DELETE http://0.0.0.0:3000/photos/<id>
```
**Response (`204 No Content`):**
No response body if successful.

**Errors:**
* `404 Not Found` → Photo ID does not exist.

## 📌 GET /photos/:id
### Fetch a Cat Pic by ID
**Example Request:**
```
curl -X GET http://0.0.0.0:3000/photos/<id>
```
**Response (200 OK):**
```
{
  "id": "<id>",
  "title": "Orange Cat",
  "desc": "No explanation needed...",
  "file": "http://0.0.0.0:3000/rails/active_storage/blobs/redirect/.../orange_cat.jpg"
}
```
**Errors:**
* `404 Not Found` → Photo ID does not exist.

## 📌 GET /photos
### Fetch a List of Uploaded Cat Pics
**Example Request:**
```
curl -X GET http://0.0.0.0:3000/photos
```
**Response (`200 OK`):**
```
{
  "photos": [
    {
      "id": "<id>",
      "title": "Orange Cat",
      "desc": "No explanation needed...",
      "file": "http://0.0.0.0:3000/rails/active_storage/blobs/redirect/.../orange_cat.jpg"
    },
    {
      "id": "<id>",
      "title": "Cat in Basket",
      "desc": "This is a photograph of a cat sitting in a basket!",
      "file": "http://0.0.0.0:3000/rails/active_storage/blobs/redirect/.../cat_in_basket.jpg"
    }
  ]
}
```
