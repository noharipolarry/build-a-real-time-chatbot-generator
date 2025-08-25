# Bwmb Build A Real-Time Chatbot Generator

require 'json'
require 'open-uri'
require 'nokogiri'
require 'erb'

class ChatbotGenerator
  attr_reader :intents, :entities, :responses

  def initialize
    @intents = {}
    @entities = {}
    @responses = {}
  end

  def add_intent(name, phrases, response)
    @intents[name] = { phrases: phrases, response: response }
  end

  def add_entity(name, patterns)
    @entities[name] = patterns
  end

  def add_response(name, response)
    @responses[name] = response
  end

  def generate_chatbot
    template = ERB.new(File.read('chatbot_template.erb'), nil, '-')
    chatbot_code = template.result(binding)

    File.write('generated_chatbot.rb', chatbot_code)
  end

  def self.from_json(file)
    data = JSON.parse(File.read(file))
    generator = new

    data['intents'].each do |intent|
      generator.add_intent(intent['name'], intent['phrases'], intent['response'])
    end

    data['entities'].each do |entity|
      generator.add_entity(entity['name'], entity['patterns'])
    end

    data['responses'].each do |response|
      generator.add_response(response['name'], response['response'])
    end

    generator
  end
end

if $PROGRAM_NAME == __FILE__
  generator = ChatbotGenerator.from_json('chatbot_data.json')
  generator.generate_chatbot
end