namespace :versions do
  desc 'Detect and update database with new information available from cran servers'
  task :load => :environment do
    require 'cran'
    logger = Rails.logger

    start_time = Time.current

    logger.info "Loading full package list..."
    list = Cran::Server.new.packages

    new_packages, new_versions, new_maintainers = 0, 0, 0
    logger.info "Start iterating over packages..."

    list.each_with_index do |pkg, idx|
      progress = (idx + 1).to_f / list.size * 100
      logger.info "Progress #{progress.round(2).to_s.rjust(6)}% | Package #{(idx + 1).to_s.rjust(Math.log10(list.size) + 1)} of #{list.size}" if (idx + 1) % 100 == 0

      curr_pkg = Package.find_or_initialize_by(name: pkg.name)
      curr_version = curr_pkg.versions.find_or_initialize_by(value: pkg.last_version_value)
      next if curr_version.persisted?

      logger.info "Fetching new version #{pkg.name} v#{pkg.last_version_value}"

      remote_version = pkg.last_version
      remote_version.fetch
      curr_version.publication = remote_version.publication
      curr_version.title = remote_version.title
      curr_version.description = remote_version.description
      curr_version.authors = remote_version.authors
      curr_maintainer = Maintainer.find_or_initialize_by(email: remote_version.maintainer.email)
      curr_maintainer.name ||= remote_version.maintainer.name
      curr_version.maintainer = curr_maintainer

      new_packages += 1 unless curr_version.package.persisted?
      new_maintainers += 1 unless curr_version.maintainer.persisted?
      new_versions += 1

      maintainer = "#{curr_version.maintainer.name} <#{curr_version.maintainer.email}>"
      maintainer += ' (NEW MAINTAINER)' if curr_version.maintainer.persisted?
      version = "#{curr_version.package.name} v#{curr_version.value}"
      version += ' (NEW PACKAGE)' if curr_version.maintainer.persisted?

      logger.info "Saving new version #{version} - #{maintainer}"

      curr_version.save
    end

    end_time = Time.current
    duration = (end_time - start_time)
    duration_str = duration > 1.minute ? "#{(duration / 1.minute).round(2)} minutes" : "#{duration.round(2)} seconds"
    logger.info "Finished in #{duration_str}."
    if new_versions.zero?
      logger.info "No new version was found."
    else
      logger.info "Added #{new_versions.size} new versions, #{new_packages.size} new packages and #{new_maintainers.size} new maintainers."
    end
  end
end
