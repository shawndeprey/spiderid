## Spider ID

This is the web application for spiderid, a business utility, network and
marketplace for companies to connect with emerging media, platforms and
technologies using the wisdom of your most trusted partners and employees.

The spiderid web application is responsible for:

- The spiderid API
- User Administration
- Maintaining the spider database for the spiderid API

## Configuring Your Local Environment

In order to contribute to development of the spiderid web app, you'll need to
set-up your local environment.

### Vagrant and Virtualbox

spiderid uses Virtual Machines to maintain environments for developers.
In order to make this easy, Vagrant is used on top of Virtualbox.

So, install both Virtualbox and Vagrant by following their automated
installers.

- [Vagrant Download](http://downloads.vagrantup.com/)
- [Virtualbox Download](https://www.virtualbox.org/wiki/Downloads)

### Launching the Virtual Machine

Once you clone this repository, change to it, i.e `cd code/spiderid/web/` and
run:

    vagrant up

Your virtual machine will now be automatically downloaded, installed and
configured to run the spiderid web application.

### Interacting with the Virtual Machine

In order to run the web server and interact with the database of the
application, you'll need to SSH into the Virtual Machine.

From your project directory, this is simply:

    vagrant ssh

You'll then be in the virtual machine shared folder. Any changes you make
on your host computer will be instantly reflected into the Virtual Machine's
file system.

### Preparing the Web Application

Initially, and periodically afterwards, you may need to update
the gems for the application. From inside the VM, just run:

    bundle

Gems will be updated and installed as necessary.

The first time you provision your VM, you'll need to create a database.

    rake db:create

Initially, and periodically, you'll need to migrate the database schema.

    rake db:migrate

### Running the Web Application

Run the server:

    foreman start

### Accessing the Web Application

You may need to access the web application from outside of the VM.

You can do so by accessing the VM's manually assigned IP address, and
the port of the application.

    30.30.30.11:5000

## Dependency Changes

As development continues, dependencies are likely to change. The best
way to make sure you're up to date is by running these commands.

From outside the VM:

    vagrant provision

Inside the VM:

    bundle update

Configure your Database by running the following commands in order. This only needs to be done
once and this only needs to be done if rake db:create throws the UTF-8 encoding error:

    sudo su postgres
    pg_dropcluster --stop 9.1 main ; pg_createcluster --start --locale en_US.UTF-8 9.1 main
    exit
    sudo -u postgres createuser -s spiderid_development
    sudo -u postgres psql -c "ALTER USER spiderid_development WITH PASSWORD 'spiderid_development'"
    rake db:create
    rake db:migrate

That should bring you fully up to date. If you would like test companies and an admin user account seeded, Inside the VM:

    rake db:seed

To connect to your PostgreSQL Database do the following.

    sudo su postgres
    psql

## Troubleshooting

VM's and there providers (Virtualbox) can sometimes misbehave.

Your first solution should usually be to restart the VM.

    vagrant reload

If that fails, try forcing it to shutdown, then launching it again.

    vagrant halt -f
    ...
    vagrant up

It's best not to waste time debugging issues within the VM  beyond
restarting it. Because the environment is fully reproducible, you
can simply destroy the VM and re-provision a new one.

    vagrant destroy [-f]
    ...
    vagrant up

If your database is throwing errors when starting your server, you may just need to restart the DB

    sudo /etc/init.d/postgresql restart

ImageMagick is installed via the vagrant provision. To ensure ImageMagick was
installed correctly, run the following command.

    which convert

This should give you output like the following.

    /usr/local/bin/convert

*Sometimes, you need to force the VM to be destroyed with the `-f` flag.*

Once the VM finishes provisioning, you'll have a brand new environment
to work from.
