class QuestionnairesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @questionnaire_pages, @questionnaires = paginate :questionnaires, :per_page => 10
  end

  def show
    @questionnaire = Questionnaire.find(params[:id])
  end

  def new
    @questionnaire = Questionnaire.new
  end

  def create
    @questionnaire = Questionnaire.new(params[:questionnaire])    
    @questionnaire.status = "new"
    
    if @questionnaire.save
      flash[:notice] = 'Questionnaire was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @questionnaire = Questionnaire.find(params[:id])
  end

  def update
    @questionnaire = Questionnaire.find(params[:id])
    if @questionnaire.update_attributes(params[:questionnaire])
      flash[:notice] = 'Questionnaire was successfully updated.'
      redirect_to :action => 'show', :id => @questionnaire
    else
      render :action => 'edit'
    end
  end

  def destroy
    Questionnaire.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
end
