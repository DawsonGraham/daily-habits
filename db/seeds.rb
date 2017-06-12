5.times do
  User.create(
    first_name: Faker::Superhero.name,
    last_name: Faker::Superhero.name,
    phone_number: Faker::PhoneNumber.phone_number,
    email: Faker::Internet.email,
    password: Faker::Superhero.name
  )
end

10.times do
  Question.create(
    title: Faker::Superhero.name,
    user_id: rand(1..5)
  )
end

5.times do
  BooleanAnswer.create(
    response: [true, false].sample,
    question_id: rand(1..5)
  )
end

5.times do
  IntegerAnswer.create(
    response: [1, 2, 3, 4, 5].sample,
    question_id: rand(1..5)
  )
end

5.times do
  TextAnswer.create(
    response: Faker::ChuckNorris.fact,
    question_id: rand(1..5)
  )
end