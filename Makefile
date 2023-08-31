precompile:
	RAILS_ENV=production ./bin/rails assets:precompile

deploy.prod: precompile
	 env MY_APP_DATABASE_URL='postgres://root:root@127.0.0.1:5432' ./bin/puma -C ./config/puma.rb

process.images:
	 mkdir -p app/assets/images/mockups/{thumbs,high}
	 ./bin/rails thumbnails:generate designs_dir=app/assets/images/mockups/ 
	 ./bin/rails highres:generate designs_dir=app/assets/images/mockups/ 
