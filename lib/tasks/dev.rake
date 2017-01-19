namespace :dev do

  desc "Setup Development"
  task setup: :environment do

    images_path = Rails.root.join('public', 'system')

    puts "Executando o setup para o desenvolvimento..."

    puts "Apagando public/system #{%x(rm -rf #{images_path})}"
    puts %x(rails db:drop:_unsafe)
    puts %x(rails db:create)
    puts %x(rails db:migrate)
    puts %x(rails db:seed)
    puts %x(rails dev:generate_admins)
    puts %x(rails dev:generate_member_default)
    puts %x(rails dev:generate_members)
    puts %x(rails dev:generate_ads)
    puts %x(rails dev:generate_comments_and_avaliations)
    puts %x(rails dev:orgazine_stars)

    puts "Setup executado com sucesso!"
  end
############################################################

  desc "Cria Administradores Fakes"
  task generate_admins: :environment do
    puts "Cadastrar ADMINISTRADORES FAKES..."

    10.times do
      Admin.create!(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password: "123456",
        password_confirmation: "123456",
        role: [0,0,1,1,1].sample
        )
    end

    puts "Cadastrar ADMINISTRADORES FAKES... [OK]"
  end
############################################################

  desc "Cria o membro padrão"
  task generate_member_default: :environment do
    puts "Cadastrar MEMBRO PADRÃO..."

      Member.create!(
        email: "member@member.com",
        password: "123456",
        password_confirmation: "123456"
        )

    puts "Cadastrar MEMBRO PADRÃO... [OK]"
  end
############################################################

  desc "Cria Membros Fakes"
  task generate_members: :environment do
    puts "Cadastrar MEMBROS FAKES..."

    100.times do
      Member.create!(
        email: Faker::Internet.email,
        password: "123456",
        password_confirmation: "123456"
        )
    end

    puts "Cadastrar MEMBROS FAKES... [OK]"
  end
############################################################

  desc "Cria Anúncios Fakes"
  task generate_ads: :environment do
    puts "Cadastrar ANÚNCIOS FAKES..."

    10.times do
      Ad.create!(
        title: Faker::Lorem.sentence([2,3,4,5].sample),
        description_md: markdown_fake,
        description_short: LeroleroGenerator.sentence,
        member: Member.first,
        category: Category.all.sample,
        price: "#{Random.rand(500)},#{Random.rand(99)}",
        finish_date: Date.today + Random.rand(1..90),
        picture: File.new(Rails.root.join('public', 'templates',
                                          'images-for-ads',
                                          "#{Random.rand(9)}.jpg"),
                                          'r')
        )
    end

    100.times do
      Ad.create!(
        title: Faker::Lorem.sentence([2,3,4,5].sample),
        description_md: markdown_fake,
        description_short: LeroleroGenerator.sentence,
        member: Member.all.sample,
        category: Category.all.sample,
        price: "#{Random.rand(500)},#{Random.rand(99)}",
        finish_date: Date.today + Random.rand(1..90),
        picture: File.new(Rails.root.join('public', 'templates',
                                          'images-for-ads',
                                          "#{Random.rand(9)}.jpg"),
                                          'r')
        )
    end

    puts "Cadastrar ANÚNCIOS FAKES... [OK]"
  end
############################################################

  desc "Cria Comentários e Avaliações Fakes"
  task generate_comments_and_avaliations: :environment do
    puts "Cadastrar COMENTÁRIOS e AVALIAÇÕES FAKES..."

    Ad.all.each do |ad|
      Random.rand(1..3).times do
        Comment.create!(
          body: Faker::Lorem.paragraph([1,2,3].sample),
          member: Member.all.sample,
          ad: ad
          )
      end

      Random.rand(1..3).times do
        obj = "Ad".classify.constantize.find(ad.id)
        obj.rate(Random.rand(1..5).to_f, Member.all.sample, 'quality')
      end
    end

    puts "Cadastrar COMENTÁRIOS e AVALIAÇÕES FAKES... [OK]"
  end
############################################################

  desc "Organiza em campos separados a quantidade de estrelas pelo seu valor"
  task orgazine_stars: :environment do
    puts "Organizando as ESTRELAS/AVALIAÇÕES..."

    Ad.all.each do |ad|

      if ad.rates('quality').exists?

        stars = StarsOfComment.new
        rates = Rate.where(rateable_id: ad.id)

        rates.all.each do |rate|
          stars.increment(:stars5, by = 1) if rate.stars == 5
          stars.increment(:stars4, by = 1) if rate.stars == 4
          stars.increment(:stars3, by = 1) if rate.stars == 3
          stars.increment(:stars2, by = 1) if rate.stars == 2
          stars.increment(:stars1, by = 1) if rate.stars == 1
          stars.increment(:totalStars, by = rate.stars)
          stars.ad_id = ad.id
        end

        stars.save

        stars.average_stars5 = StarsOfComment.where(id: StarsOfComment.last).sum("((stars5*5)*100) / totalStars")
        stars.average_stars4 = StarsOfComment.where(id: StarsOfComment.last).sum("((stars4*4)*100) / totalStars")
        stars.average_stars3 = StarsOfComment.where(id: StarsOfComment.last).sum("((stars3*3)*100) / totalStars")
        stars.average_stars2 = StarsOfComment.where(id: StarsOfComment.last).sum("((stars2*2)*100) / totalStars")
        stars.average_stars1 = StarsOfComment.where(id: StarsOfComment.last).sum("(stars1*100) / totalStars")

        stars.save

      end
    end

    puts "Organizando as ESTRELAS/AVALIAÇÕES... [OK]"
  end
############################################################

  def markdown_fake
    %x(ruby -e "require 'doctor_ipsum'; puts DoctorIpsum::Markdown.entry")
  end
end

# stars5 = 0
# stars4 = 0
# stars3 = 0
# stars2 = 0
# stars1 = 0
# Rate.all.each do |rate|
#   stars5 = stars5 + rate.stars if rate.stars == 5
#   stars4 = stars4 + rate.stars if rate.stars == 4
#   stars3 = stars3 + rate.stars if rate.stars == 3
#   stars2 = stars2 + rate.stars if rate.stars == 2
#   stars1 = stars1 + rate.stars if rate.stars == 1
# end
# stars5 = stars5 / 5
# stars4 = stars4 / 4
# stars3 = stars3 / 3
# stars2 = stars2 / 2
# stars1 = stars1 / 1