class StudentsController < ApplicationController
    before_action :authenticate_user!
  before_action :set_student, only: [:show, :update, :destroy]
  before_action :authorize_student, only: [:update, :destroy]
  def index
    @students = Student.all
    render json: @students
  end
  def show
    render json: @student
  end
  def create
    @student = Student.new(student_params)
    @student.user = current_user 

    if @student.save
      render json: @student, status: :created
    else
      render json: @student.errors, status: :unprocessable_entity
    end
  end
  
  def update
    if @student.update(student_params)
      render json: @student
    else
      render json: @student.errors, status: :unprocessable_entity
    end
  end
  def destroy
    @student.destroy
    head :no_content
  end

  private
  def set_student
    @student = Student.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Student not found" }, status: :not_found
  end

  def authorize_student
    unless @student.user == current_user
      render json: { error: "You are not authorized to modify this student" }, status: :forbidden
    end
  end

  def student_params
    params.require(:student).permit(:name, :age, :grade, :subject_ids => [])
  end
end
