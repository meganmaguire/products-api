FROM ruby:3.4.10

WORKDIR /app

RUN apt-get update -qq && apt-get install -y build-essential

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-p", "3000"]