# README

R Community Package listing with direct links to CRAN package hosting servers.

## About [CRAN](https://cran.r-project.org)
CRAN stands for Comprehensive R Archive Network and provides hosting for currently 8000+ R packages publicly available and open sourced. 

## Purpose

* Provide better web interface for finding R projects and open sourced code.
* Improve visibility of package authors and maintainers and easier way to contact them.
* Minimal search functionality

## Inspiration

* This project was inspired by a code challenge and attempt to mirror what rubygems.org does for the Ruby community, it is currently deployed on a free tier instance of Heroku.

## Further improvements (if only I had more time)
* Design is primitive and focused on minimum usability. Although using twitter bootstrap allows for cross device development some issues may arise when using smaller screens.
* Improve overall test coverage, specially for search functionality and web interface currently not covered.
* Add dependencies to each package version information allowing for dependency checking and maybe even provide an API similar to Rubygems.org's one where updating packages is made easier with tools like bundle while taking care of version conflicts.
* Hosting packages themselves and link to them would allow to provide some download counters which would help to track most used packages and use that to serve as the base for a package rating system.
* Better parsing of authors would allow for keeping better indexed information on who is involved on each project, not addressed until now since there is no fixed syntax where some packages list only comma sepparated names, others list emails and others include simple descriptions including non name words like 'and'.
* Add user accounts linkable to maintainers would allow them to take ownership of the gems and list their own gems on their profile view.


## Technical description

* Package full listing source comes from [CRAN R Project](https://cran.r-project.org/src/contrib/PACKAGES)
* Further information about each package is fetched by reading each `DESCRIPTION`file of inside each package tarball.
* Rails 5 application: since it is almost production ready I figured it would be a nice way for me to get used to latest changes on the framework and it was highly educational for me personally.
* Debian Control Files parsing was initially and better achieved by using [`treetop-dcf`](https://rubygems.org/gems/debian-control-parser) gem, although it required a huge amount of memory, since it provided no iterators and constructed a full node tree in memory, which was too much resource consuming. I later decided to switch for [`debian_control_parser`](https://rubygems.org/gems/treetop-dcf) wich is much less resource consuming by providing a lower level api access to each package and field while parsing which reduced parsing time from around 20 seconds to 0.2 seconds given the current 8000+ packages contained on the initial listing from CRAN servers. The downside is that the latter more performant gem is not perfect when parsing fields containing multiline text often including newline characters and multiple spaces.
* A Rake Task was defined to run every 24 hours to fetch new versions and update package information gathered.
* Current landing page delivers a full listing of all packages available, minimal searching functionality by either name, title and description of each package and updated statistics about the amount of packages, respective versions and overall maintainers.
* Uses twitter-bootstrap for view implementation
* Minimum spec/test coverage was taken care of focusing primarily on making sure the core pieces where working together and interfaces where not broken.

### Rake Tasks

* `rake versions:load` both seeds the database with initial data and also updates that information in subsequent runs.
