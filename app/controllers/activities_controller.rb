class ActivitiesController < ApplicationController
  def index
  	@activities = PublicActivity::Activity.order("created_at desc")
  	respond_to do |format|
  		format.html { render action: 'index' }
        format.json { render json: @activities }
  	end
  end
end
