require 'braintree'
require 'hoiio'

class FundingsController < ApplicationController
  before_action :set_funding, only: [:show, :edit, :update, :destroy, :fulfil, :prcs]

  # GET /fundings
  # GET /fundings.json
  def index
    @fundings = Funding.all
  end

  # GET /fundings/1
  # GET /fundings/1.json
  def show
  end

  # GET /fundings/new
  def new
    @funding = Funding.new
  end

  # GET /fundings/1/edit
  def edit
  end

  # POST /fundings
  # POST /fundings.json
  def create
    @funding = Funding.new(funding_params)

    respond_to do |format|
      if @funding.save
        format.html { redirect_to @funding, notice: 'Funding was successfully created.' }
        format.json { render :show, status: :created, location: @funding }
      else
        format.html { render :new }
        format.json { render json: @funding.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fundings/1
  # PATCH/PUT /fundings/1.json
  def update
    respond_to do |format|
      prm = funding_params
      prm = prm.delete_if{|k,v| k=='photo'}
      if @funding.update(prm)
        format.html { redirect_to @funding, notice: 'Funding was successfully updated.' }
        format.json { render :show, status: :ok, location: @funding }
      else
        format.html { render :edit }
        format.json { render json: @funding.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fundings/1
  # DELETE /fundings/1.json
  def destroy
    @funding.destroy
    respond_to do |format|
      format.html { redirect_to fundings_url, notice: 'Funding was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def fulfil
    @ctok = Braintree::ClientToken.generate
  end

  def prcs
    nce = params['payment_method_nonce']
    amt = params['amount'].strip if params['amount'] and !params['amount'].empty?
    rst = Braintree::Transaction.sale(
      :amount=>amt,
      :options => {:submit_for_settlement => true},
      :payment_method_nonce => nce
    )
    if rst.success?
      @status = rst.transaction.status
      @funding.amtCurrent = @funding.amtCurrent + amt.to_i
      @funding.save
      puts ENV['HOIIO_APP']
      Hoiio.send_voice_call(ENV['PHONE_TO_CALL'],"This is a message for Grandpa Tan. Thank you for your generous donation")
    else
      @status = rst.errors + " " +  rst.transaction.status
    end
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_funding
      @funding = Funding.find(params[:id])
      @funding.amtTarget = 0 unless @funding.amtTarget
      @funding.amtCurrent = 0 unless @funding.amtCurrent
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def funding_params
      p = params.require(:funding).permit(:title, :content, :photo, :amtTarget, :amtCurrent)
      p['amtTarget'] = p['amtTarget'].to_i if p['amtTarget']
      p['amtCurrent'] = p['amtCurrent'].to_i if p['amtTarget']
      p
    end
end
