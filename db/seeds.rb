# seed sounds

Sound.destroy_all

genres = ["danceedm","hiphoprap","ambient","electronic","indie","rock","trap","jazzblues"]

genres.each do |genre|
    req = "https://api-v2.soundcloud.com/charts?kind=trending&genre=soundcloud:genres:#{@genre}&limit=10&linked_partitioning=1&client_id=#{ENV["SOUNDCLOUD_CLIENT_ID"]}"
    track_res = HTTParty.get(req)
    track = JSON.parse track_res.body
    uri = track["collection"][0]["track"]["permalink_url"]
    embed_res = HTTParty.get("http://soundcloud.com/oembed?url=#{uri}&format=json")
    embed_info = JSON.parse embed_res.body
    embed_info["uri"] = uri
    Sound.create(genre: genre, embed_info: JSON.generate(embed_info))
end
