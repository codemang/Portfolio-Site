FROM "resin/raspberry-pi-alpine"

RUN apk update && apk upgrade
RUN apk add curl git
RUN apk add build-base
RUN apk add zlib-dev  openssl-dev readline-dev yaml-dev libxml2-dev libxslt-dev

RUN git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv
RUN echo '# rbenv setup' > /etc/profile.d/rbenv.sh
RUN echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/rbenv.sh
RUN echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
RUN chmod +x /etc/profile.d/rbenv.sh
RUN mkdir /usr/local/rbenv/plugins
RUN git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build
RUN PREFIX=/usr/local /usr/local/rbenv/plugins/ruby-build/install.sh
ENV PATH=/usr/local/rbenv/shims:/usr/local/rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN rbenv install 2.4.1

ENV PATH=/root/.rbenv/shims:/usr/local/rbenv/shims:/usr/local/rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile
RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc

RUN rbenv global 2.4.1
RUN gem install bundler

EXPOSE 80
RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install

# Copy app after the gemfile and bundling so that changes to app code don't
# invalidate the gems cache
COPY . /app
ENV PATH="/root/.rbenv/shims:/usr/local/rbenv/shims:/usr/local/rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

RUN RACK_ENV=production rake assets:clean
RUN RACK_ENV=production rake assets:precompile
CMD RACK_ENV=production bundle exec rackup -p 80 -o '0.0.0.0'
