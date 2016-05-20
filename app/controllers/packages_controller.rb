class PackagesController < ApplicationController
  def index
    @packages = Package.includes(:maintainer, :latest_version)
    @packages = @packages.search_query(params[:search]) if params[:search].present?
    @packages = @packages.paginate(page: params[:page])
  end
end
