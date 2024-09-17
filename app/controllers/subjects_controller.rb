class SubjectsController < ApplicationController
    before_action :authenticate_user!
  before_action :set_subject, only: [:show, :update, :destroy]
  before_action :authorize_teacher, only: [:create, :update, :destroy]

  
  def index
    @subjects = Subject.all
    render json: @subjects
  end

  
  def show
    render json: @subject
  end

  
  def create
    @subject = Subject.new(subject_params)
    @subject.teacher = current_user.teacher 
    if @subject.save
      render json: @subject, status: :created
    else
      render json: @subject.errors, status: :unprocessable_entity
    end
  end

  
  def update
    if @subject.update(subject_params)
      render json: @subject
    else
      render json: @subject.errors, status: :unprocessable_entity
    end
  end

 
  def destroy
    @subject.destroy
    head :no_content
  end

  private

  
  def set_subject
    @subject = Subject.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Subject not found" }, status: :not_found
  end

  
  def authorize_teacher
    unless current_user.teacher
      render json: { error: "You are not authorized to modify subjects" }, status: :forbidden
    end
  end


  def subject_params
    params.require(:subject).permit(:title, :description)
  end
end
