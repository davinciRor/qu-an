class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :redirect_if_not_own_question, only: [:edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = current_user.questions.build
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @question.update(question_params)
      flash[:notice] = 'Question was successfully update!'
      redirect_to @question
    else
      flash[:notice] = 'You fill invalid data!'
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def redirect_if_not_own_question
    if current_user.id != @question.user_id
      redirect_to :back
    end
  end
end
