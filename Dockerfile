FROM elixir:1.7.4

ARG mix_env=prod
ENV MIX_ENV $mix_env

# 
RUN mkdir /app
WORKDIR /app

EXPOSE 4000
EXPOSE 4001

ADD . /app
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install hex phx_new 1.4.1 
RUN mix deps.get
RUN mix deps.update gettext

RUN mix compile 

CMD ["mix", "phx.server"]
