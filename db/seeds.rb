# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 初始化用户
user = User.find_or_initialize_by(userid: 333)
user.name = "Jim"
user.mobile = "185****0248"
user.email = "4445**@qq.com"
user.avatar = "https://wework.qpic.cn/wwhead/nMl9ssowtibVGyrmvBiaibzDgAkicaQAEIs22YoPKIzSiapvIQMsGmm4zCjfutiaqiaVpS0bwMYuJfCKoQ/0"
user.save

