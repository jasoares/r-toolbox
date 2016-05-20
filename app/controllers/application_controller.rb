class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :load_stats

  def load_stats
    @package_count = Package.count
    @version_count = Version.count
    @maintainer_count = Maintainer.count
  end
end
