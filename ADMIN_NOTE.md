### All admins should contact CSG to set up their Kerberized super-user password.

### Server-side Installation
	* Should be bash (otherwise Capistrano will not work properly)
	* Generate key, put public key on GitHub

### Client-side Setting
	* Generate SSH key, put public key on the server (for Capistrano) and GitHub
	* Install RVM + Ruby + Gem + Rails (May need sudo or root access, depending on your client machine settings)
		``
		\curl -sSL https://get.rvm.io | bash -s stable --rails --ruby=1.9.3
		echo '[[ -s "/usr/local/rvm/scripts/rvm" ]] && . "/usr/local/rvm/scripts/rvm" >> ~/.bashrc
		``
	* Get source code from GitHub
		``
		cd <your-project-directory>
		git clone git@github.com:custom-computing-ic/tetracom-service.git
		``
	* Install gems for development
		``
		cd <tetracom-service>
		rvmsudo bundle install --without production
		``
	* Edit Capistrano settings 
		``
		vim config/deploy/production.rb
		Change cpc10 to your user name
		``

### Development and Deployment
	* Do your own development, to run development server
		``rails s -p 55558``
	* Commit the updates to GitHub
		``
		git add .
		git commit -m "<log message>"
		git push origin
		``
	* Deploy the source code (update the production server)
		``cap production deploy``

### Backup and Restore Database
	* Check the user name, password and database name in the server ``/var/www/tetracom-service/shared/config/database.yml``
	* Backup
		``pg-dump -U <user name> -h localhost -Fc -f <backup file name> <database name>``
	* Stop the database and restore data
		``
		service apache2 stop
		dropdb -U <user name> -h localhost <database name>
		pg-restore -U <user name> --password -h localhost -v -C -d template1 <backup file name>
		service apache2 start
		``
	
