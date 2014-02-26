class PortionsController < ApplicationController
  before_action :set_portion, only: [:show, :edit, :update, :destroy]

  # GET /portions
  # GET /portions.json
  def index
    @portions = Portion.current #all commented out after scope creation
  end

  # GET /portions/1
  # GET /portions/1.json
  def show
  end

  # GET /portions/new
  def new
    @portion = Portion.new
  end

  # GET /portions/1/edit
  def edit
  end

  # POST /portions
  # POST /portions.json
  def create
    @portion = Portion.new(portion_params)

    respond_to do |format|
      if @portion.save
        format.html { redirect_to @portion, notice: 'Portion was successfully created.' }
        format.json { render action: 'show', status: :created, location: @portion }
      else
        format.html { render action: 'new' }
        format.json { render json: @portion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /portions/1
  # PATCH/PUT /portions/1.json
  def update
    respond_to do |format|
      if @portion.update(portion_params)
        format.html { redirect_to @portion, notice: 'Portion was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @portion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /portions/1
  # DELETE /portions/1.json
  def destroy
    @portion.destroy
    respond_to do |format|
      format.html { redirect_to portions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_portion
      @portion = Portion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def portion_params
      params.require(:portion).permit(:amount, :expenses_id, :payee_id)
    end
end
