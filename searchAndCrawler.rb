#!/usr/bin/env ruby
# Enio Silva
# Florianopolis, 19/05/2015

require 'tweetstream'
require "yaml"

# CONFIGURAÇÃO DE BUSCA: PALAVRA CHAVE E IDIOMA
@keywords      = "masterchef,comida" #ARGV[0]
@languages     = "pt,en" #ARGV[1]
# FINAL DAS CONFIGURAÇÕES DE BUSCA

# CONFIGURAÇÃO DA CONTA NO TWITTER VIA YAML
unless ENV['TW_CONSUMER_KEY']
  @oauth = YAML.load_file(File.expand_path("./conf/credentials.yml"))

  ENV['TW_CONSUMER_KEY'] = @oauth["consumer_key"]
  ENV['TW_CONSUMER_SECRET'] = @oauth["consumer_secret"]
  ENV['TW_OAUTH_TOKEN'] = @oauth["access_token"]
  ENV['TW_OAUTH_TOKEN_SECRET'] = @oauth["access_token_secret"]
end
# FINAL DAS CONFIGURAÇÕES VIA YAML

# CONFIGURAÇÃO DA INSTANCIA DO TWEETSTREAM
TweetStream.configure do |config|
  config.consumer_key       = ENV['TW_CONSUMER_KEY']
  config.consumer_secret    = ENV['TW_CONSUMER_SECRET']
  config.oauth_token        = ENV['TW_OAUTH_TOKEN']
  config.oauth_token_secret = ENV['TW_OAUTH_TOKEN_SECRET']
  config.auth_method        = :oauth
end
# FINAL DA CONFIGURAÇÃO DA INSTANCIA DO TWEETSTREAM

@client = TweetStream::Client.new

# VALIDAÇÃO DO USUÁRIO NO TWITTER
@client.on_error do |message|
  puts message
end
@client.on_limit do |skip_count|
  puts "You lost #{skip_count} tweets"
end
# FINAL DA VALIDAÇÃO DO USUÁRIO

# INICIO DA BUSCA PELAS PALAVRAS CHAVES NOS IDIOMAS ESCOLHIDOS
@client.filter(:track => @keywords, :language => @languages) do |status|
  puts "#{Time.now}:: #{status.text}"
end

