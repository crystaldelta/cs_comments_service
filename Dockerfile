FROM forum-ruby-2.4.1:latest
#580093319952.dkr.ecr.ap-southeast-2.amazonaws.com/forum-ruby-2.4.1:latest

RUN apk update
RUN apk add nodejs
RUN apk add git
RUN apk add nginx

RUN adduser -S www-data
RUN addgroup -S www-data && adduser -S forum -G www-data -h /edx/app/forum
RUN adduser -S supervisor

RUN mkdir -p /edx/app/forum
RUN chown -R forum:www-data /edx/app/forum

COPY ./ci-aws/stg/forum.yml /edx/app/forum/forum_env
RUN chown forum:www-data /edx/app/forum/forum_env
RUN chmod 0644 /edx/app/forum/forum_env

RUN mkdir -p /edx/var/forum
RUN chown -R www-data:www-data /edx/var/forum
RUN chmod 0777 /edx/var/forum

USER supervisor

RUN mkdir -p /edx/var/log/supervisor

COPY ./ci-aws/$CD_EDX_ENV/forum.conf /edx/app/supervisor/conf.available.d/forum.conf
RUN chown supervisor:supervisor /edx/app/supervisor/conf.available.d/forum.conf
RUN chmod 0644 /edx/app/supervisor/conf.available.d/forum.conf
#enable supervisor

COPY ./ci-aws/forum-supervisor.sh /edx/app/forum/forum-supervisor.sh
RUN chmod 0755 /edx/app/forum/forum-supervisor.sh

USER forum
COPY . /edx/app/forum/cs_comments_service/
RUN rm Gemfile.lock
RUN bundle install --deployment --path $GEM_HOME chdir=/edx/app/forum/cs_comments_service

RUN /edx/app/supervisor/venvs/supervisor/bin/supervisorctl -c /edx/app/supervisor/conf.d update
RUN /edx/app/supervisor/venvs/supervisor/bin/supervisorctl -c /edx/app/supervisor/conf.d start

RUN bundle install

#CMD [ "ruby", "app.rb" ]
