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
    puts %x(rails dev:generate_comments)

    puts "Setup executado com sucesso!"
  end

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

  desc "Cria Comentários Fakes"
  task generate_comments: :environment do
    puts "Cadastrar COMENTÁRIOS FAKES..."

    Ad.all.each do |ad|
      Random.rand(1..3).times do
        Comment.create!(
          body: Faker::Lorem.paragraph([1,2,3].sample),
          member: Member.all.sample,
          ad: ad)
      end
    end

    puts "Cadastrar COMENTÁRIOS FAKES... [OK]"
  end

  def markdown_fake
    %x(ruby -e "require 'doctor_ipsum'; puts DoctorIpsum::Markdown.entry")
  end
end
