class CompaniesController < ActionController::Base
  before_action :set_company, only: [:show, :edit, :update, :destroy]
  layout 'application'

  def index
    @companies = Company.all.includes(:users)
  end

  def show;end

  def new
    @company = Company.new(company_params)
  end

  def create
    if @company.save
      redirect_to @company
    else
      render :new
    end
  end

  def edit;end

  def update
    if @company.update(company_params)
      redirect_to @company
    else
      render :edit
    end
  end

  def destroy
    if @company.users.any?
      flash[:notice] = "Company has users, cannot delete"
      redirect_to @company
    else
      @company.destroy
      flash[:notice] = "Company deleted"
      redirect_to companies_path
    end
  end

  

  private

  def company_params
    params.require(:company).permit(:name)
  end

  def set_company
    @company = Company.find(params[:id])
  end
end