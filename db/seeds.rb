User.destroy_all

woeids = ["1154726","23424856","2295402","2391279","2418046"]

10.times do

  @user = User.create({
      fname: Faker::Name.first_name,
      lname: Faker::Name.last_name,
      email: Faker::Internet.email,
      password: "test",
      lat: Faker::Address.latitude.to_f,
      lng: Faker::Address.longitude.to_f,
      woeid: woeids.sample
    })

  5.times do
    @user.todos.create({
      completed: [true,false].sample,
      item: Faker::Hipster.word
      })
  end
end
