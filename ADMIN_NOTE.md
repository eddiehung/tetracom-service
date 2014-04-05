
Server-side Installation 
=======================

For root access, CSG does not provide sudo, please use Kerberized super-user (ksu). [Reference] (http://www.doc.ic.ac.uk/csg/services/authentication)

1. Contact CSG to set up your ksu password.

2. Ask CSG to set your default shell to be bash (otherwise Capistrano will not work properly).

3. Generate key, put public key on GitHub. [Reference] (https://help.github.com/articles/generating-ssh-keys)

4. Install RVM + Ruby + Gem + Rails (Need root access)

		\curl -sSL https://get.rvm.io | bash -s stable --rails --ruby=1.9.3
		echo '[[ -s "/usr/local/rvm/scripts/rvm" ]] && . "/usr/local/rvm/scripts/rvm" >> ~/.bashrc

5. Allow CC group member to write to the RVM directory (Need root access)

		chown root:cc -R /usr/local/rvm

6. Install Apache and PostgreSQL

		aptitude install apache2 postgresql-common postgresql-9.3 libpq-dev

7. Install gems for production (May need root access, check permission of $GEM_PATH)

		gem install bundler
		gem install pg
		gem install passenger
		passenger-install-apache2-module
		bundle install

8. Configure Apache

		vim /etc/apache2/http.conf


		1 LoadModule passenger_module /usr/local/rvm/gems/ruby-1.9.3-p545/gems/passenger-4.0.40/buildout/apache2/mod_passenger.so
		2    <IfModule mod_passenger.c>
		3      PassengerRoot /usr/local/rvm/gems/ruby-1.9.3-p545/gems/passenger-4.0.40
		4      PassengerDefaultRuby /usr/local/rvm/gems/ruby-1.9.3-p545/wrappers/ruby
		5    </IfModule>
		6 
		7 <VirtualHost *:80>
		8     ServerName tetracom-service.doc.ic.ac.uk
		9     ServerAlias cvm-tetracom.doc.ic.ac.uk
		10     Redirect permanent / https://tetracom-service.doc.ic.ac.uk/
		11 </VirtualHost>
		12 
		13 <VirtualHost *:443>
		14     SSLEngine on
		15     SSLCertificateFile /etc/apache2/ssl.crt/tetracom-service.doc.ic.ac.uk.crt
		16     SSLCertificateKeyFile /etc/apache2/ssl.key/tetracom-service.doc.ic.ac.uk.key
		17     DocumentRoot /var/www/tetracom-service/current/public
		18     ServerName tetracom-service.doc.ic.ac.uk
		19     ServerAlias cvm-tetracom.doc.ic.ac.uk
		20     RailsEnv production
		21     <Directory /var/www/tetracom-service/current/public>  
		22         SSLRequireSSL
		23         Options -MultiViews
		24     </Directory>
		25 </VirtualHost>


		a2enmod ssl
		a2enmod headers

9. Set up document root
		
		mkdir /var/www/tetracom-serviec
		chown -R root:cc /var/www/tetracom-service
		chmod -R 775 /var/www/tetracom-service

10. Set up SSL certificate
	* Ask CSG to create a CSR (signing request) with ICT, and get a *.key (Key) and a *.crt (certificate).
	* Put them as /etc/apache2/ssl.crt/tetracom-service.doc.ic.ac.uk.crt and /etc/apache2/ssl.key/tetracom-service.doc.ic.ac.uk.key
	* Set both the key and certificate as read only by root (chmod 400).

Client-side Setting
=======================

1. Generate SSH key, put public key on the server (for Capistrano) and GitHub

2. Install RVM + Ruby + Gem + Rails (May need sudo or root access, depending on your client machine settings)

		\curl -sSL https://get.rvm.io | bash -s stable --rails --ruby=1.9.3
		echo '[[ -s "/usr/local/rvm/scripts/rvm" ]] && . "/usr/local/rvm/scripts/rvm" >> ~/.bashrc

3. Get source code from GitHub

		cd <your-project-directory>
		git clone git@github.com:custom-computing-ic/tetracom-service.git

4. Install gems for development

		cd <tetracom-service>
		gem install bundler
		rvmsudo bundle install --without production

5. Edit Capistrano settings 

		vim config/deploy/production.rb
		Change cpc10 to your user name

Development and Deployment
=======================

1. Do your own development, to run development server

		// Put database.yml under config/
		rake db:migrate
		rails s -p 55558

2. Commit the updates to GitHub

		git add .
		git commit -m "<log message>"
		git push origin

3. Deploy the source code (update the production server)

		cap production deploy

4. If some things fail after deployment, it is useful to check ``/var/log/apache2/error.log`` on the server.

Admin Web Interface
=======================

There is an admin interface for users with admin privilege.

* Click Experts, you can see several functions next to every user name.
	* edit: Change user details, including reset password.
	* set_admin: set the permission of user to admin.
	* set_normal: set the permission of user to normal.
	* delete: delete user account.

* Admin can see if a user has set their name to be hidden.

Database Administration
=======================

### Account information

* Check the user name, password and database name in the server ``/var/www/tetracom-service/shared/config/database.yml``

### Backup

		pg-dump -U <user name> -h localhost -Fc -f <backup file name> <database name>

### Restore data

		service apache2 stop
		dropdb -U <user name> -h localhost <database name>
		pg-restore -U <user name> --password -h localhost -v -C -d template1 <backup file name>
		service apache2 start

### Access database via command prompt

		psql -U <user name> -h localhost -d <database name>

### Access database via rails console

		Login cvm-tetracom
		Go to /var/www/tetracom-service/current/
		rails console production
		//useful commands:
		//	User.find(1)
		//	User.find_by(name: "")
		//	User.set_attribute(:admin, false)
	
Useful Websites
=======================

I have modified the steps and settings to cope with our specific environment, the following information is for reference only.

* [Ruby Version Manager (RVM)](http://rvm.io/)
* [How To Setup Ruby on Rails with Postgres](https://www.digitalocean.com/community/articles/how-to-setup-ruby-on-rails-with-postgres)
* [How to Create and Install an Apache Self Signed Certificate](https://www.sslshopper.com/article-how-to-create-and-install-an-apache-self-signed-certificate.html)
* [Ruby on Rails Tutorial](http://ruby.railstutorial.org/ruby-on-rails-tutorial-book)

