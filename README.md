# Punerb.org

## What is this website all about?

Punerb.org is a reflection of the Ruby User Group (RUG) in Pune. It is a place where we share relevant knowledge and propagate Ruby skill.

### The first rule about PuneRUG.. Just kidding.. Find us here:

* Website - `punerb.org`
* IRC - `#punerb` on freenode
* Mailing List - `https://groups.google.com/forum/#!forum/puneruby`

### So, you have and idea (or you found a bug)?!

To share an idea (or report a bug), just use github issues:

1. Go to the [GitHub Issues page](https://github.com/xipcraft/punerb.org/issues)
* Check if your Idea or Bug has already been submitted.
* Can't find it? Create a [New issue](https://github.com/xipcraft/punerb.org/issues/new)
* Give it a nice title. Provide a discription, if needed.
* Add a relevant tag like `enhancement` for ideas or `bug` for a bug.
* Send it!

### Ah, you want to contribute..

To add a new feature, it is recommended that you follow this procedure:

1. Assuming you're starting from a git-committed state. If not, commit or stash your code just before you start on the feature.
* Create and checkout to a branch appropriately named, for example `git checkout -b super_sexy_feature`.
* Code, commit and push to that branch. You can use `git push origin super_sexy_feature` to keep things in sync with GitHub online.
* Once you are happy with the feature, (and all the tests pass) submit a [new Pull Request](https://github.com/xipcraft/punerb.org/pulls) to the [punerb.org repo on GitHub](https://github.com/xipcraft/punerb.org).

**Why bother?:** This process helps keep the demons out of the code. Get with it!

**If it's a very minor edit:** then you can make those changes in your Master branch itself, and send a Pull Request.

### Local Setup

#### Prereqisites
Before starting out, install or setup the following:

* HomeBrew (for Mac users.)
* Git
* Github
* GitHub for Eclipse (For those eclipse lovers.)
* Ruby Version Manager
* Rubygems
* Redis

#### Booting the app

0. Get Redis server started on it's defaults. I don't see why you'd ever want to switch it off.
1. Make sure you are running the correct Ruby version. If you are using `rvm`, then simply navigating to the project directory should sort you out.
1. Navigate to project directory and run `gem install bundler cucumber rspec`.
2. Now run `bundle install` from the project directory.
3. Run `bundle exec rackup config.ru -p 3000` from the project directory. Note that you can replace `3000` with the port of your choice.
4. Use a browser, curl or any HTTP API tester to visit `localhost:3000`.

#### Running all RSpec unit tests

* Just run `rspec .` from the app directory.

**Note:** Applying `:focus` tags on any unit tests or suites will focus the command on those tests only.

#### Running all Cucumber integration tests

* Just run `cucumber` from the app directory.