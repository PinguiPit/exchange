class ExchangeController < ApplicationController
  def index
    @data = JSON.parse(request_api("https://data.messari.io/api/v1/assets?fields=slug,symbol,metrics"))
  end

  def calculate
    if params[:upload_from_csv].present?
      require 'csv'    
      btc = params[:btc].to_f
      eth = params[:eth].to_f
      car = params[:car].to_f
      csv_text = File.read(params[:upload_from_csv])
      csv = CSV.parse(csv_text, :headers => true)
      csv.each do |row|
        if row.to_hash["Moneda"] == "Bitcoin"
          money = row.to_hash["balance_ini"].to_f   
          @btcUsd = calculateCrypto(money, (row.to_hash["Interes_mensual"].to_f/100), btc )
          @usdBtc = calculateUsd( btc, @btcUsd )
        elsif row.to_hash["Moneda"] == "Ether"
          money = row.to_hash["balance_ini"].to_f
          @ethUsd = calculateCrypto(money, (row.to_hash["Interes_mensual"].to_f/100), eth )
          @usdEth = calculateUsd( eth, @ethUsd)
        elsif row.to_hash["Moneda"] == "Cardano"
          row.to_hash["Interes_mensual"].to_f/100
          money = row.to_hash["balance_ini"].to_f
          @adaUsd = calculateCrypto(money, (row.to_hash["Interes_mensual"].to_f/100), car )
          @usdAda = calculateUsd( car, @adaUsd )
        end
      end
    end
    respond_to do |format|
      format.js { render :template => "exchange/calculate.js.haml"}
    end
  end

  def prices
    prices = request_api("https://data.messari.io/api/v1/assets?fields=id,slug,symbol,metrics/market_data/price_usd")
     @prices = JSON.parse(prices)
      @prices["data"].each do |shareholder, index|
        if shareholder["slug"].titleize == "Bitcoin"
          @btc = shareholder["metrics"]["market_data"]["price_usd"]
        elsif shareholder["slug"].titleize == 'Ethereum'
          @eth = shareholder["metrics"]["market_data"]["price_usd"]
        elsif shareholder["slug"].titleize == "Cardano"   
          @car = shareholder["metrics"]["market_data"]["price_usd"]
        end  
      end
  end

  private

  def request_api(url)
    require 'rest-client'
    RestClient.get(url, headers={'x-messari-api-key' => "3741940e-0a6e-4523-8873-978caf587c68"})
  end

  def calculateCrypto(money, percentage, crypto )
    a = money/crypto
    b = a*percentage
    c = b * 12
    return c
  end

  def calculateUsd(crypto, calculatedCrypto )
    a = crypto
    d = calculatedCrypto*a
    return d
  end
end
