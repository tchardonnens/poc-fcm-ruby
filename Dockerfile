FROM ruby:3.3.0

WORKDIR /usr/src/app

COPY . .

RUN gem install httparty json googleauth dotenv

CMD ["ruby", "./fmc-pusher.rb"]
