class PagesController < ApplicationController
skip_before_filter :authenticate_user!, only: [:index]

  def index
  end

  def contact
  end

  def about
  end

end