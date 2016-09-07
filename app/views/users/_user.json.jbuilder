json.extract! user, :id, :fname, :lname, :email, :password, :updated_at
json.url user_url(user, format: :json)
