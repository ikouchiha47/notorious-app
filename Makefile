precompile:
	RAILS_ENV=production ./bin/rails assets:precompile

deploy.prod: precompile
	 env MY_APP_DATABASE_URL='postgres://root:root@127.0.0.1:5432' ./bin/puma -C ./config/puma.rb
