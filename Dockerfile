FROM ruby:3.1.2
RUN mkdir app && mkdir app/lib && mkdir app/spec
ADD lib /app/lib
ADD Gemfile /app
ADD dwolla_v2.gemspec /app
ADD Rakefile /app
ADD spec /app/spec
WORKDIR /app
RUN bundle install
CMD ["rake", "spec"]