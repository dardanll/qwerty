require "sinatra/base"
require "sinatra/flash"
require "./lib/qwerty/classifier"

module Qwerty
  class TrainClassifier < Sinatra::Base
    register Sinatra::Flash
    set :root, "./"

    get "/train_set" do
      text = "Visit the sick, feed the hungry, free the captive."
      tagged_words = ots.summary(text)[:tags]
      erb :train_classifier, locals: { text: text, tags: tagged_words}
    end

    post "/train_set/new" do
      tagged_words = params[:tags]
      text = params[:text]

      bayes = Qwerty::Classifier::Bayes.new
      train_classifier = bayes.train_classifier(text, tags: tagged_words)

      logger.info "#{train_classifier}"
      flash[:success] = train_classifier
      redirect "/train_set"
    end

    def ots
      @ots ||= Qwerty::Classifier::Ots.new
    end
  end
end
