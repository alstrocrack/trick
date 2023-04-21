FROM ruby:3.1.1

RUN apt update && apt upgrade -y

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
