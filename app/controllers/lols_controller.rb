class LolsController < ApplicationController
  before_action :set_lol, only: %i[ show edit update destroy ]

  # GET /lols or /lols.json
  def index
    @lols = Lol.all
  end

  # GET /lols/1 or /lols/1.json
  def show
  end

  # GET /lols/new
  def new
    @lol = Lol.new
  end

  # GET /lols/1/edit
  def edit
  end

  # POST /lols or /lols.json
  def create
    @lol = Lol.new(lol_params)

    respond_to do |format|
      if @lol.save
        format.html { redirect_to lol_url(@lol), notice: "Lol was successfully created." }
        format.json { render :show, status: :created, location: @lol }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @lol.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lols/1 or /lols/1.json
  def update
    respond_to do |format|
      if @lol.update(lol_params)
        format.html { redirect_to lol_url(@lol), notice: "Lol was successfully updated." }
        format.json { render :show, status: :ok, location: @lol }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lol.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lols/1 or /lols/1.json
  def destroy
    @lol.destroy

    respond_to do |format|
      format.html { redirect_to lols_url, notice: "Lol was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lol
      @lol = Lol.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def lol_params
      params.fetch(:lol, {})
    end
end
