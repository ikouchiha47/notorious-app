precompile:
	RAILS_ENV=production ./bin/rake assets:clean assets:precompile

copy.assets:
	sudo mkdir -p /var/www/notorious-app/public
	sudo rsync -r /home/shredder/dev/notorious-app/public/ /var/www/notorious-app/public/

prod.seed:
	 RAILS_ENV=production MY_APP_DATABASE_URL='postgres://root:root@127.0.0.1:5432' ./bin/rake db:seed

deploy.prod: precompile copy.assets
	 env MY_APP_DATABASE_URL='postgres://root:root@127.0.0.1:5432' ./bin/puma -C ./config/puma.rb

process.images:
	 mkdir -p app/assets/images/mockups/thumbs
	 mkdir -p app/assets/images/mockups/high
	 ./bin/rails thumbnails:generate designs_dir=app/assets/images/mockups/ 
	 ./bin/rails highres:generate designs_dir=app/assets/images/mockups/ 

