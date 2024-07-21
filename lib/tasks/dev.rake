namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando BD...") { %x(rails db:drop) }
      show_spinner("Apagando BD...") { %x(rails db:create) }
      show_spinner("Migrando BD...") { %x(rails db:migrate) }
      %x{rails dev:add_mining_types}
      %x{rails dev:add_coins}
    else 
      puts "Você não está em ambiente de desenvolvimento!"
    end
  end
  
  desc "Cadastra as moedas"
  task add_coins: :environment do
    show_spinner("Cadastrando moedas...") do
      coins = [ 
          { 
            description: "Bitcoin",
            acronym: "BTC",
            url_image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRhaFwngz-dg-A1V2DSkgheyyhAcnz2b8fTqA&s",
            mining_type: MiningType.find_by(acronym: 'PoW')
          },

          {
            description: "Ethereum",
            acronym: "ETH",
            url_image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVD0qsRPICIt6CHX9_ygwuSrqCHRt_wEGY1Q&s",
            mining_type: MiningType.all.sample
          },

          { 
            description: "Dash",
            acronym: "DASH",
            url_image: "data:image/png;base64,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",
            mining_type: MiningType.all.sample
          },

          { 
            description: "Iota",
            acronym: "IOT",
            url_image: "https://s2.coinmarketcap.com/static/img/coins/200x200/1720.png",
            mining_type: MiningType.all.sample
          },

          { 
            description: "ZCash",
            acronym: "ZEC",
            url_image: "https://s2.coinmarketcap.com/static/img/coins/200x200/1437.png",
            mining_type: MiningType.all.sample
          }
      ]

      coins.each do |coin|
        Coin.find_or_create_by!(coin)
      end
    end
  end
  
  desc "Cadastra os tipos de mineração"
  task add_mining_types: :environment do
    show_spinner("Cadastrando tipos de mineração...") do
      mining_types = [
        {description: "Proof of Work", acronym: "PoW"},
        {description: "Proof of Stack", acronym: "PoS"},
        {description: "Proof of Capacity", acronym: "PoC"}
      ]

      mining_types.each do |mining_type|
        MiningType.find_or_create_by!(mining_type)
      end
    end
  end

  private
  def show_spinner(msg_start, msg_end = "Concluído!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end

end
