# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
2..40.times do |i|
    User.create(id:        i,
                surname:   "Surname#{i}",
                firstname: "Firstname#{i}",
                email:     "cwl#{i}@aber.ac.uk",
                phone:     "01970 622422",
                grad_year: 1985)
end